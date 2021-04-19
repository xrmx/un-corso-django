# Le viste per l'applicazione dei corsi

Nei capitoli precedenti abbiamo costruito una applicazione con cui gestire un catalogo di corsi:
abbiamo creato dei modelli e usando l'interfaccia di amministrazione di Django possiamo gestirne i
contenuti.

L'interfaccia di amministrazione di Django però è disponibile solo per utenti *staff*, che
possono accedere al nostro backoffice perché hanno dei permessi speciali.

In questo capitolo andremo ad estendere la nostra applicazione per essere fruibile anche ad altri
utenti implementando delle viste che ci permettano di listare i corsi che abbiamo disponibili,
filtrarli e vedere il dettaglio di un singolo corso. Inseriremo anche un sistema di login e
registrazione per permettere agli utenti di registrarsi e quindi una volta autenticati di inserire
e modificare i corsi.
