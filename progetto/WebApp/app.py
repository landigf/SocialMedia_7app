from flask import Flask, jsonify, render_template, request, redirect, url_for, session, flash
from helper import *
import mysql.connector



app = Flask(__name__)
app.secret_key = "c3fa0f1c832b4e9f8dcb0e6425f9e1a6"  # cambia con una chiave forte se metti l'app online
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"


# ---------- AUTH ----------
@app.route("/", methods=["GET"])
def home():
    if session.get("user_id"):
        return redirect(url_for("feed"))
    return redirect(url_for("login"))

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"].strip()
        password = request.form["password"].strip()
        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute(
            '''
            SELECT C.ID_Utente, U.Nickname
            FROM UTENTE_CREDENZIALI C
            JOIN UTENTE U ON U.ID_Utente = C.ID_Utente
            WHERE C.E_mail=%s AND C.Pass=SHA2(%s, 256)
            ''',
            (email, password)
        )
        user = cur.fetchone()
        conn.close()
        if user:
            session["user_id"] = user["ID_Utente"]
            session["nickname"] = user["Nickname"]
            return redirect(url_for("feed"))
        flash("Credenziali non valide.", "danger")
    return render_template("login.html")

@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        nickname = request.form["nickname"].strip()
        email    = request.form["email"].strip()
        password = request.form["password"].strip()

        conn = get_db_connection()
        cur  = conn.cursor()

        try:
            # 1. crea l'utente (altri campi NULL per ora)
            cur.execute("""
                INSERT INTO UTENTE
                      (Nickname, Nome, Data_di_nascita, Genere, Pronomi, Biografia, Link)
                VALUES (%s,       NULL, NULL,          NULL,  NULL,   NULL,     NULL)
            """, (nickname,))

            id_utente = cur.lastrowid

            # 2. credenziali
            cur.execute("""
                INSERT INTO UTENTE_CREDENZIALI
                      (ID_Utente, E_mail, Pass)
                VALUES (%s,        %s,     SHA2(%s, 256))
            """, (id_utente, email, password))

            conn.commit()
            flash("Registrazione riuscita! Ora effettua il login.", "success")
            return redirect(url_for("login"))

        except mysql.connector.Error as e:
            conn.rollback()
            flash(f"Errore MySQL: {e.msg}", "danger")

        finally:
            conn.close()

    return render_template("register.html")


@app.route("/logout")
def logout():
    session.clear()
    flash("Logout effettuato.", "info")
    return redirect(url_for("login"))

