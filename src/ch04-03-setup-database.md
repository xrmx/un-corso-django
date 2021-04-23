# Setup del database

Per sviluppare il nostro progetto useremo un database il più simile possibile a quello che intendiamo
usare in produzione. `SQLite` è indubbiamente un database ricco di funzionalità e molto comodo da usare,
ma non adatto agli scopi di una applicazione Web.

Django supporta, tramite l'ausilio di opportune librerie esterne, l'accesso ai seguenti database:
- MariaDB
- MySQL
- PostgreSQL
- Oracle

Offriremo le istruzioni per il setup dei client per MariaDB / MySQL e PostgreSQL. Per i server è
possibile installarli in autonomia oppure usare le configurazioni fornite per
[Docker Compose](https://docs.docker.com/compose/install/).

In alternativa potete avere gratuitamente un credito su [DigitalOcean](https://m.do.co/c/0cde7cc77d3e)
per usare un server gestito.

## PostgreSQL

Il supporto a PostgreSQL richiede l'installazione del driver [psycopg2](https://www.psycopg.org/):

```shell
pip install pyscopg2-binary
```

Una volta scaricata la configurazione Docker Compose
[postgres.yml](https://github.com/xrmx/un-corso-django/blob/main/docker/postgres.yml) può essere
eseguita tramite il comando:

```shell
docker-compose -f postgres.yml up
```

> Il server salverà i dati in una directory relativa al percorso del file yaml

Questo comando eseguirà una istanza di PostgreSQL, per terminarla basterà premere *CONTROL-C*.

## Client MariaDB / MySQL

Il supporto per MariaDB e MySQL richiede l'installazione del driver
[mysqlclient](https://mysqlclient.readthedocs.io/) che viene fornito precompilato solo per Windows.

Per sistemi Linux come Debian o Ubuntu usare il seguente comando per installare le dipendenze:

```shell
sudo apt build-dep python3-mysqldb
```

Quindi possiamo procedere ad installare il driver per Python:

```shell
pip install mysqlclient
```

Una volta scaricata la configurazione Docker Compose
[mariadb.yml](https://github.com/xrmx/un-corso-django/blob/main/docker/mariadb.yml) può essere
eseguita tramite il comando:

```shell
docker-compose -f mariadb.yml up
```

> Il server salverà i dati in una directory relativa al percorso del file yaml

Questo comando eseguirà una istanza di MariaDB ed una interfaccia di configurazione del database; per
terminarle basterà premere *CONTROL-C*.

Tramite [l'interfaccia di configurazione](http://127.0.0.1:8080/?server=db&username=root&sql=),
dopo aver fatto il login usando `root` come utente e `password` come password, inseriamo il seguente
comando SQL:

```
GRANT ALL PRIVILEGES ON test_mariadb.* TO 'mariadb';
```

Questo comando dà al nostro utente `mariadb` il permesso per creare il database che ci servirà per
poter eseguire i test automatici.

## Esercizi

Leggi la [documentazione](https://docs.djangoproject.com/en/3.2/ref/databases/) specifica del database
che andrai ad utilizzare.
