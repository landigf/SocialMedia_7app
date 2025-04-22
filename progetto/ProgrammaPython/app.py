from utility.connector import connetti_db
from operazioni.gestore_operazioni import do

all_ops = {
    # Accesso
    'login': "Effettua il login",
    'register': "Registrati a 7app!",

    # Navigazione principale
    'feed': "Vai al feed",
    'search': "Cerca utenti o gruppi",
    'messages': "Apri i messaggi",
    'show_profile': "Mostra il profilo",
    'create_post': "Crea un nuovo post",

    # Feed (tipo Instagram)
    'show_post': "Visualizza un post nel feed",
    'comment_post': "Commenta il post",
    'react_post': "Metti una reazione",
    'refresh': "Aggiorna il feed",

    # Messaggistica (tipo WhatsApp)
    'list_chats': "Visualizza le tue chat recenti",
    'open_chat': "Apri una chat",
    'load_more_messages': "Carica altri messaggi",
    'send_message': "Invia un nuovo messaggio",

    # Profilo
    'edit_profile': "Modifica il tuo profilo",
    'delete_profile': "Elimina il tuo profilo",
    'friendlist': "Visualizza la lista amici",
    'show_user_posts': "Visualizza i post del profilo",


    # Ricerca
    'search_users': "Cerca utenti",
    'search_groups': "Cerca gruppi",
    'follow_user': "Segui utente",
    'join_group': "Unisciti a un gruppo",

    # Gruppi
    'create_group': "Crea un gruppo",
    'leave_group': "Esci da un gruppo",
    'post_in_group': "Scrivi in un gruppo",
    'group_members': "Visualizza membri del gruppo",

    # Utility
    'return_on_menu': "Torna al menù principale",
    'go_back': "Torna indietro",
    'logout': "Esci dall'applicazione :("
}



ops_by_state = {
    'start': (
        'login', 'register'
    ),

    'logged': (
        'feed', 'search', 'messages', 'show_profile', 'create_post'
    ),

    # Feed stile Instagram
    'on_feed': (
        'show_post', 'comment_post', 'react_post', 'refresh', 'return_on_menu'
    ),

    # Ricerca utenti o gruppi
    'search': (
        'search_users', 'search_groups', 'follow_user', 'join_group', 'show_profile', 'return_on_menu'
    ),

    # Messaggi (stile WhatsApp)
    'messages': (
        'list_chats', 'open_chat', 'return_on_menu'
    ),

    'chat_opened': (
        'load_more_messages', 'send_message', 'return_on_menu'
    ),

    # Profilo personale
    'in_profile': (
        'edit_profile', 'delete_profile', 'friendlist', 'show_user_posts', 'return_on_menu'
    ),

    # Sui post personali
    'on_personal_posts': (
        'delete_post', 'modify_post', 'show_post', 'return_on_menu'
    ),

    # Visualizza profilo utente
    'on_user_profile': (
        'follow_user', 'send_message', 'show_user_posts', 'return_on_menu'
    ),

    # Gruppi
    'on_group': (
        'post_in_group', 'group_members', 'leave_group', 'return_on_menu'
    ),
}



def main():
    state = 'start' # stato iniziale
    print(" ---- Benvenuto a 7app! ----\n")

    connessione = connetti_db()
    if not connessione:
        raise Exception("Connessione con il DB non riuscita!")

    while True:
        print("\nSeleziona operazione:")
        current_ops = ops_by_state[state]
        for i, op in enumerate(current_ops):
            print(f'\t{i}. {all_ops[op]}')
        print(f'\t-1. {all_ops["logout"]}')

        try:
            operazione = int(input("Scegli numero operazione: "))
        except ValueError:
            print("Inserisci un numero valido!\n")
            continue

        if operazione == -1:
            print("\n\n************************")
            print("Ciao, alla prossima!")
            break

        if not 0 <= operazione < len(current_ops):
            print("Operazione non valida. Riprova!\n")
            continue

        nome_operazione = current_ops[operazione]
        print(f"\nOperazione selezionata: {nome_operazione}\n")

        state = do(nome_operazione, current_ops, state, connessione)


if __name__ == '__main__':
    main()