# ---------- FEED ----------
@app.route("/feed")
def feed():
    if not session.get("user_id"):
        return redirect(url_for("login"))

    uid      = session["user_id"]
    trending = request.args.get("trending") == "yes"

    # Se si passa a trending e ho un feed precedente, registro le view
    if trending and session.get("last_feed_posts"):
        conn_tmp = get_db_connection()
        cur_tmp  = conn_tmp.cursor()
        cur_tmp.executemany("""
            INSERT IGNORE INTO Interazioni
                (ID_Utente, ID_Autore, Data_ora, Tipo_interazione)
            VALUES (%s,        %s,        %s,       'view')
        """, [(uid, a, d) for a, d in session["last_feed_posts"]])
        conn_tmp.commit()
        cur_tmp.close()
        conn_tmp.close()
        session.pop("last_feed_posts", None)   # pulisco

    commonsql = """
        SELECT
            P.ID_Autore,
            P.Data_ora,
            U.Nickname                            AS NicknameAutore,
            P.Contenuto,
            /* contatori reazioni */
            SUM(CASE WHEN FB.ID_Reazione=1 THEN 1 ELSE 0 END) AS R1,
            SUM(CASE WHEN FB.ID_Reazione=2 THEN 1 ELSE 0 END) AS R2,
            SUM(CASE WHEN FB.ID_Reazione=3 THEN 1 ELSE 0 END) AS R3,
            SUM(CASE WHEN FB.ID_Reazione=4 THEN 1 ELSE 0 END) AS R4,
            SUM(CASE WHEN FB.ID_Reazione=5 THEN 1 ELSE 0 END) AS R5,
            SUM(CASE WHEN FB.ID_Reazione=6 THEN 1 ELSE 0 END) AS R6,
            /* reazione dell’utente loggato (NULL se assente) */
            MAX(CASE WHEN FB.ID_Utente = %(uid)s
                     THEN FB.ID_Reazione END)               AS MyReaction,
            MAX(V.PunteggioFinale)                          AS PunteggioFinale
        FROM SmartFeed_V       V
        JOIN POST              P  ON P.ID_Autore = V.ID_Autore
                                 AND P.Data_ora  = V.Data_ora
        JOIN UTENTE            U  ON U.ID_Utente = P.ID_Autore
        LEFT JOIN FEEDBACK     FB ON FB.ID_Autore     = P.ID_Autore
                                 AND FB.Data_ora_post = P.Data_ora
        WHERE P.ID_Autore_fonte IS NULL                /* esclude commenti */
            AND P.ID_Autore != %(uid)s                 /* esclude i propri post */
            AND NOT EXISTS (                         /* rimuove quelli già visti */
                SELECT 1
                FROM Interazioni I
                WHERE I.ID_Utente     = %(uid)s
                AND I.ID_Autore     = P.ID_Autore
                AND I.Data_ora      = P.Data_ora
                AND I.Tipo_interazione = 'view'
            )
    """

    if trending:
        sql = commonsql + """
            GROUP BY P.ID_Autore, P.Data_ora, U.Nickname, P.Contenuto
            ORDER BY PunteggioFinale DESC
            LIMIT 20
        """
        params = {"uid": uid}
    else:
        sql = commonsql + """
              AND V.ID_Utente = %(uid)s
            GROUP BY P.ID_Autore, P.Data_ora, U.Nickname, P.Contenuto
            ORDER BY PunteggioFinale DESC
            LIMIT 20
        """
        params = {"uid": uid}

    conn = get_db_connection()
    cur  = conn.cursor(dictionary=True)
    cur.execute(sql, params)
    posts = cur.fetchall()
    # Salvo in session l’elenco dei post del feed corrente
    session["last_feed_posts"] = [(p["ID_Autore"], str(p["Data_ora"])) for p in posts]


    # -------- registra "view" per ogni post mostrato --------
    '''view_rows = [(uid, p["ID_Autore"], p["Data_ora"]) for p in posts]
    if view_rows:
        cur.executemany("""
            INSERT IGNORE INTO Interazioni    /* evita duplicati */
                  (ID_Utente, ID_Autore, Data_ora, Tipo_interazione)
            VALUES (%s,        %s,        %s,        'view')
        """, view_rows)
        conn.commit()'''

    conn.close()
    return render_template("feed.html", posts=posts, trending=trending)

# ---------- CREATE POST ----------
@app.route("/post/new", methods=["GET", "POST"])
def create_post():
    if not session.get("user_id"):
        return redirect(url_for("login"))

    if request.method == "POST":
        content = request.form["content"].strip()

        conn = get_db_connection()
        cur  = conn.cursor()
        cur.execute(
            """
            INSERT INTO POST
                  (ID_Autore, Data_ora, Contenuto, Sensibile, Modificato)
            VALUES (%s,        NOW(),    %s,        0,         0)
            """,
            (session["user_id"], content)
        )
        conn.commit()
        conn.close()

        flash("Post pubblicato!", "success")
        return redirect(url_for("feed"))

    return render_template("create_post.html")


