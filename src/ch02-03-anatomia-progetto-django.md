# Anatomia di un progetto Django

Nella nostra directory corrente dovremmo avere due directory, quella di progetto `nuovoprogetto` e
quella del virtualenv `venv`.

Se andiamo dentro quella di progetto e digitiamo il comando `find` dovremmo vedere qualcosa del genere:

```shell
./nuovoprogetto
./nuovoprogetto/urls.py
./nuovoprogetto/__init__.py
./nuovoprogetto/settings.py
./nuovoprogetto/wsgi.py
./nuovoprogetto/asgi.py
./manage.py
```

Questi sono i file che compongono il nostro nuovo progetto Django, una cosa che salta all'occhio è
il fatto che il nome del progetto viene replicato in una directory. Questo può creare un po' di
confusione all'inizio ("due directory con lo stesso nome!") ma questa directory serve a contenere
tutti i file di progetto, riusare lo stesso nome che abbiamo dato al progetto è una buona idea
per evitare conflitti.

## manage.py

`manage.py` sarà la porta d'ingresso per chiamare ogni comando di Django. È  possibile chiamarlo sia
 direttamente con `./manage.py` che come script Python con `python3 manage.py`. Non c'è alcuna
 differenza. Una cosa importante da ricordare però è di chiamarlo sempre da questa directory.

Se lo chiamiamo vediamo tutti i comandi, raggruppati per `applicazione` già disponibili.

## I file del progetto

I file di progetto sono quelli contenuti nella directory che siama come il nostro progetto, in questo
caso `nuovoprogetto`.

Il file `urls.py` contiene le rotte per il routing delle richieste alla nostra applicazione.

Il file `__init__.py` ha la funzione standard di Python di far diventare questa directory un modulo.

Il file `settings.py` contiene tutte le configurazioni del nostro progetto.

Il file `wsgi.py` contiene l'entrypoint per poter caricare la nostra applicazione in un application
server che supporta lo standard `WSGI`. `WSGI` è lo standard Python per usato da tutte le applicazioni
web Python.

Il file `asgi.py` contiene l'entrypoint per poter caricare la nostra applicazione in un application
server che supporta il protocollo `ASGI`. `ASGI` è un nuovo protocollo di interfacciamento per
applicazioni web Python asincrone sviluppato per Django e adottato anche da altri framework di
nuova generazione. Il supporto di Django per una esecuzione completamente asincrona è ancora incompleto
perciò non sarà trattato.