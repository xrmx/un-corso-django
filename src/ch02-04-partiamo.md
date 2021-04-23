# Partiamo!

Ora che abbiamo un ambiente con Django installato e creato il nostro nuovo progetto dobbiamo solo farlo
partire.

Il motto di Django, tradotto in italiano è "Il framework web per perfezionisti con delle scadenze" non
per caso. Fedele al suo motto ogni nuovo progetto Django infatti ha per default già delle applicazioni
attive.

Alcuni esempi di applicazioni già incluse sono l'autenticazione, la gestione delle sessioni e
una interfaccia di inserimento di contenuti chiamata `admin`.
Queste applicazioni possono aver bisogno di persistenza e quindi di creare tabelle in un database SQL.
La creazione e la modifica delle tabelle nel database viene fatta tramite un sistema di `migrazioni`.

Applichiamo le migrazioni richieste dal nostro progetto Django con il comando:

```shell
python3 manage.py migrate
```

che riporterà qualcosa di simile a:

```shell
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying auth.0012_alter_user_first_name_max_length... OK
  Applying sessions.0001_initial... OK
```

Una volta applicate le migrazioni nella nostra directory sarà presente un nuovo file *db.sqlite3*,
come suggerisce il nome è un database [SQLite](https://sqlite3.org). SQLite viene usato come database
di default di Django perché non richiede un server, il database viene salvato in un singolo file ed
è supportato direttamente da Python.

Ora che abbiamo preparato il database non ci resta che far partire il nostro progetto tramite il web
server di sviluppo `runserver`:

```shell
python3 manage.py runserver
```

Il server di sviluppo si riavvia ogni qual volta modifichiamo dei file del nostro progetto Django,
per questo motivo se ci sono errori nel nostro codice potrebbe fermarsi. Nel caso serva riavviarlo
è possibile fermarlo tramite *CONTROL-C* e quindi richiamare nuovamente il comando.

Ora puntate il browser sull'indirizzo [http://127.0.0.1:8000/](http://127.0.0.1:8000/) e si parte.

Congratulazioni l'installazione ha avuto successo.