# ---------- POST DETAIL + COMMENT ----------
@app.route("/post/<int:id_autore>/<path:data_ora>", methods=["GET", "POST"])
def post_detail(id_autore, data_ora):
    if not session.get("user_id"):
        return redirect(url_for("login"))

    conn = get_db_connection()
    cur  = conn.cursor(dictionary=True)

    # 1. registra la visualizzazione
    cur.execute("""
        INSERT IGNORE INTO Interazioni
              (ID_Utente, ID_Autore, Data_ora, Tipo_interazione)
        VALUES (%s,        %s,        %s,       'view')
    """, (session["user_id"], id_autore, data_ora))
    conn.commit()   # commit subito, poi prosegui

    # 2. inserimento commento eventualmente inviato dal form (come prima)
    if request.method == "POST":
        comment = request.form["comment"].strip()
        cur.execute("""
            INSERT INTO POST
                  (ID_Autore, Data_ora,
                   ID_Autore_fonte, Data_ora_fonte,
                   Contenuto, Sensibile, Modificato)
            VALUES (%s,      NOW(),
                    %s,      %s,
                    %s,      0, 0)
        """, (session["user_id"], id_autore, data_ora, comment))
        conn.commit()
        flash("Commento aggiunto!", "success")

    # 3. recupero post + commenti (come già avevi)
    cur.execute("""
        SELECT P.Contenuto, U.Nickname, P.Data_ora
        FROM POST P
        JOIN UTENTE U ON U.ID_Utente = P.ID_Autore
        WHERE P.ID_Autore = %s AND P.Data_ora = %s
    """, (id_autore, data_ora))
    post = cur.fetchone()

    cur.execute("""
        SELECT C.Contenuto, U.Nickname, C.Data_ora
        FROM POST C
        JOIN UTENTE U ON U.ID_Utente = C.ID_Autore
        WHERE C.ID_Autore_fonte = %s AND C.Data_ora_fonte = %s
        ORDER BY C.Data_ora DESC
    """, (id_autore, data_ora))
    comments = cur.fetchall()

    conn.close()
    return render_template("post_detail.html", post=post, comments=comments)


@app.route("/react", methods=["POST"])
def react():
    if not session.get("user_id"):
        return jsonify(ok=False, err="not-auth"), 401

    data = request.get_json(force=True)
    uid       = session["user_id"]
    id_autore = data["id_autore"]
    data_ora  = data["data_ora"]
    id_reaz   = int(data["id_reaz"])

    conn = get_db_connection()
    cur  = conn.cursor(dictionary=True)

    try:
        # 1) Rimuovo eventuale reazione precedente
        cur.execute(
            """
            DELETE FROM FEEDBACK
             WHERE ID_Utente     = %s
               AND ID_Autore     = %s
               AND Data_ora_post = %s
            """,
            (uid, id_autore, data_ora)
        )

        # 2) Inserisco la nuova
        cur.execute(
            """
            INSERT INTO FEEDBACK
                  (ID_Utente, ID_Autore, Data_ora_post,
                   ID_Reazione, Data_ora)
            VALUES (%s,        %s,        %s,
                    %s,        NOW())
            """,
            (uid, id_autore, data_ora, id_reaz)
        )

        # 3) Notifico l'autore
        create_notification(
            conn,
            destinatario_id=id_autore,
            tipo="reazione",
            messaggio=f"@{session['nickname']} ha reagito al tuo post.",
            id_autore_post=id_autore,
            data_ora_post=data_ora
        )

        # 4) Ricalcolo i conteggi di tutte le reazioni su questo post
        cur.execute(
            """
            SELECT ID_Reazione, COUNT(*) AS cnt
            FROM FEEDBACK
            WHERE ID_Autore = %s
              AND Data_ora_post = %s
            GROUP BY ID_Reazione
            """,
            (id_autore, data_ora)
        )
        rows = cur.fetchall()
        counts = {str(i): 0 for i in range(1,7)}
        for r in rows:
            counts[str(r["ID_Reazione"])] = r["cnt"]

        # Segna la view (se non già presente)
        cur.execute("""
            INSERT IGNORE INTO Interazioni
                (ID_Utente, ID_Autore, Data_ora, Tipo_interazione)
            VALUES (%s,        %s,        %s,       'view')
        """, (uid, id_autore, data_ora))
        conn.commit()
        return jsonify(ok=True, counts=counts, myReaction=id_reaz)

    except Exception as e:
        conn.rollback()
        return jsonify(ok=False, err=str(e)), 500

    finally:
        cur.close()
        conn.close()



