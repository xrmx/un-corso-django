# Form più belli

Per fare la nostra applicazione se non più bella almeno più ordinata esteticamente useremo il framework
css [Bootstrap](https://getbootstrap.com/) 4 integrato in [django-crispy-forms](https://django-crispy-forms.readthedocs.io/en/latest/index.html).

*django-crispy-forms* è una applicazione Django che offre sia un rendering dei form che sfrutta dei
framework css come *Bootstrap* che una api per creare dei form programmaticamente.

Per prima cosa installiamo *django-crispy-forms*:

```shell
pip install django-crispy-forms
```

Ogni volta che aggiungiamo una dipendenza dobbiamo aggiornare il nostro file `requirements.txt`:

```shell
pip freeze > requirements.txt
```

Ora aggiungiamo *django-crispy-forms* nella `INSTALLED_APPS` in `catalogo/settings.py`:

```python
INSTALLED_APPS = [
    ...
    'crispy_forms',
]
```

Quindi sempre in `catalogo/settings.py` configuriamo *django-crispy-forms* per usare l'integrazione con
Bootstrap 4:

```python
CRISPY_TEMPLATE_PACK = 'bootstrap4'
```

Scarichiamo [Bootstrap 4.6.0](https://github.com/twbs/bootstrap/releases/download/v4.6.0/bootstrap-4.6.0-dist.zip) ed estriamo il contenuto del pacchetto zip.
Bootstrap 4 ha come dipendenza [jQuery](https://jquery.com/) quindi scarichiamo l'ultima versione
*slim* disponibile, al momento [jQuery 3.6.0](https://code.jquery.com/jquery-3.6.0.slim.min.js).

Nel nostro progetto invece andiamo a creare la directory che conterrà i file statici condivisi dalla
nostra applicazione:

```shell
mkdir static
mkdir static/css static/js
```

Copiamo quindi i file `css/bootstrap.min.css` e `js/bootstrap.bundle.min.js` dalla directory di Boostrap
rispettivamente in `static/css` e in `static/js`. Copiamo `jquery-3.6.0.slim.min.js` in `static/js`.

La nostra directory `static` apparirà così:

```shell
static
├── css
│   └── bootstrap.min.css
└── js
    ├── bootstrap.bundle.min.js
    └── jquery-3.6.0.slim.min.js
```

Ora dobbiamo configurare Django per dirgli di cercare i nostri file statici nella directory `static`,
creiamo il seguente vicino alla configurazione `STATIC_URL` in `catalogo/settings.py`:

```python
STATICFILES_DIRS = [
    BASE_DIR / 'static',
]
```

`STATIC_URL` indica il path delle richieste che Django deve interpretare come file statici.

Ora che abbiamo configurato i file statici andiamo per prima cosa ad aggiornare il nostro template
di base presente in `corsi/templates/corsi/base.html` per includere i file CSS e JavaScript di
Bootstrap:

```django
<html>
  <head>
    <title>{% block title %}Corsi{% endblock %}</title>
    <link rel="stylesheet" href="/static/css/bootstrap.min.css">
    <script src="/static/js/jquery-3.6.0.slim.min.js"></script>
    <script src="/static/js/bootstrap.bundle.min.js"></script>
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-12">
        {% if user.is_authenticated %}<p><a href="{% url 'logout' %}">Logout</a></p>{% endif %}
        {% block content %}{% endblock %}
        </div>
      </div>
    </div>
  </body>
</html>
```

Visto che ci siamo abbiamo anche creato dei container con delle classi di Bootstrap perché siano
più presentabili.

Se puntiamo il browser sulla nostra [lista dei corsi](http://127.0.0.1:8000/corsi/corsi/) dovremmo già
poter vedere delle differenze.

La prima modalità di utilizzo di *django-crispy-forms* è quella tramite il *filtro* `crispy`.
Lo andremo ad usare nel template di login `templates/registration/login.html` per sostituire il
layout tabellare fatto a mano:

```django
{% extends "corsi/base.html" %}
{% load crispy_forms_tags %}

{% block content %}

{% if form.errors %}
<p>I tuoi username e password non sembrano corretti. Per favore riprova.</p>
{% endif %}

{% if next %}
    {% if user.is_authenticated %}
    <p>Il tuo account non ha accesso a questa pagina. Per continuare esegui il login con un account
    che ha i permessi necessari.</p>
    {% else %}
    <p>Per favore esegui il login per vedere questa pagina.</p>
    {% endif %}
{% endif %}

<form method="post" action="{% url 'login' %}">
{% csrf_token %}
{{ form|crispy }}
<input type="submit" value="login">
<input type="hidden" name="next" value="{{ next }}">
</form>
{% endblock %}
```

`crispy` è un *filtro* perché usa la sintassi con il *pipe* (`|`) per prendere il form come suo
parametro. I *templatetags* forniti dalle applicazioni sono caricati manualmente tramite `load`.

Controlliamo dal browser come si renderizza il form, decisamente in modo migliore!

Un'altra modalità di uso di *django-crispy-forms* è quella tramite il *tag* `crispy` che permette di
renderizzare il form completamente, compresi i tag `<form>`, il token *csrf* ed il bottone di invio.

Questa modalità richiede un intervento sulla classe del form, andiamo a modificare `CorsoForm` aprendo
il file `corsi/forms.py`:

```python
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Submit
from django import forms

from corsi.models import Corso


class CorsoForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_id = "corso-form"
        self.helper.form_method = "post"
        self.helper.form_action = ""
        self.helper.add_input(Submit('submit', 'Salva'))

    class Meta:
        model = Corso
        fields = ["titolo", "descrizione", "categoria", "docenti"]
```

In questo modo abbiamo specificato di renderizzare il form con id `corso-form`, di inviare il form
come `POST` sulla stessa url tramite un botton `Salva`.

Per renderizzare il form modifichiamo il template `corsi/templates/corsi/corso_form.html` per usare
il tag `crispy`:

```django
{% extends "corsi/base.html" %}
{% load crispy_forms_tags %}

{% block content %}
{% crispy form %}
{% endblock %}
```

Controlliamo dal browser come si renderizza il form di modifica dei corsi.

Salviamo i nostri progressi in git:

```shell
git add static catalogo templates corsi requirements.txt
git commit -m "Usiamo crispy-forms e Bootstrap 4 per fare il rendering dei forms"
git push origin main
```

## Esercizi

Consulta la documentazione sui [file statici](https://docs.djangoproject.com/en/3.2/howto/static-files/).

Leggi la documentazione di *django-crispy-forms* sul [filtro crispy](https://django-crispy-forms.readthedocs.io/en/latest/filters.html) e sul [tag crispy](https://django-crispy-forms.readthedocs.io/en/latest/crispy_tag_forms.html#crispy-tag-with-form).
