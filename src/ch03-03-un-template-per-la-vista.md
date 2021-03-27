# Un template per la vista

Possiamo migliorare la nostra homepage usando un template. Un template non è altro che un file di testo
che viene renderizzato tramite un motore di *templating*. Dentro ad un template possiamo usare dei
costrutti speciali usando un linguaggio specifico. Django usa per default un suo motore specifico di
rendering dei template.

Django cerca automaticamente i template delle applicazioni dentro una directory chiamata `templates`,
dentro a questa directory è buona norma prefissare i percorsi con il nome della applicazione.

Andiamo quindi a creare la directory che conterrà il nostro template:

```shell
mkdir -p homepage/templates/homepage
```

Ed andiamo a creare il file `homepage/templates/homepage/index.html` con questo contenuto:

```html
<html>
<head>
  <title>Homepage</title>
</head>
<body>
  <h1>{{ welcome_message }}</h1>
</body>
</html>
```

`{{ welcome_message }}` è la sintassi usata dal sistema di templating di Django per stampare il valore
di una variabile chiamata `welcome_message`.

Una comodità dell'usare viste basate su classi è quella di poter riusare delle viste specializzate
già pronte. In questo caso possiamo usare la vista generica `TemplateView`. Andiamo quindi ad
aggiornare il file `views.py` in questo modo:

```python
from django.views.generic import TemplateView


class HomepageView(TemplateView):
    template_name = 'homepage/index.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['welcome_message'] = 'Welcome to this page!'
        return context
```

Ci sono un paio di cose su cui soffermarsi:

- Il fatto di riusare una vista generica rende esplicito il tipo di vista e rende anche molto breve il
  nostro codice. Rende anche le cose piuttosto magiche ad una prima occhiata.
- `get_context_data` è il metodo che dobbiamo estendere per poter aggiungere il messaggio di benvenuto
  alle variabili che vengono passate al template durante il suo rendering.

Ora puntiamo il browser su [http://127.0.0.1:8000](http://127.0.0.1:8000).

Oops, qualcosa non sta funzionando! Django non riesce a trovare il template `homepage/index.html`
nonostate noi l'abbiamo creato.
Soffermiamoci un secondo su questa pagina:
- Nella parte gialla vediamo il riassunto dell'errore con l'eccezione e le informazioni di base sulla
  istanza di Django
- A seguire ci sono delle informazioni specifiche sul sistema di templating, vengono elencati tutti
  i percorsi provati da Django
- Ancora troviamo la traceback Python dell'errore, la stessa che troviamo nella shell dove stiamo
  facendo girare `runserver`
- Quindi le informazioni sulla richiesta HTTP
- Infine tutti i valori presenti nel file `settings.py`

La pagina di errore che vedete è governata dal flag `DEBUG` nel file `settings.py` perché non vogliamo
esporre tutte queste informazioni su un sito pubblico.

Chiusa la parentesi sulla pagina di debug correggiamo il nostro errore. Come detto prima Django cerca
automaticamente i templates nella directory `templates` di ogni applicazione; lo fa però solo per le
applicazioni che sono state listate in `INSTALLED_APPS` del file `settings.py`.

Apriamo `settings.py` con il nostro editor ed aggiorniamo i valore di `INSTALLED_APPS` così:

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'homepage',
]
```

Se ricarichiamo la pagina tutto dovrebbe essersi sistemato.

## Esercizi

- Leggi la documentazione ufficiale dei [templates](https://docs.djangoproject.com/en/3.1/topics/templates/)
- Leggi la documentazione di [TemplateView](https://docs.djangoproject.com/en/3.1/ref/class-based-views/base/#templateview) per scoprire chi implementa `get_context_data`
- Metti nei segnalibri il sito [Classy Class-Based Views](https://ccbv.co.uk/), ci sarà utile in futuro