# ---------- SEARCH ----------
@app.route("/search", methods=["GET", "POST"])
def search():
    if not session.get("user_id"):
        return redirect(url_for("login"))

    conn    = get_db_connection()
    cur     = conn.cursor(dictionary=True)
    q       = ""
    mode    = "all"   # può essere 'users', 'groups' o 'all'
    users   = []
    groups  = []

    if request.method == "POST":
        q    = request.form.get("q", "").strip()
        mode = request.form.get("mode", "all")
        if q:
            if mode in ("all", "users"):
                cur.execute("""
                    SELECT ID_Utente, Nickname, Nome
                    FROM UTENTE
                    WHERE (Nickname LIKE %s OR Nome LIKE %s)
                      AND ID_Utente != %s
                    ORDER BY Nickname
                    LIMIT 50
                """, (f"%{q}%", f"%{q}%", session["user_id"]))
                users = cur.fetchall()
            if mode in ("all", "groups"):
                cur.execute("""
                    SELECT ID_Gruppo, Nome, Descrizione
                    FROM GRUPPO
                    WHERE Nome LIKE %s OR Descrizione LIKE %s
                    ORDER BY Nome
                    LIMIT 50
                """, (f"%{q}%", f"%{q}%"))
                groups = cur.fetchall()

    conn.close()
    return render_template("search.html",
                           q=q,
                           mode=mode,
                           users=users,
                           groups=groups)

# ---------- PROFILE ----------
@app.route("/profile")
def profile():
    if not session.get("user_id"):
        return redirect(url_for("login"))

    # 1) Leggi il parametro facoltativo ?user_id=…
    target_id = request.args.get("user_id", type=int)
    if target_id is None:
        # nessun parametro ⇒ è il tuo profilo
        target_id = session["user_id"]
        is_own    = True
    else:
        is_own    = (target_id == session["user_id"])

    conn = get_db_connection()
    cur  = conn.cursor(dictionary=True)

    # 2) Dati dell’utente (sia tu che altri)
    cur.execute("""
        SELECT
            Nickname,
            Nome,
            Data_di_nascita   AS DataDiNascita,
            Genere,
            Pronomi,
            Biografia         AS Bio,
            Link
        FROM UTENTE
        WHERE ID_Utente = %s
    """, (target_id,))
    user = cur.fetchone()

    # 3) Conteggio post “root”
    cur.execute("""
        SELECT COUNT(*) AS cnt
        FROM POST
        WHERE ID_Autore = %s
          AND ID_Autore_fonte IS NULL
    """, (target_id,))
    post_count = cur.fetchone()["cnt"]

    # 4) Lista post “root”
    cur.execute("""
        SELECT
            P.ID_Autore,
            P.Data_ora,
            P.Contenuto
        FROM POST P
        WHERE P.ID_Autore = %s
          AND P.ID_Autore_fonte IS NULL
        ORDER BY P.Data_ora DESC
    """, (target_id,))
    posts = cur.fetchall()

    
    # is_following (solo se non è il proprio profilo)
    if not is_own:
        cur.execute("""
            SELECT 1 FROM FOLLOW
            WHERE ID_Sender=%s AND ID_Followed=%s
        """, (session["user_id"], target_id))
        is_following = cur.fetchone() is not None
    else:
        is_following = None


    # se è il tuo profilo: lista following e amici
    following = friends = []
    if is_own:
        cur.execute("""
            SELECT U.ID_Utente, U.Nickname
            FROM FOLLOW F
            JOIN UTENTE U ON U.ID_Utente = F.ID_Followed
            WHERE F.ID_Sender = %s
            ORDER BY U.Nickname
        """, (session["user_id"],))
        following = cur.fetchall()

        cur.execute("""
            SELECT U.ID_Utente, U.Nickname
            FROM FOLLOW F1
            JOIN FOLLOW F2 ON F2.ID_Sender = F1.ID_Followed
                        AND F2.ID_Followed = F1.ID_Sender
            JOIN UTENTE U ON U.ID_Utente = F1.ID_Followed
            WHERE F1.ID_Sender = %s
            ORDER BY U.Nickname
        """, (session["user_id"],))
        friends = cur.fetchall()

    conn.close()
    return render_template("profile.html",
                        user=user,
                        post_count=post_count,
                        posts=posts,
                        is_own=is_own,
                        is_following=is_following,
                        following=following,
                        friends=friends)



