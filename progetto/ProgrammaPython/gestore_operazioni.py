from operazioni.auth import login, register
from operazioni.feed import *
from operazioni.messaggi import *
from operazioni.profilo import *
from operazioni.search import *
from operazioni.post import *
from operazioni.notifiche import *

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
                # Se l'utente ha effettuato il login, controlla le notifiche
                check_new_notifications(conn, sessione)


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
        case 'notifications':
            show_notifications(conn, sessione)
            new_state = current_state

        case 'feed':
            if feed(conn, sessione):
                new_state = 'on_feed'

        case 'search':
            print("🔎 Modalità ricerca attiva")
            new_state = 'search'

        case 'messages':
            list_chats(conn, sessione)
            new_state = 'messages'
            if not sessione["chat_id_map"]:
                print("⚠️ Nessuna chat disponibile. Inizia una nuova conversazione.")

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
            # Verifica preliminare
            if "chat_id_map" not in sessione or not sessione["chat_id_map"]:
                print("❌ Prima visualizza la lista delle chat con 'list_chats'")
                return current_state
    
            try:
                # Input e validazione
                id_chat = int(input("Numero della chat da aprire: "))
        
                if id_chat not in sessione["chat_id_map"]:
                    print("❌ Numero chat non valido")
                    return current_state
            
                # Prepara sessione e chiama funzione
                sessione["selected_chat_id"] = id_chat
                open_chat(conn, sessione)
                new_state = 'chat_opened'
        
            except ValueError:
                print("❌ Inserisci un numero valido")
            except Exception as e:
                print(f"❌ Errore durante l'apertura della chat: {str(e)}")
    
            return new_state if 'new_state' in locals() else current_state


        case 'new_chat':
            try:
                username = input("Inserisci il nome utente (o parte di esso) da cercare: ").strip()
                if not username:
                    print("❌ Username non valido.")
                    return current_state

                risultati = cerca_utenti(conn, sessione["ID_utente"], username)

                if not risultati:
                    print("❌ Nessun utente trovato.")
                    return current_state

                print("\n--- Risultati trovati ---")
                for utente in risultati:
                    print(f"ID: {utente['ID_Utente']} - Username: {utente['Nickname']} - {utente['StatoAmicizia']}")

                recipient_id = input("\nInserisci l'ID dell'utente a cui vuoi inviare il messaggio: ").strip()
                if not recipient_id.isdigit():
                    print("❌ Devi inserire un numero valido.")
                    return current_state

                recipient_id = int(recipient_id)
                if recipient_id == sessione["ID_utente"]:
                    print("❌ Non puoi inviare messaggi a te stesso.")
                    return current_state

                contenuto = input("Scrivi il tuo messaggio (o 'annulla' per tornare indietro): ").strip()
                if contenuto.lower() == 'annulla' or not contenuto:
                    print("❌ Messaggio annullato.")
                    return current_state

                # Aggiorna la sessione
                sessione["ID_chat"] = recipient_id
                sessione["current_chat_type"] = 'user'
                sessione["selected_chat_id"] = None

                if send_message(conn, sessione, contenuto, recipient_id, 'user'):
                    print("✅ Messaggio inviato!")
                    new_state = 'chat_opened'
                else:
                    print("❌ Invio del messaggio fallito.")
                    return current_state

            except mysql.connector.Error as err:
                print(f"❌ Errore database: {err}")
                return current_state


        case 'send_message':
            try:
                if current_state == 'on_user_profile':
                    if "ID_visited_user" not in sessione:
                        print("❌ Seleziona prima un utente")
                        return current_state

                    recipient_id = sessione["ID_visited_user"]
                    chat_type = 'user'
                    is_chat_open = False

                elif current_state == 'chat_opened':
                    recipient_id = sessione["ID_chat"]
                    chat_type = sessione.get("current_chat_type")
                    is_chat_open = True

                else:
                    print("❌ Contesto non valido per l'invio")
                    return current_state
        
                contenuto = input("Scrivi il messaggio (o 'annulla' per tornare indietro): ")
                if contenuto.lower() == 'annulla' or not contenuto:
                    print("❌ Invio messaggio annullato.")
                    return current_state
            
                if send_message(conn, sessione, contenuto, recipient_id, chat_type):
                    print("✅ Messaggio inviato!")
                    # Se non era una chat aperta, aprila ora
                    if not is_chat_open:
                        if current_state == 'on_user_profile':
                            sessione["ID_chat"] = recipient_id  # <<--- AGGIUNGI QUESTO
                            load_individual_chat(conn, sessione)
                        else:
                            sessione["ID_chat"] = recipient_id
                            open_chat(conn, sessione)
                        new_state = 'chat_opened'
                else:
                    print("❌ Invio fallito")
            except mysql.connector.Error as err:
                print(f"❌ Errore database: {err}")
            except Exception as e:
                print(f"❌ Errore durante l'invio: {str(e)}")
    
            return current_state
            
        case 'delete_last_message':
            # Verifica preliminare
            if sessione.get("ID_chat") is None:
                print("❌ Nessuna chat selezionata. Apri prima una chat.")
                return current_state
    
            try:
                delete_last_message(conn, sessione)
            except mysql.connector.Error as err:
                print(f"❌ Errore database: {err}")
                conn.rollback()
            except Exception as e:
                print(f"❌ Errore durante l'eliminazione: {str(e)}")
    
            return current_state  # Restiamo nello stesso stato
        
        case 'edit_last_message':
            if sessione.get("ID_chat") is None:
                print("❌ Nessuna chat selezionata")
                return current_state
    
            try:
                nuovo_contenuto = input("Inserisci il nuovo testo: ")
                if not nuovo_contenuto:
                    print("❌ Testo vuoto")
                    return current_state
            
                if edit_last_message(conn, sessione, nuovo_contenuto):
                    print("✅ Messaggio modificato!")
                else:
                    print("⚠️ Nessun messaggio da modificare")
            except Exception as e:
                print(f"❌ Errore durante la modifica: {str(e)}")
                conn.rollback()
    
            return current_state

        # --- GESTIONE GRUPPI ---
        case 'create_group':
            create_group(conn, sessione)
            new_state = 'logged'  # Torna al menu principale

        case 'group_members':
            group_members(conn, sessione)
        
        case 'leave_group':
            leave_group(conn, sessione)
            new_state = 'messages'

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
                    id_target = int(input("🔍 Inserisci l'ID dell'utente (premi invio per tornare indietro): ").strip())
                    if not id_target:
                        return current_state
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
                show_user_posts(conn, sessione, sessione["ID_utente"]) # refresh lista
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


if __name__ == '__main__':
    from utility.connector import connetti_db
    print("Test collegamento al db: ", end='')
    if connessione := connetti_db():
        print("✅ Successo")
        sessione = {"ID_utente": 51, "username": 'landigf'}
        feed(connessione, sessione)
