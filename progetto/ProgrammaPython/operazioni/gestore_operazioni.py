from operazioni.auth import login, register
from operazioni.feed import *
from operazioni.messaggi import *
from operazioni.profilo import *
from operazioni.search import *
from operazioni.post import *

sessione = {
    "ID_utente": None,
    "username": None,
    "old_state": None,
    "ID_post": None,
    "post_id_map": None,
    "chat_id_map": None,
    "ID_chat": None,
    "ID_visited_user": None,
}


def do(nome_operazione, all_ops, current_state, conn):
    if nome_operazione not in all_ops:
        raise Exception("Operazione non consentita!")

    new_state = current_state
    sessione["old_state"] = current_state

    match nome_operazione:

        # --- AUTENTICAZIONE ---
        case 'login':
            id_u, user = login(conn)
            if id_u:
                sessione["ID_utente"], sessione["username"] = id_u, user
                new_state = 'logged'

        case 'register':
            register(conn)
            print("🔁 Ora effettua il tuo primo login per accedere.")

        case 'logout':
            print(f"👋 Logout eseguito da {sessione['username']}")
            sessione.update({
                "ID_utente": None,
                "username": None,
                "old_state": None,
                "ID_post": None,
                "post_id_map": None,
                "chat_id_map": None,
                "ID_chat": None
            })
            new_state = 'start'

        # --- MENU PRINCIPALE ---
        case 'feed':
            if feed(conn, sessione):
                new_state = 'on_feed'

        case 'search':
            print("🔎 Modalità ricerca attiva")
            new_state = 'search'

        case 'messages':
            list_chats(conn, sessione)
            new_state = 'messages'

        case 'show_profile':
            if current_state == 'search':
                while sessione["ID_visited_user"] is None:
                    print("Scrivi l'ID dell'utente da visualizzare (o premi invio per tornare indietro): ", end='')
                    id_visited = input().strip()
                    if not id_visited or id_visited == '':
                        return current_state
                    try:
                        sessione["ID_visited_user"] = int(id_visited)
                    except ValueError:
                        print("❌ ID utente non valido.")
                        search_users(conn, sessione)
                ID_Utente = sessione["ID_visited_user"]
                new_state = 'on_user_profile'
            else:
                ID_Utente = sessione["ID_utente"]
                new_state = 'in_profile'
            show_profile(conn, sessione, ID_Utente)
            show_user_posts(conn, sessione, ID_Utente)
        
        case 'create_post':
            create_post(conn, sessione)

        # --- OPERAZIONI SUL FEED ---
        case 'show_post':
            if not sessione['post_id_map']:
                print("⚠️ Devi prima visualizzare una lista di post (es. feed, personali, ecc.)")
                return sessione.get('old_state', 'logged')

            try:
                post_scelto = int(input("📍 Numero del post da visualizzare: "))
                id_autore, data_ora = sessione['post_id_map'][post_scelto]
                show_post(conn, id_autore, data_ora, sessione)
                sessione["ID_post"] = (id_autore, data_ora)
            except (KeyError, ValueError):
                print("❌ Post non valido.")
                return current_state


        case 'comment_post':
            if not sessione['post_id_map']:
                print("⚠️ Devi prima visualizzare il feed.")
                feed(conn, sessione)
                return 'on_feed'
            id_autore, data_ora = comment_post(conn, sessione['post_id_map'], sessione)
            show_post(conn, id_autore, data_ora, sessione)

        case 'react_post':
            if not sessione['post_id_map']:
                print("⚠️ Devi prima visualizzare il feed.")
                feed(conn, sessione)
                return 'on_feed'
            id_autore, data_ora = react_post(conn, sessione['post_id_map'], sessione)
            show_post(conn, id_autore, data_ora, sessione)

        case 'delete_comment':
            if sessione["ID_post"] is None:
                print("⚠️ Apri un post prima di cancellare commenti.")
                return current_state
            id_autore, data_ora = delete_comment(conn, sessione)
            show_post(conn, id_autore, data_ora, sessione)

        case 'refresh':
            feed(conn, sessione)
            return 'on_feed'

        # --- MESSAGGI (1-to-1) ---
        case 'list_chats':
            list_chats(conn, sessione)
            new_state = 'messages'

        case 'open_chat':
            try:
                id_chat = int(input("Numero della chat da aprire: "))
                sessione["ID_chat"] = sessione["chat_id_map"][id_chat]
                open_chat(conn, sessione)
                new_state = 'chat_opened'
            except (KeyError, ValueError):
                print("❌ Chat non valida.")
                return current_state

        case 'load_more_messages':
            if sessione["ID_chat"] is None:
                print("⚠️ Nessuna chat aperta.")
                return current_state
            load_more_messages(conn, sessione)

        case 'send_message':
            if current_state == 'on_user_profile':
                send_message(conn, sessione, sessione["ID_visited_user"])
            elif current_state == 'on_group':
                send_message(conn, sessione, sessione["ID_chat"])
            elif current_state == 'chat_opened':
                if sessione["ID_chat"] is None:
                    print("⚠️ Nessuna chat aperta.")
                    return current_state
                send_message(conn, sessione)
            elif current_state == 'messages':
                print("⚠️ Apri una chat prima di inviare messaggi.")
                return current_state

        # --- PROFILO ---
        case 'edit_profile':
            edit_profile(conn, sessione)

        case 'delete_profile':
            delete_profile(conn, sessione)
            new_state = 'start'

        case 'friendlist':
            friendlist(conn, sessione)

        case 'show_user_posts':
            try:
                if current_state == 'on_personal_posts':
                    id_target = sessione["ID_utente"]
                else:
                    id_target = int(input("🔍 Inserisci l'ID dell'utente (premi invio per te stesso): ").strip())
                    if not id_target or not isinstance(id_target, int) or id_target < 0 or id_target == '':
                        id_target = sessione["ID_utente"]
                        new_state = 'on_personal_posts'
                show_user_posts(conn, sessione, id_target)
            except ValueError:
                print("❌ ID utente non valido.")
                return current_state

        case 'delete_post':
            if sessione["ID_post"] is None:
                print("⚠️ Nessun post selezionato.")
                return current_state

            deleted = delete_post(conn, sessione)
            if deleted:
                print("✅ Post eliminato.")
                show_user_posts(conn, sessione, sessione["ID_utente"])  # refresh lista
                new_state = 'on_personal_posts'
            else:
                print("❌ Impossibile eliminare il post.")
            return new_state

        case 'modify_post':
            if sessione["ID_post"] is None:
                print("⚠️ Nessun post selezionato.")
                return current_state

            modify_post(conn, sessione)
            show_user_posts(conn, sessione, sessione["ID_utente"])
            new_state = 'on_personal_posts'


        # --- RICERCA ---
        case 'search_users':
            search_users(conn, sessione)
            sessione

        case 'search_groups':
            search_groups(conn, sessione)

        case 'follow_user':
            follow_user(conn, sessione)

        case 'join_group':
            join_group(conn, sessione)

        # --- UTILITY ---
        case 'return_on_menu':
            new_state = 'logged'

        case 'go_back':
            new_state = sessione['old_state'] or 'logged'

    return new_state


# Test standalone
if __name__ == '__main__':
    from utility.connector import connetti_db
    print("Test collegamento al db: ", end='')
    if connessione := connetti_db():
        print("✅ Successo")
        sessione = {"ID_utente": 51, "username": 'landigf'}
        feed(connessione, sessione)