@app.route("/user/<int:user_id>")
def user_profile(user_id):
    if not session.get("user_id"):
        return redirect(url_for("login"))

    conn = get_db_connection()
    cur  = conn.cursor(dictionary=True)

    # Dati dell’utente visitato
    cur.execute("""
        SELECT
            Nickname,
            Nome,
            Data_di_nascita   AS DataDiNascita,
            Genere,
            Pronomi,
            Biografia         AS Bio,
            Link
        FROM UTENTE
        WHERE ID_Utente = %s
    """, (user_id,))
    user = cur.fetchone()

    # Conta i suoi post “root”
    cur.execute("""
        SELECT COUNT(*) AS cnt
        FROM POST
        WHERE ID_Autore = %s
          AND ID_Autore_fonte IS NULL
    """, (user_id,))
    post_count = cur.fetchone()["cnt"]

    # Lista dei suoi post
    cur.execute("""
        SELECT
            P.ID_Autore,
            P.Data_ora,
            P.Contenuto
        FROM POST P
        WHERE P.ID_Autore = %s
          AND P.ID_Autore_fonte IS NULL
        ORDER BY P.Data_ora DESC
    """, (user_id,))
    posts = cur.fetchall()

    conn.close()
    return render_template("profile.html",
                           user=user,
                           post_count=post_count,
                           posts=posts,
                           is_own=(user_id == session["user_id"]))


