# Setup repository GitHub

Useremo GitHub come piattaforma per ospitare il nostro codice, andremo quindi a creare un nuovo
repository git.
Apriamo il nostro browser all'indirizzo [https://github.com/new](https://github.com/new) per vedere il
form di creazione di un nuovo repository.
Inseriamo **catalogo** come *Repository Name*, possiamo lasciare vuoto il campo *Description*,
configuriamo il repository privato selezionando *Private*.
Vogliamo creare un repository vuoto quindi non andremo a selezionare nessuna delle opzioni proposte.
Infine creiamo il repository con `Create repository`, saremmo rediretti nella pagina del repository
appena creato.

Dalla pagina del nostro repository `catalogo` clicchiamo *Code* e copiamo l'url.

Ora dalla directory del repository git che abbiamo creato configuriamo l'url che abbiamo copiato come
server remoto al quale invieremo i cambiamenti:

```shell
git remote add origin git@github.com:iltuousername/catalogo.git
```

> ricorda di sostituire *iltuousername* con il tuo username di GitHub

Fatto questo possiamo inviare il nostro codice a GitHub:

```shell
git push --set-upstream origin main
```

Apri il tuo browser all'indirizzo del tuo repository (qualcosa di simile a
`https://github.com:iltuousername/catalogo`  ma con il tuo username GitHub al posto di *iltuousername*)
per leggere il tuo `README.md`.
