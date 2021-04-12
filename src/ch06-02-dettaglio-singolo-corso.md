# Il dettaglio del singolo corso

Dopo aver fatto la vista per listare i nostri corsi creiamo una vista per vedere il dettaglio di ogni
singolo corso. Aggiungiamo la nuova vista in `corsi/views.py`.

```python
from django.views.generic import DetailView, ListView

from corsi.models import Corso


class CorsoListView(ListView):
    model = Corso


class CorsoDetailView(DetailView):
    context_object_name = 'corso'
    queryset = Corso.objects.all()
```

Questa nuova vista `CorsoDetailView` estende la vista generica `DetailView` e sovrascrive due attributi:

- `context_object_name` per usare `corso` come nome di variabile contente l'istanza di `Corso` passata
   al template, altrimenti sarebbe stata `object`.
- `queryset` per specificare il *QuerySet* dal quale prendere l'istanza, utile per filtrare a monte
  i modelli che vogliamo poter richiamare da questa vista.

L'uso di questi attributi è abbastanza arbitrario, avremmo potuto definire `model` come abbiamo fatto
per `CorsoListView` ma avremmo visto due attributi utili in meno.

Fatta la nostra vista dobbiamo aggiungerla in `corsi/urls.py` aggiungendola in `urlpatterns`: 

```python
urlpatterns = [
    path("corsi/", views.CorsoListView.as_view(), name="corsi-list"),
    path("corsi/<int:pk>/", views.CorsoDetailView.as_view(), name="corsi-detail"),
]
```

Qui possiamo fare attenzione a due cose: la prima è che i path sono considerati *chiusi*, nel senso che
una vista risponderà ad un path solo se viene trovata una corrispondenza esatta; se non fosse stato
così il secondo path non sarebbe stato raggiungibile.

L'altra cosa da notare è la cattura dei parametri nell'url, la sintassi è formata da due parti separate
da `:`:
- la prima indica il tipo, in questo esempio `int` per catturare solo le cifre; non è obbligatoria
  e se non fornita cattura il contenuto fino al prossimo `/`.
- La seconda parte è il nome che diamo alla variabile passata alla vista, `pk` è dettata da
  `DetailView` , in questo caso la variabile è configurabile tramite l'attributo `pk_url_kwarg`.
  Le viste fatte a classi appaiono come veramente magiche quando le si usano, bisogna farci la mano.

Collegata la vista al routing possiamo creare il template che si aspetta
`corsi/templates/corsi/corso_detail.html`:

```django
{% extends "corsi/base.html" %}

{% block content %}
<h2>Corso: {{ corso }}</h2>
<p>Categoria:  {{ corso.categoria }}</p>
<p>Docenti: {% for docente in corso.docenti.all %}{{ docente.username }}{% endfor %}</p>
<p>Descrizione: {{ corso.descrizione }}</p>
{% endblock %}
```

Dovrebbe essere quasi tutto familiare, facciamo attenzione solo alla variabile che usiamo per il `for`,
essenzialmente è lo stesso codice che avremmo scritto in una vista o nella shell ma senza le parentesi.

Abbiamo tutti i pezzi per poter chiamare la nostra vista dal browser, il fatto che dobbiamo sapere
l'id del nostro modello però è un po' scomodo. Per ovviare a questo possiamo estendere il nostro
modello `Corso`, aggiungendo un metodo `get_absolute_url` che tramite la funzione `reverse` recupera
il path assoluto della vista per il singolo corso.

Usare `reverse` ci permette di poter cambiare in futuro i path delle nostre url senza dover aggiornarlo
in tante occorrenze sparse nel nostro codice.

```python
from django.db import models
from django.contrib.auth.models import User
from django.urls import reverse


class Categoria(models.Model):
    titolo = models.CharField(max_length=100)

    creato = models.DateTimeField(auto_now_add=True)
    aggiornato = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.titolo

    class Meta:
        verbose_name_plural = "Categorie"


class Corso(models.Model):
    titolo = models.CharField(max_length=100)
    descrizione = models.TextField()
    categoria = models.ForeignKey(Categoria, null=True, blank=True, on_delete=models.PROTECT)
    docenti = models.ManyToManyField(User)

    creato = models.DateTimeField(auto_now_add=True)
    aggiornato = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.titolo

    def get_absolute_url(self):
        return reverse("corsi-detail", args=[self.pk])

    class Meta:
        verbose_name_plural = "Corsi"
```

Possiamo aggiornare il template `corsi/templates/corsi/corso_list.html` per trasformare le occorrenze
dei corsi in un link alla relativa pagina di dettaglio:

```django
{% extends "corsi/base.html" %}

{% block content %}
    <h2>Corsi</h2>
    <ul>
        {% for corso in object_list %}
        <li><a href="{{ corso.get_absolute_url }}">{{ corso }}</a></li>
        {% endfor %}
    </ul>
{% endblock %}
```

Puntiamo il browser all'indirizzo
[http://127.0.0.1:8000/corsi/corsi/](http://127.0.0.1:8000/corsi/corsi/) per verificare che funzioni.

Infine ricordiamoci sempre di aggiornare il nostro codice su git:

```shell
git add corsi
git commit -m "Aggiungiamo vista per dettaglio corso"
git push origin main
```

## Esercizi

Leggi la documentazione di
[DetailView](https://docs.djangoproject.com/en/3.2/ref/class-based-views/generic-display/#detailview).

Leggi la documentazione delle [urls](https://docs.djangoproject.com/en/3.2/topics/http/urls/).

Leggi la documentazione di
[get_absolute_url](https://docs.djangoproject.com/en/3.2/ref/models/instances/#get-absolute-url).

Leggi la documentazione di [reverse](https://docs.djangoproject.com/en/3.2/ref/urlresolvers/#reverse)
