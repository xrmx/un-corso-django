# Inseriamo e modifichiamo i corsi

Dopo le viste per listare i corsi e quella per visualizzare il singolo corso mancano all'appello altre
due viste: la prima per creare un nuovo corso e l'altra per modificarne uno già presente.

Queste viste avranno entrambe bisogno di un form che andremo ad implementare nel file `corsi/forms.py`:

```python
from django import forms

from corsi.models import Corso


class CorsoForm(forms.ModelForm):
    class Meta:
        model = Corso
        fields = ["titolo", "descrizione", "categoria", "docenti"]
```

Django offre una classe speciale di form chiamati `ModelForm`, form che sono collegati ad modello
specifico. Questo legame permette di poter generare il form automaticamente dal modello, senza bisogno
di definire i campi del form.
Abbiamo implementato `CorsoForm`, un `ModelForm` per il modello `Corso`. Oltre a specificare il modello
in `model`, l'altro attributo che abbiamo specificato è `fields` che è un attributo obbligatorio
che serve per listare tutti i campi del modello che vogliamo esporre nel nostro form.
In questo caso abbiamo inserito tutti i campi che non vengono aggiornati automaticamente,
escludendo quindi i campi con la data di creazione e di aggiornamento.

Fatto il form possiamo procedere con le due viste che ci serviranno in `corsi/views.py`:

```python
from django.db.models import Q
from django.urls import reverse
from django.views.generic import CreateView, DetailView, ListView, UpdateView

from corsi.forms import CorsoForm
from corsi.models import Corso

...

class CorsoCreateView(CreateView):
    model = Corso
    form_class = CorsoForm


class CorsoUpdateView(UpdateView):
    model = Corso
    form_class = CorsoForm
```

Le due viste estendono rispettivamente `CreateView` e `UpdateView` e per entrambe definiamo gli stessi
attributi: `model` per il modello e `form_class` per definire quale form usare. Se il form inviato
è corretto l'utente sarà rediretto alla pagina di dettaglio del corso perché Django per default redirige
verso l'url restituita dal metodo `get_absolute_url()`. Se il form non è ritenuto valido verranno
segnalati gli errori nella medesima pagina.

Le viste necessitano di un template per renderizzare il form, per default il nome è composto dal nome
del modello e dal suffisso `form.html`, nel nostro caso `corsi/templates/corsi/corso_form.html`:

```django
{% extends "corsi/base.html" %}

{% block content %}
<form method="post">{% csrf_token %}
    {{ form.as_p }}
    <input type="submit" value="Salva">
</form>
{% endblock %}
```

Come possiamo vedere il rendering è demandata al methodo `as_p()` del form che è una API dei form di
Django per renderizzare i campi dei form dentro a dei tag `p`. L'altra novità è il tag `csrf_token`,
si tratta di un tag che renderizza un campo del form contenente un token per validare che la richiesta
sia stata fatta dallo stesso sito di provenienza. Se il token inviato non risulta corretto, il form
non viene considerato valido.

Possiamo quindi collegare le nostre viste al sistema di routing:

```python
urlpatterns = [
    path("corsi/", views.CorsoListView.as_view(), name="corsi-list"),
    path("corsi/<int:pk>/", views.CorsoDetailView.as_view(), name="corsi-detail"),
    path("corsi/crea/", views.CorsoCreateView.as_view(), name="corsi-create"),
    path("corsi/<int:pk>/aggiorna", views.CorsoUpdateView.as_view(), name="corsi-update"),
]
```

Quindi se puntiamo il browser all'indirizzo [http://127.0.0.1:8000/corsi/corsi/crea](http://127.0.0.1:8000/corsi/corsi/crea) dovremmo vedere il form per l'inserimento di un nuovo corso.

La vista per modificare un corso invece è un scomoda da chiamare direttamente, quindi aggiungiamo i link
a queste viste nei template delle altre viste.

Aggiungiamo al template del dettaglio un link alla vista di modifica, visto che ci siamo aggiungiamo
anche un linka alla pagina che lista i corsi:

```django
{% extends "corsi/base.html" %}

{% block content %}
<h2>Corso: {{ corso }}</h2>
<p><a href="{% url 'corsi-update' corso.pk %}">Modifica</a></p>

<p>Categoria:  {{ corso.categoria }}</p>
<p>Docenti: {% for docente in corso.docenti.all %}{{ docente.username }}{% endfor %}</p>
<p>Descrizione: {{ corso.descrizione }}</p>

<p><a href="{% url 'corsi-list' %}">Torna alla lista</a></p>
{% endblock %}
```

Nel template che lista i corsi invece andiamo ad aggiungere un link alla vista di creazione:

```django
{% extends "corsi/base.html" %}

{% block content %}
    <h2>Corsi</h2>
    <form action="" method="GET">
        <div>
        <input name="q">
        <button>Filtra</button>
        </div>
    </form>
    <ul>
        {% for corso in object_list %}
        <li><a href="{{ corso.get_absolute_url }}">{{ corso }}</a></li>
        {% endfor %}
    </ul>
    <p><a href="{% url 'corsi-create' %}">Crea nuovo corso</a></p>
{% endblock %}
```

Ora possiamo testare facilmente dal nostro browser che tutto funzioni.

Possiamo passare a scrivere i test per assicurarci che il codice continui a funzionare anche in futuro, 
apriamo il file `corsi/tests/test_views.py` ed aggiungiamo dei nuovi testcase:

