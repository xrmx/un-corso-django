# La lista dei corsi

Andiamo a scrivere la vista per listare i corsi nel file `corsi/views.py`:

```python
from django.views.generic import ListView

from corsi.models import Corso


class CorsoListView(ListView):
    model = Corso
```

Non abbiamo poi scritto molto! Abbiamo usato le viste *generiche* che offre Django, creando una nuova
vista `CorsoListView` che eredita dalla vista generica `ListView` dove l'unico attributo che
specifichiamo è il modello che vogliamo mostrare.

Fatta la vista mancano altri due pezzi: il template per fare il rendering e collegare la vista al
sistema di routing.

Cominciamo dai templates. I template usati dalle viste generiche seguono tutte un pattern del tipo
`<applicazione>/<modello>_<azione>.html` dove nel nostro caso è `corsi/corso_list.html`. È una
convenzione e come tale il vantaggio sta nel togliere un argomento di discussione tra sviluppatori.

Come abbiamo visto in precedenza Django cerca i templates dentro ad ogni applicazione registrata, quindi
andiamo a creare la directory che li contiene dentro a `corsi`:

```shell
mkdir -p corsi/templates/corsi
```

Quindi creiamo il nostro template `corsi/templates/corsi/corso_list.html`:

```django
{% extends "corsi/base.html" %}

{% block content %}
    <h2>Corsi</h2>
    <ul>
        {% for corso in object_list %}
            <li>{{ corso }}</li>
        {% endfor %}
    </ul>
{% endblock %}
```

In questo template stiamo usando il linguaggio di *templating* di Django:
- usiamo `extends` per estendere un altro template
- usiamo `block` per definire un blocco di contenuto
- usiamo `for` per ciclare su una variabile, in questo caso `object_list` che è quello che la `ListView`
  passa per default al template con il `QuerySet` delle istanze del modello
- usiamo `{{ corso }}` per stampare il contenuto di una variabile, in questo caso implicitamente
  chiameremo il metodo `__str__` di `Corso`.

Se abbiamo già visto un sistema di templating non ci dovrebbe essere niente di nuovo, se è la prima volta
i sistemi di templating ci permettono di inserire della logica all'interno di file di testi in modo da
renderci la scrittura di questi più facile.

Dal momento che stiamo estendendo il template `corsi/base.html` dobbiamo crearlo, anche questo andrà
nella stessa directory del precedente in `corsi/templates/corsi/base.html`:

```django
<html>
  <head>
    <title>{% block title %}Corsi{% endblock %}</title>
  </head>
  <body>
  {% block content %}{% endblock %}
  </body>
</html>
```

Con questo template dovrebbe risultare più chiaro il funzionamento di `block`. `block` permette di
delimitare un blocco di testo in modo che possa essere sovrascritto da eventuali altri template.
In questo esempio il template che eredita `corsi/templates/corsi/base.html` sovrascrive il contenuto
del blocco `content` che vi è definito. Questo permette di poter riutilizzare buona parte dei template
che si scrivono e di sostituire solo quello di cui si ha bisogno.

Fatti i template ora dobbiamo collegare la vista al sistema di routing. Per cominciare andiamo a creare
un file di routing interno all'applicazione in `corsi/urls.py`:

```python
from django.urls import path
from corsi import views


urlpatterns = [
    path("corsi/", views.CorsoListView.as_view(), name="corsi-list"),
]
```

Definiamo un path `corsi/` che richiama la vista `CorsoListView` a cui diamo un nome `corsi-list`.

Per rendere queste url raggiungibili dobbiamo includerle dal file `catalogo/urls.py`, il file che
contiene il routing del progetto:

```python
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('corsi/', include('corsi.urls')),
]
```

Il fatto che le url stiano dentro ad una variabile chiamata `urlpatterns` è richiesto dal sistema di
routing delle url di Django.

Ora ricordiamoci di ricaricare il server web di sviluppo di Django:

```shell
python3 manage.py runserver
```

Puntiamo il browser all'indirizzo
[http://127.0.0.1:8000/corsi/corsi/](http://127.0.0.1:8000/corsi/corsi) per visualizzare il nostro
template renderizzato.

Salviamo su git i nostri progressi:

```shell
git add catalogo corsi
git commit -m "Aggiungiamo vista per list Corsi"
git push origin main
```

## Esercizi

Leggi la documentazione sui [templates](https://docs.djangoproject.com/en/3.2/topics/templates/) e sul
linguaggio dei [templates di Django](https://docs.djangoproject.com/en/3.2/ref/templates/language/).
