# L'admin

Ora che abbiamo il nostro utente possiamo dare un'occhiata ad un'altra applicazione installata di
default in Django, l'interfaccia di amministrazione comunemente chiamata `admin`.

Puntiamo il nostro browser su [http://127.0.0.1:8000/admin/](http://127.0.0.1:8000/admin/), verremo
rediretti su una vista di login tramite la quale possiamo usare le credenziali dell'utente appena creato.

Una volta loggati ci ritroviamo nell'interfaccia di amministrazione dove tra gli altri troveremo i
seguenti componenti:

- nell'intestazione troviamo un link `CHANGE PASSWORD` per avere un form di cambio password
- sempre nell'intestazione troviamo un link `LOG OUT` per chiudere la nostra sessione
- sulla destra in un blocco `Recent actions` troviamo le ultime azioni fatte dal nostro utente tramite
l'interfaccia di amministrazione, tutte le operazioni fatte da qui sono registrate.

Nella parte principale invece vediamo tutte le applicazioni ed i modelli delle stesse. In questo caso
l'unica applicazione presente è `auth` che registra i modelli `Groups` e `Users` rispettivamente il
modello per gestire gruppi di utenti e quello per gestire i singoli utenti.

Se clicchiamo su `Users` andiamo alla pagina che lista tutti gli utenti.

L'indirizzo della pagina è `http://127.0.0.1:8000/admin/auth/user/` e possiamo notare come nell'url ci
sia `auth` che è il nome dell'applicazione e `user` che è il nome del modello.

Nella parte sinistra dello
schermo troviamo il riepilogo di tutti i modelli dell'applicazione e una scorciatoia per aggiungere
una nuova istanza di ogni tipo di modello.

Nella parte centrale abbiamo la ricerca testuale sulle varie istanze dei modelli, quindi la lista
di tutti i modelli.
Tra la ricerca e la lista delle istanze abbiamo la sezione delle azioni che possiamo svolgere sulle
istanze selezionate.

Nella parte destra dello schermo invece abbiamo un bottone per aggiungere un nuovo Utente e la parte
dei filtri, tramite i quali possiamo filtrare le nostre istanze.

Se clicchiamo nello username dell'utente che abbiamo creato andiamo nel form di modifica dello stesso,
non entriamo nei dettagli degli attributi degli utenti, facciamo solo caso ai bottoni al fondo
della pagina che ci permettono di cancellare o modificare il nostro utente.
Se vediamo degli avvertimenti sulle date non preoccupiamoci.

Tutte queste funzionalità sono rese disponibili nell'interfaccia di amministrazione ai nostri modelli
in modo dichiarativo senza doverle programmare.
