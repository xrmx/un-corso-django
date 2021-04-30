# Configuriamo il progetto

Come abbiamo visto le configurazioni del nostro progetto sono disponibili in un file chiamato
`settings.py` in una directory omonima del progetto, quindi nel nostro caso in `catalogo/settings.py`.

Apriamo il file con il nostro editor, cerchiamo la configurazione `TIME_ZONE` ed aggiorniamola per
essere in linea con quella configurata nel nostro computer:

```python
TIME_ZONE = 'Europe/Rome'
```

Se il tuo computer risiede in un fuso orario diverso puoi consultare la
[lista dei nomi su wikipedia](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

Quindi localizziamo la configurazione `DATABASES` che dovrebbe essere simile a questa:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```

Dobbiamo aggiornarla a seconda della nostra configurazione specifica, qui sotto troviamo troviamo gli
esempi per *MariaDB / MySQL* e *PostgreSQL* usando le istanze di Docker Compose fornite.

## MariaDB / MySQL

Se hai deciso di usare MariaDB la configurazione del database deve risultare qualcosa del genere:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'mariadb',
        'USER': 'mariadb',
        'PASSWORD': 'password',
        'HOST': '127.0.0.1',
        'PORT': '3306',
    }
}
```

## PostgreSQL

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'postgres',
        'USER': 'postgres',
        'PASSWORD': 'password',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}
```

## Migriamo

Per verificare che la configurazione sia corretta possiamo applicare le migrazioni del progetto:

```shell
python3 manage.py migrate
```

Una volta che abbiamo applicato le migrazioni possiamo aggiornare i dati nel repository:

```shell
git add catalogo/settings.py
git commit -m "Aggiorniamo la configurazione del database"
```

E aggiorniamo il repository remoto:

```shell
git push origin main
```

## Esercizi

Guarda le varie opzioni disponibili per la
[configurazione del database](https://docs.djangoproject.com/en/3.2/ref/settings/#databases).
