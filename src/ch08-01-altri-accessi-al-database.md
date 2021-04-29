# Altri accessi al database

In alcuni casi potrebbe far comodo avere un accesso più diretto al database, per esempio quando
abbiamo delle query veramente complicate che non riusciamo ad esprimere in modo efficiente tramite
l'ORM. Oppure se stiamo facendo il porting di un applicativo verso Django potrebbe far comodo riusare,
 si spera temporaneamente, la collezione di query SQL già in nostro possesso.

Un altro caso in cui ci si potrebbe trovare è quello di dover accedere ad database legacy per poter
reperire dei dati che dobbiamo ancora portare a del nuovo codice. Oppure potrebbe capitare di dover
leggere dei dati elaborati da un'altra applicazione e non aver altro modo di accedere oltre al
database.

## Eseguire query SQL

Potrebbe capitare di non riuscire ad esprimere delle query tanto efficienti come quelle espresse
scrivendo l'SQL a mano. In questi casi è possibile comunque poter riusare la connessione al database
stabilita da Django. Questi casi dovrebbero essere limitati in casi in cui ogni eventuale input è
validato e considerato sicuro, un caso d'uso ad esempio è per sistemi di analisi dati in cui su
grosse moli le query efficienti fanno la differenza.

Possiamo aprire una shell di Django e provare il seguente codice:

```python
from django.db import connection

with connection.cursor() as cursor:
    cursor.execute("SELECT *  FROM corsi_corso WHERE titolo = %s", ["titolo"])
    rows = cursor.fetchall()
    for row in rows:
        print(rows)
```

`fetchall()` restituisce tutte le righe risultanti dalla precedente query sottoforma di tuple:

```python
((1, 'titolo', 'descrizione', datetime.datetime(2021, 4, 10, 15, 16, 22, 524469), datetime.datetime(2021, 4, 10, 15, 16, 22, 524499), 1),)
```

Si rimanda alla [documentazione sulle query SQL](https://docs.djangoproject.com/en/3.2/topics/db/sql/#executing-custom-sql-directly) per vedere tutti i metodo messi a disposizione dalle istanze di `cursor`.
L'API non è dissimile da quella che si trova usando direttamente i driver del database.

## Usare più di un database

Integrarsi con altre applicazioni tramite l'utilizzo dello stesso database non è il modo preferibile per
farlo, un cambio al database da una parte potrebbe spaccare un'applicazione dall'altra. Far esporre una
API da un lato è preferibile. Detto questo può capitare di dover accedere ad altri database e poterlo
fare comodamente ha certamente dei vantaggi.

Django permette di configurare più di un database molto facilmente, aggiungendo delle ulteriori chiavi
rispetto a `default`, come ad esempio:

```python
DATABASES = {
    'default': {
        'NAME': 'database',
        'ENGINE': 'django.db.backends.mysql',
        'USER': 'mysql',
        'PASSWORD': 'password'
    },
    'vecchio_database': {
        'NAME': 'vecchio_database',
        'ENGINE': 'django.db.backends.mysql',
        'USER': 'altroutente',
        'PASSWORD': 'altrapassword'
    }
}
```

Semplicemente configurando la connessione ad un database possiamo scrivere direttamente le nostr query
usando quel database:

```python
from django.db import connections

with connections["vecchio_database"].cursor() as cursor:
    ...
```

## Usare modelli non gestiti da Django

In altri casi potrebbe far comodo comunque usare le interfaccie più di alto livello di Django come i
modelli con tabelle che non vogliamo gestire dalla nostra applicazione.

Django offre il comando `inspectdb` che permette di generare automaticamente dei modelli facendo
introspezione di un database. Ad esempio se avessimo una precedente versione della nostra applicazione
per gestire il catalogo dei corsi potremmo creare una applicazione `corsi_legacy` e generare il file
`models.py` col seguente comando:

```shell
python manage.py inspectdb --database vecchio_database > models.py
```

`inspectdb` potrebbe non riuscire a recuperare tutti i campi in modo fedele perciò sarò comunque
necessario un processo manuale di verifica.
python manage.py inspectdb > models.py
Per usare un database specifico per popolare un *Queryset* bisogna specificare il database usando il
metodo `using()`:

```python
Corso.objects.using("vecchio_database").all()
```

Per i metodi delle istanze invece come `save` e `delete` è implicito perché verrà usato lo stesso
database dal quale è stato recuperato. È comunque possibile passarlo esplicitamente:

```python
corso = Corso.objects.using("vecchio_database").get(titolo="titolo")
corso.save(using="vecchio_database")
corso.delete(using="vecchio_database")
```

## Esercizi

Consulta la [documentazione sull'uso di molteplici database](https://docs.djangoproject.com/en/3.2/topics/db/multi-db/).

Leggi la [documentazione sull'usare database non gestiti](https://docs.djangoproject.com/en/3.2/howto/legacy-databases/).

Consulta la documentazione di [inspectdb](https://docs.djangoproject.com/en/3.2/ref/django-admin/#django-admin-inspectdb) per vedere le sue opzioni.
