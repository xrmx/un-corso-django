# Anatomia di una applicazione Django

Per creare una applicazione Django dobbiamo usare il comando *startapp*. Il comando richiede il nome
dell'applicazione come parametro, dal momento che vogliamo creare una homepage useremo:

```shell
python3 manage.py startapp homepage
```

Una volta dato il comando nella nostra directory apparirà una nuova directory chiamata homepage.
La directory dell'applicazione sarà così composta:

```shell
homepage/
homepage/__init__.py
homepage/admin.py
homepage/apps.py
homepage/migrations
homepage/migrations/__init__.py
homepage/models.py
homepage/tests.py
homepage/views.py
```

Per default vengono creati i seguenti file:

- **admin.py**, dove andremo a registrare i modelli per esser visualizzati nell'admin
- **apps.py**, serve a Django per registrare l'applicazione
- **migrations**, per contenere i file delle migrazioni
- **models.py**, per contenere i modelli
- **tests.py**, per contenere i test del nostro codice
- **views.py**, per contenere le viste