```python
from django.contrib.auth.models import User

...


class CorsoCreateViewTestCase(TestCase):
    def test_posso_creare_nuovo_corso(self):
        user = User.objects.create_user("username")
        url = reverse("corsi-create")
        data = {
            "titolo": "titolo",
            "descrizione": "descrizione",
            "docenti": [user.pk],
        }
        response = self.client.post(url, data=data)
        corso = Corso.objects.get(titolo="titolo", descrizione="descrizione")
        redirect_url = reverse("corsi-detail", args=[corso.pk])
        self.assertRedirects(response, redirect_url)


class CorsoUpdateViewTestCase(TestCase):
    def test_posso_aggiornare_corso(self):
        user = User.objects.create_user("username")
        corso = Corso.objects.create(titolo="titolo", descrizione="descrizione")
        data_aggiornamento = corso.aggiornato
        url = reverse("corsi-update", args=[corso.pk])
        data = {
            "titolo": "nuovo titolo",
            "descrizione": "nuova descrizione",
            "docenti": [user.pk],
        }
        response = self.client.post(url, data=data)
        redirect_url = reverse("corsi-detail", args=[corso.pk])
        self.assertRedirects(response, redirect_url)
        corso.refresh_from_db()
        self.assertGreater(corso.aggiornato, data_aggiornamento)

    def test_corso_non_viene_aggiornato_se_payload_invalido(self):
        corso = Corso.objects.create(titolo="titolo", descrizione="descrizione")
        url = reverse("corsi-update", args=[corso.pk])
        data_aggiornamento = corso.aggiornato
        data = {}
        response = self.client.post(url, data=data)
        self.assertEqual(response.status_code, 200)
        corso.refresh_from_db()
        self.assertEqual(corso.aggiornato, data_aggiornamento)
```

Stiamo testando che sia possibile creare un nuovo corso, che sia possibile aggiornarne uno già presente
in database e che mandando dei dati invalidi non vengano aggiornati dei corsi già presenti.
Abbiamo introdotto un nuovo tipo di assert `AssertRedirects` che controlla che la response di una
chiamata abbia fatto un redirect ad una url specifica.
Abbiamo anche introdotto l'uso delle chiamate *post* dal client di test, che prendono come parametro
`data` i dati da passare alla vista sotto forma di dizionario.

Testiamo anche il form e creiamo il file `corsi/test/test_forms.py`:

```python
from django.contrib.auth.models import User
from django.test import TestCase

from corsi.forms import CorsoForm
from corsi.models import Categoria, Corso


class CorsoFormTestCase(TestCase):
    def test_posso_creare_un_corso(self):
        user = User.objects.create_user("username")
        data = {
            "titolo": "titolo",
            "descrizione": "descrizione",
            "docenti": [user.pk],
        }
        form = CorsoForm(data)
        self.assertTrue(form.is_valid())
        corso = form.save()
        self.assertTrue(corso)

    def test_posso_aggiornare_un_corso(self):
        categoria = Categoria.objects.create(titolo="categoria")
        corso = Corso.objects.create(titolo="titolo", descrizione="descrizione")
        user = User.objects.create_user("username")
        data = {
            "titolo": "nuovo titolo",
            "descrizione": "nuova descrizione",
            "categoria": categoria.pk,
            "docenti": [user.pk],
        }
        form = CorsoForm(data, instance=corso)
        self.assertTrue(form.is_valid())
        corso = form.save()
        self.assertEqual(corso.titolo, "nuovo titolo")
        self.assertEqual(corso.descrizione, "nuova descrizione")
        self.assertEqual(corso.categoria, categoria)
        self.assertQuerysetEqual(corso.docenti.all(), [user])
```

Abbiamo aggiunto dei test per verificare che tramite il form `CorsoForm` possiamo creare una nuova
istanza di `Corso` e possiamo modificarla.
Abbiamo introdotto l'uso delle API dei `ModelForm` usando due metodi:
- `is_valid()` che controlla la validità dei dati passati al form e restituisce un booleano.
  Nel caso il form non sia valido riempie l'attributo `errors` del form con gli errori.
- `save()` che salva il contenuto del form in nuova istanza oppure nell'istanza che gli viene passata
  dal parametro `instance`.
Abbiamo anche introdotto l'uso di un nuovo tipo di assert `AssertQuerysetEqual` che controlla che un
queryset sia uguale ad una lista di valori.

Facciamo girare i test con il comando:

```python
python3 manage.py test corsi --keepdb
```

Tutti i nostri test passano, possiamo aggiornare il codice su git:

```shell
git add corsi
git commit -m "Aggiungiamo viste per creazione ed aggiornamento corsi"
git push origin main
```

## Esercizi

Replichiamo le nuove viste, le url, i template ed i test che abbiamo creato per i corsi anche per le
categorie. Salva i progressi su git e pubblicali su GitHub.

Consulta la documentazione dei [ModelForm](https://docs.djangoproject.com/en/3.2/topics/forms/modelforms/#modelform).

I form sono un argomento immenso, consulta la
[documentazione ufficiale](https://docs.djangoproject.com/en/3.2/topics/forms/).

Guarda la documentazione della [CreateView e UpdateView](https://docs.djangoproject.com/en/3.2/ref/class-based-views/generic-editing/) e un articolo specifico su come vengono gestiti i form tramite
[viste generiche](https://docs.djangoproject.com/en/3.2/topics/class-based-views/generic-editing/#model-forms).

Se vuoi saperne più su Cross-Site-Request-Forgery consulta la [documentazione](https://docs.djangoproject.com/en/3.2/ref/csrf/).

Guarda la documentazione di [AssertRedirects e AssertQuerysetEqual](https://docs.djangoproject.com/en/3.2/topics/testing/tools/) per scoprire quali opzioni supportano.