# ---------- NOTIFICATIONS ----------
@app.route("/notifications")
def notifications():
    if not session.get("user_id"):
        return redirect(url_for("login"))
    conn = get_db_connection()
    cur  = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT ID_Notifica, Tipo, Messaggio, Letta,
            ID_Autore_post, Data_ora_post, Data_ora
        FROM NOTIFICA
        WHERE ID_Destinatario = %s
        ORDER BY Letta, Data_ora DESC
    """, (session["user_id"],))
    notifs = cur.fetchall()
    conn.close()
    return render_template("notifications.html", notifs=notifs)

@app.route("/open_notification/<int:notif_id>")
def open_notification(notif_id):
    if not session.get("user_id"):
        return redirect(url_for("login"))

    conn = get_db_connection()
    cur  = conn.cursor(dictionary=True)

    cur.execute("""
        SELECT Tipo, ID_Autore_post, Data_ora_post
        FROM NOTIFICA
        WHERE ID_Notifica=%s AND ID_Destinatario=%s
    """, (notif_id, session["user_id"]))
    n = cur.fetchone()

    if not n:
        conn.close()
        return redirect(url_for("notifications"))

    # segna come letta
    cur.execute("UPDATE NOTIFICA SET Letta=1 WHERE ID_Notifica=%s", (notif_id,))
    conn.commit()
    conn.close()

    # instrada secondo il tipo
    if n["Tipo"] == "post":
        return redirect(url_for("post_detail",
                                id_autore=n["ID_Autore_post"],
                                data_ora=n["Data_ora_post"]))
    elif n["Tipo"] == "follow":
        return redirect(url_for("profile", user_id=n["ID_Autore_post"]))
    elif n["Tipo"] == "message" and n["ID_Autore_post"]:
        # se esiste in GRUPPO → chat di gruppo, altrimenti DM
        conn_chk = get_db_connection()
        cur_chk  = conn_chk.cursor()
        cur_chk.execute("SELECT 1 FROM gruppo WHERE ID_Gruppo=%s",
                        (n["ID_Autore_post"],))
        is_group = cur_chk.fetchone() is not None
        cur_chk.close()
        conn_chk.close()

        return redirect(url_for("chat_detail",
                                chat_type="group" if is_group else "user",
                                chat_id=n["ID_Autore_post"]))



# ---------- CHAT LIST ----------
@app.route("/chats")
def chats():
    if not session.get("user_id"):
        return redirect(url_for("login"))

    uid  = session["user_id"]
    conn = get_db_connection()
    cur  = conn.cursor(dictionary=True)

    # chat individuali
    cur.execute("""
        SELECT
            CASE WHEN mi.ID_Sender = %(uid)s
                 THEN mi.ID_Ricevente
                 ELSE mi.ID_Sender
            END               AS OtherID,
            u.Nickname        AS Nick,
            MAX(mi.Data_ora)  AS LastMsg
        FROM messaggio_individuale mi
        JOIN utente u ON (u.ID_Utente = mi.ID_Sender OR u.ID_Utente = mi.ID_Ricevente)
        WHERE (mi.ID_Sender = %(uid)s OR mi.ID_Ricevente = %(uid)s)
          AND u.ID_Utente != %(uid)s
        GROUP BY OtherID, u.Nickname
        ORDER BY LastMsg DESC
        LIMIT 20
    """, {"uid": uid})
    users = cur.fetchall()

    # chat di gruppo
    cur.execute("""
        SELECT g.ID_Gruppo, g.Nome, MAX(mg.Data_ora) AS LastMsg
        FROM messaggio_di_gruppo mg
        JOIN gruppo g           ON g.ID_Gruppo = mg.ID_Gruppo
        JOIN gruppo_has_utente gh ON g.ID_Gruppo = gh.ID_Gruppo
        WHERE gh.ID_Utente = %(uid)s
        GROUP BY g.ID_Gruppo, g.Nome
        ORDER BY LastMsg DESC
        LIMIT 20
    """, {"uid": uid})
    groups = cur.fetchall()

    conn.close()
    return render_template("chat_list.html", users=users, groups=groups)


# ---------- CHAT DETAIL ----------
@app.route("/chat/<chat_type>/<int:chat_id>", methods=["GET", "POST"])
def chat_detail(chat_type, chat_id):
    if not session.get("user_id"):
        return redirect(url_for("login"))

    uid  = session["user_id"]
    conn = get_db_connection()
    cur_msg = conn.cursor(dictionary=True)   # ← per i messaggi
    cur_hdr = conn.cursor(dictionary=True)   # ← per header / altre query

    # ---------- invio nuovo messaggio ----------
    if request.method == "POST":
        text = request.form["text"].strip()
        if text:
            if chat_type == "group":
                cur_msg.execute("""
                    INSERT INTO messaggio_di_gruppo
                          (ID_Sender, ID_Gruppo, Data_ora, Contenuto)
                    VALUES (%s, %s, NOW(), %s)
                """, (uid, chat_id, text))

                # notifica agli altri membri
                cur_hdr.execute("""
                    SELECT ID_Utente
                    FROM gruppo_has_utente
                    WHERE ID_Gruppo=%s AND ID_Utente!=%s
                """, (chat_id, uid))
                for row in cur_hdr.fetchall():
                    create_notification(
                        conn,
                        destinatario_id=row["ID_Utente"],   # (nel loop dei membri)
                        tipo="message",
                        messaggio=f"@{session['nickname']} ha scritto nel gruppo {chat_id}.",
                        id_target=chat_id                   # ID del gruppo
                    )
            else:
                cur_msg.execute("""
                    INSERT INTO messaggio_individuale
                          (ID_Sender, ID_Ricevente, Data_ora, Contenuto)
                    VALUES (%s,        %s,          NOW(),   %s)
                """, (uid, chat_id, text))
                create_notification(conn, chat_id, "message",
                            f"@{session['nickname']} ti ha inviato un messaggio.",
                            id_target=uid)

            conn.commit()
            return redirect(request.url)

    # ---------- recupero messaggi ----------
    if chat_type == "group":
        cur_msg.execute("""
            SELECT mg.ID_Sender   AS Sender,
                   u.Nickname     AS Nick,
                   mg.Contenuto,
                   mg.Data_ora
            FROM messaggio_di_gruppo mg
            JOIN utente u ON u.ID_Utente = mg.ID_Sender
            WHERE mg.ID_Gruppo = %s
            ORDER BY mg.Data_ora DESC
            LIMIT 50
        """, (chat_id,))
        messages = list(reversed(cur_msg.fetchall()))

        # header (nome gruppo)
        cur_hdr.execute("SELECT Nome FROM gruppo WHERE ID_Gruppo=%s", (chat_id,))
        row = cur_hdr.fetchone()
        header = row["Nome"] if row else f"Gruppo {chat_id}"

    else:  # chat individuale
        cur_msg.execute("""
            SELECT mi.ID_Sender   AS Sender,
                   u.Nickname     AS Nick,
                   mi.Contenuto,
                   mi.Data_ora
            FROM messaggio_individuale mi
            JOIN utente u ON u.ID_Utente = mi.ID_Sender
            WHERE (mi.ID_Sender=%s AND mi.ID_Ricevente=%s)
               OR (mi.ID_Sender=%s AND mi.ID_Ricevente=%s)
            ORDER BY mi.Data_ora DESC
            LIMIT 50
        """, (uid, chat_id, chat_id, uid))
        messages = list(reversed(cur_msg.fetchall()))

        # header (nickname utente)
        cur_hdr.execute("SELECT Nickname FROM utente WHERE ID_Utente=%s", (chat_id,))
        row = cur_hdr.fetchone()
        header = row["Nickname"] if row else f"Utente {chat_id}"

    cur_msg.close()
    cur_hdr.close()
    conn.close()

    return render_template("chat_detail.html",
                           header=header,
                           chat_type=chat_type,
                           chat_id=chat_id,
                           msgs=messages,
                           uid=uid)

# ---------- FOLLOW ----------
@app.route("/follow/<int:user_id>", methods=["POST"])
def follow(user_id):
    if not session.get("user_id"):
        return redirect(url_for("login"))
    uid  = session["user_id"]
    if uid == user_id:
        return redirect(url_for("profile", user_id=user_id))

    conn = get_db_connection()
    cur  = conn.cursor()
    try:
        cur.execute("""
            INSERT IGNORE INTO FOLLOW (ID_Sender, ID_Followed, Data_ora)
            VALUES (%s, %s, NOW())
        """, (uid, user_id))
        conn.commit()
        create_notification(conn, user_id, "follow",
                    f"@{session['nickname']} ha iniziato a seguirti.",
                    id_target=uid)

    finally:
        cur.close()
        conn.close()
    return redirect(request.referrer or url_for("profile", user_id=user_id))

# ---------- UNFOLLOW ----------
@app.route("/unfollow/<int:user_id>", methods=["POST"])
def unfollow(user_id):
    if not session.get("user_id"):
        return redirect(url_for("login"))
    uid = session["user_id"]
    conn = get_db_connection()
    cur  = conn.cursor()
    try:
        cur.execute("""
            DELETE FROM FOLLOW
            WHERE ID_Sender=%s AND ID_Followed=%s
        """, (uid, user_id))
        conn.commit()
    finally:
        cur.close()
        conn.close()
    return redirect(request.referrer or url_for("profile", user_id=user_id))

# ---------- GROUP DETAIL ----------
@app.route("/group/<int:group_id>", methods=["GET", "POST"])
def group_detail(group_id):
    if not session.get("user_id"):
        return redirect(url_for("login"))

    uid  = session["user_id"]
    conn = get_db_connection()
    cur  = conn.cursor(dictionary=True)

    # --- dati gruppo + numero membri ---
    cur.execute("""
        SELECT g.Nome, g.Descrizione, g.Foto_gruppo,
               COUNT(ghu.ID_Utente) AS Membri
        FROM gruppo g
        LEFT JOIN gruppo_has_utente ghu ON ghu.ID_Gruppo = g.ID_Gruppo
        WHERE g.ID_Gruppo = %s
        GROUP BY g.ID_Gruppo
    """, (group_id,))
    group = cur.fetchone()
    if not group:
        conn.close()

    # --- sei già membro? sei admin? ---
    cur.execute("""
        SELECT Amministratore
        FROM gruppo_has_utente
        WHERE ID_Gruppo=%s AND ID_Utente=%s
    """, (group_id, uid))
    row = cur.fetchone()
    is_member = row is not None
    is_admin  = row["Amministratore"] == 1 if row else False

    # --- join / leave richiesto via POST ---
    if request.method == "POST":
        action = request.form.get("action")
        if action == "join" and not is_member:
            cur.execute("""
                INSERT INTO gruppo_has_utente
                      (ID_Gruppo, ID_Utente, Amministratore)
                VALUES (%s,        %s,        0)
            """, (group_id, uid))
            conn.commit()
            is_member = True
        elif action == "leave" and is_member:
            cur.execute("""
                DELETE FROM gruppo_has_utente
                WHERE ID_Gruppo=%s AND ID_Utente=%s
            """, (group_id, uid))
            conn.commit()
            is_member = False
            is_admin  = False
        return redirect(request.url)      # ricarica la pagina

    conn.close()
    return render_template("group_detail.html",
                           group=group,
                           group_id=group_id,
                           is_member=is_member,
                           is_admin=is_admin)

# ---------- GROUP CREATE ----------
@app.route("/group/create", methods=["GET", "POST"])
def group_create():
    if not session.get("user_id"):
        return redirect(url_for("login"))

    if request.method == "POST":
        name = request.form["name"].strip()
        descr = request.form["descr"].strip()
        photo = request.form["photo"].strip() or None

        conn = get_db_connection()
        cur  = conn.cursor()
        try:
            cur.execute("""
                INSERT INTO gruppo (Nome, Descrizione, Foto_gruppo)
                VALUES (%s, %s, %s)
            """, (name, descr, photo))
            gid = cur.lastrowid

            cur.execute("""
                INSERT INTO gruppo_has_utente
                      (ID_Gruppo, ID_Utente, Amministratore)
                VALUES (%s,        %s,        1)
            """, (gid, session["user_id"]))
            conn.commit()
            flash("Gruppo creato con successo.", "success")
            return redirect(url_for("group_detail", group_id=gid))
        except mysql.connector.Error as e:
            conn.rollback()
            flash(f"Errore MySQL: {e.msg}", "danger")
        finally:
            conn.close()

    return render_template("group_create.html")

# ---------- UNREAD NOTIFICATIONS COUNT ----------
@app.context_processor
def inject_unread_notif():
    """Rende disponibile {{ unread_notif }} in tutti i template."""
    if "user_id" not in session:
        return dict(unread_notif=0)

    conn = get_db_connection()
    cur  = conn.cursor()
    cur.execute("""
        SELECT COUNT(*) FROM NOTIFICA
        WHERE ID_Destinatario=%s AND Letta=0
    """, (session["user_id"],))
    count = cur.fetchone()[0]
    cur.close()
    conn.close()
    return dict(unread_notif=count)

if __name__ == "__main__":
    app.run(debug=True)
