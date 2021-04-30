# Anatomia di una applicazione Django

Nel mondo Django le applicazioni sono i componenti con cui costruiamo il nostro progetto e che
forniscono al progetto le sue funzionalità. L'interfaccia di amministrazione che abbiamo visto
precedentemente è fornita da una applicazione chiamata `admin`.

Per creare una applicazione Django dobbiamo usare il comando `startapp`. Il comando richiede il nome
dell'applicazione come parametro, dal momento che vogliamo creare una homepage useremo:

```shell
python3 manage.py startapp homepage
```

Una volta dato il comando nella nostra directory apparirà una nuova directory chiamata homepage.
La directory dell'applicazione sarà così composta:

```shell
homepage
├── admin.py
├── apps.py
├── __init__.py
├── migrations
│   ├── __init__.py
├── models.py
├── tests.py
└── views.py
```

Per default vengono creati i seguenti file:

- **admin.py**, dove andremo a registrare i modelli per esser visualizzati nell'admin
- **apps.py**, serve a Django per registrare l'applicazione
- **migrations**, per contenere i file delle migrazioni
- **models.py**, per contenere i modelli
- **tests.py**, per contenere i test del nostro codice
- **views.py**, per contenere le viste
