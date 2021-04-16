# Filtriamo i corsi

Continuiamo ad estendere la nostra vista per listare i corsi per darci la possibilità di filtrare
la lista dei corsi ricercando un test nel titolo o nella descrizione di ogni corso.

Per prima cosa estendiamo il template `corsi/templates/corsi/corso_list.html` aggiungendo un box di
ricerca:

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
{% endblock %}
```

Il box di ricerca farà una richiesta alla medesima pagina aggiungendo come *query string* una chiave *q*
con valore il testo della nostra ricerca.

Quindi dobbiamo estendere la vista per supportare questa funzionalità. Andremo a cambiare
`CorsoListView` in questo modo:

```python
class CorsoListView(ListView):
    queryset = Corso.objects.all()

    def get_queryset(self):
        qs = super().get_queryset()
        query = self.request.GET.get("q")
        if query:
            return qs.filter(Q(titolo__icontains=query) | Q(descrizione__icontains=query))
        else:
            return qs
```

Abbiamo implementato il metodo `get_queryset()` che richiede l'aggiunta dell'attributo `queryset`.
Dentro al metodo prima ci salviamo l'output dell'implementazione di default nella variabile `qs`,
quindi prendiamo il valore della chiave *q* e se esiste lo usiamo per filtrare ulteriormente il
`QuerySet`.
Per filtrare il `QuerySet` introduciamo due nuove funzionalità, l'oggetto *Q* e i *lookups* dei campi.
Gli oggetti *Q* ci permettono di implementare le query con filtri in *OR* logico (vedi *|*), se avessimo
messo due `filter()` di seguito sarebbero stati in *AND* logico.
I *lookups* invece ci permettono di filtrare nei campi in modo più specifico rispetto alla semplice
uguaglianza, in questo caso abbiamo usato `icontains` per cercare all'interno del campo in modo
*case-insensitive* la presenza di una stringa.

Puntiamo il browser su [http://127.0.0.1:8000/corsi/corsi/](http://127.0.0.1:8000/corsi/corsi/) e
testiamo che funzioni a dovere.

Ora che abbiamo visto che funziona possiamo scrivere un test automatico per verificare che continui
a farlo. Creiamo un file `corsi/tests/test_views.py` con il seguente contenuto:

```python
from django.test import TestCase
from django.urls import reverse

from corsi.models import Corso


class CorsoListViewTestCase(TestCase):
    def test_filtro_titolo(self):
        Corso.objects.create(titolo="titolo corso")
        url = reverse("corsi-list")
        response = self.client.get(f"{url}?q=tito")
        self.assertContains(response, "titolo corso")

    def test_filtro_descrizione(self):
        Corso.objects.create(titolo="titolo corso", descrizione="descrizione")
        url = reverse("corsi-list")
        response = self.client.get(f"{url}?q=descr")
        self.assertContains(response, "titolo corso")

    def test_filtro_senza_match(self):
        Corso.objects.create(titolo="titolo", descrizione="descrizione")
        url = reverse("corsi-list")
        response = self.client.get(f"{url}?q=nomatch")
        self.assertNotContains(response, "titolo corso")
```

In questo `TestCase` abbiamo introdotto due nuovi tipi di assert `assertContains` e `assertNotContains`
che rispettivamente controllano che una stringa sia presente o meno nella risposta ad una chiamata.
Per effettuare queste chiamate usiamo il client presente per default come attributo `client` all'interno
della classe. Il client viene inizializzato da zero per ogni singolo test.

Facciamo girare i test con il comando:

```shell
python3 manage.py test --keepdb
```

Lo switch `--keepdb` non fa cancellare e creare a Django un nuovo database nel quale far girare i test
se ne esiste già uno.

Per concludere aggiorniamo i nostri progressi in git:

```shell
git add corsi
git commit -m "Aggiungiamo filtro sulla lista dei corsi"
git push origin main
```

## Esercizi

Guarda come è fatto l'oggetto `HttpRequest` di Django nella
[documentazione](https://docs.djangoproject.com/en/3.2/ref/request-response/#httprequest-objects)

Guarda quali altri *lookups* sono disponibili nella
[documentazione](https://docs.djangoproject.com/en/3.2/topics/db/queries/#field-lookups)

Approfondisci l'oggetto *Q* nella
[documentazione](https://docs.djangoproject.com/en/3.2/topics/db/queries/#complex-lookups-with-q-objects)

Leggi la documentazione dei
[tool di testing](https://docs.djangoproject.com/en/3.2/topics/testing/tools/) e di
[assertContains](https://docs.djangoproject.com/en/3.2/topics/testing/tools/#django.test.SimpleTestCase.assertContains)
