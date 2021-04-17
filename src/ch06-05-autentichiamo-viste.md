# Autentichiamo le viste

Lasciare la creazione e la modifica dei corsi a qualsiasi utente perlopiù sconosciuto non è una buona
idea. Facciamo in modo che le viste di creazione e di modifica richiedano un account sulla nostra
istanza Django.

Per fare questo apriamo nel nostro editor `corsi/views.py` e modifichiamo le classi in questo modo:

```python
from django.contrib.auth.mixins import LoginRequiredMixin

...


class CorsoCreateView(LoginRequiredMixin, CreateView):
    model = Corso
    form_class = CorsoForm


class CorsoUpdateView(LoginRequiredMixin, UpdateView):
    model = Corso
    form_class = CorsoForm
```

Non abbiamo fatto altro che modificare le nostre classi per estendere anche il mixin
`LoginRequiredMixin` che rende le nostre viste accessibili solo ad utenti che si sono autenticati nella
nostra applicazione.

## Login

Per permettere ai nostri utenti di autenticarsi però dobbiamo fornirgli una vista di login.
Fortunatamente Django ne include già una, quello che dobbiamo fare è aggiungerla nel sistema di routing
delle url.

Apriamo il file `catalogo/urls.py` e modifichiamolo così:

```python
from django.contrib import admin
from django.contrib.auth import views as auth_views
from django.urls import include, path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('corsi/', include('corsi.urls')),
    path('accounts/login/', auth_views.LoginView.as_view(), name='login'),
]
```

Configuriamo la vista per reindirizzare l'utente, se non specificato diversamente, alla lista dei corsi
aggiungendo nel file `catalogo/settings.py`:

```python
LOGIN_REDIRECT_URL = 'corsi-list'
```

Questa vista di login, al pari di quelle che abbiamo scritto noi, richiede un template. Fino ad ora
abbiamo inserito i nostri template all'interno di una directory specifica della nostra applicazione
`corsi`.
In questo caso però il login è una funzionalità comune a tutto il progetto. Django ci permette di
specificare una lista di directory dove cercare i nostri templates fuori dalle nostre applicazioni.

Creiamo una directory nella root del progetto:

```shell
mkdir templates
```

Quindi modifichiamo l'attributo `TEMPLATES` in `catalogo/settings.py`:

```python
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / Path('templates')],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]
```

Abbiamo modificato la chiave `DIRS` aggiungendo la directory che abbiamo creato. Da notare la creazione
del path della directory usando `/` per unire due percorsi fomati da istanze di `Path` del modulo
[pathlib](https://docs.python.org/3/library/pathlib.html).

La vista di login si aspetta un template nel percorso `registration/login` quindi creiamo la directory
dentro templates:

```shell
mkdir -p templates/registration
```

E creiamo il template `templates/registration/login.html`:

```django
{% extends "corsi/base.html" %}

{% block content %}

{% if form.errors %}
<p>Lo username e/o la password non sembrano corretti. Per favore riprova.</p>
{% endif %}

{% if next %}
    {% if user.is_authenticated %}
    <p>Il tuo account non ha accesso a questa pagina, Per continuare esegui il login con un account
    che hai permessi necessari.</p>
    {% else %}
    <p>Per favore esegui il login per vedere questa pagina.</p>
    {% endif %}
{% endif %}

<form method="post" action="{% url 'login' %}">
{% csrf_token %}
<table>
<tr>
    <td>{{ form.username.label_tag }}</td>
    <td>{{ form.username }}</td>
</tr>
<tr>
    <td>{{ form.password.label_tag }}</td>
    <td>{{ form.password }}</td>
</tr>
</table>

<input type="submit" value="login">
<input type="hidden" name="next" value="{{ next }}">
</form>
{% endblock %}
```

Andiamo ad analizzare questo template pezzo per pezzo.

Usiamo `form.errors` per capire se il nostro form si è rivelato valido o meno, se errors è valorizzato
il form non è valido e quindi mostriamo un messaggio di errore.

Controlliamo la valorizzazione della variabile `next` per distinguere il caso in cui siamo stati
reindirizzati al login o ci siamo arrivati direttamente. Se `next` è valorizzata distinguiamo inoltre
se siamo già loggati e quindi non abbiamo i permessi necessari per vedere una vista o se non siamo
ancora loggati.

Il form invece differisce da quello che abbiamo creato in precedenza perché il rendering del form viene
fatto manualmente campo per campo; possiamo notare come mostriamo separatamente per ogni campo la label
ed il campo di input.

Con il template possiamo far puntare il nostro browser su
[http://127.0.0.1:8000/accounts/login](http://127.0.0.1:8000/accounts/login) ed usare i dati del
nostro utente per verificare che funzioni.

## Logout

Fatto il login dobbiamo implementare anche il logout.

Cominciamo con l'aggiungere la vista nelle nostre url:

```
urlpatterns = [
    path('admin/', admin.site.urls),
    path('corsi/', include('corsi.urls')),
    path('accounts/login/', auth_views.LoginView.as_view(), name='login'),
    path('accounts/logout/', auth_views.LogoutView.as_view(), name='logout'),
]
```

Al pari della vista di login anche quella di logout ci permette di specificare una vista verso la
quale reindirizzare l'utente a logout avvenuto. Configuriamo `catalogo/settings.py` per reindirizzare
l'utente anche in questo caso verso la lista dei corsi:

```
LOGOUT_REDIRECT_URL = 'corsi-list'
```

Per provare la vista modifichiamo il nostro template `corsi/templates/corsi/base.html` inserendo un
link alla vista di logout nel caso l'utente sia autenticato:

```django
<html>
  <head>
    <title>{% block title %}Corsi{% endblock %}</title>
  </head>
  <body>
  {% if user.is_authenticated %}<p><a href="{% url 'logout' %}">Logout</a></p>{% endif %}
  {% block content %}{% endblock %}
  </body>
</html>
```

Testiamo che il link sia funzionante tramite il nostro browser.

Ora è il momento di far girare i nostri test:

```shell
python3 manage.py test --keepdb
```

Oops! abbiamo una bella serie di errori e fallimenti:

```
ERROR: test_posso_creare_nuovo_corso (corsi.tests.test_views.CorsoCreateViewTestCase)
FAIL: test_corso_non_viene_aggiornato_se_payload_invalido (corsi.tests.test_views.CorsoUpdateViewTestCase)
FAIL: test_posso_aggiornare_corso (corsi.tests.test_views.CorsoUpdateViewTestCase)
```

Tutti i test che falliscono sono test che riguardano le viste. Per ogni test fallito viene stampato
se c'è stato un errore nell'esecuzione del test (*ERROR*), come nel primo caso, oppure se il test è
semplicemente fallito perché un'asserzione non ha dato il risultato sperato (*FAIL*).
Quindi per ogni test vediamo il nome del test e separatamente il *TestCase* che lo include. Questa
notazione è anche quella che ci permette di eseguire i test ed i *TestCase* singolarmente, come ad
esempio:

```shell
# singolo TestCase
python3 manage.py test --keepdb corsi.tests.test_views.CorsoCreateViewTestCase
# singolo test
python3 manage.py test --keepdb corsi.tests.test_views.CorsoCreateViewTestCase.test_posso_creare_nuovo_corso
```

Per ogni test inoltre abbiamo una *traceback* cioè lo stato dell'esecuzione al momento del fallimento
in ordine cronologico.

Andiamo a vedere nel dettaglio perché i test sono falliti. Il primo test fallisce perché la chiamata
alla vista di creazione del corso non ha creato un nuovo corso, il secondo fallisce perché lo
*status code HTTP* della risposta alla chiamata di aggiornamento è cambiato ed infine il terzo è fallito
perché l'url a cui si viene reindirizzati non è quella che ci aspettiamo.

I test hanno fatto il loro lavoro e hanno evidenziato dei cambiamenti di comportamento. Le viste
di creazione e modifica dei corsi infatti ora richiedono che l'utente sia autenticato.

Apriamo il file `corsi/tests/test_views.py` per sistemarli:

```python
class CorsoCreateViewTestCase(TestCase):
    def test_posso_creare_nuovo_corso(self):
        user = User.objects.create_user("username", password="password")
        url = reverse("corsi-create")
        data = {
            "titolo": "titolo",
            "descrizione": "descrizione",
            "docenti": [user.pk],
        }
        self.client.login(username="username", password="password")
        response = self.client.post(url, data=data)
        corso = Corso.objects.get(titolo="titolo", descrizione="descrizione")
        redirect_url = reverse("corsi-detail", args=[corso.pk])
        self.assertRedirects(response, redirect_url)
```

Abbiamo aggiunto un password al nostro utente in modo da poter effettuare il login tramite il metodo
`login()` del client dei test.

> Tutti i test si correggono con lo stesso intervento, sistemali in autonomia

```shell
python3 manage.py test --keepdb
```

Ottimo, i vecchi test passano! Aggiungiamone di nuovi per testare che le viste sono disponibili solo
per gli utenti autenticati:

```python
class CorsoCreateViewTestCase(TestCase):
    ...

    def test_la_vista_richiede_autenticazione(self):
        url = reverse("corsi-create")
        response = self.client.post(url, data={})
        redirect_url = reverse("login") + f"?next={url}"
        self.assertRedirects(response, redirect_url)


class CorsoUpdateViewTestCase(TestCase):
    ...

    def test_la_vista_richiede_autenticazione(self):
        corso = Corso.objects.create(titolo="titolo", descrizione="descrizione")
        url = reverse("corsi-update", args=[corso.pk])
        response = self.client.post(url, data={})
        redirect_url = reverse("login") + f"?next={url}"
        self.assertRedirects(response, redirect_url)
```

Verifichiamo che i test passano:

```shell
python3 manage.py test --keepdb
```

Quindi salviamo i nostri progressi in git:

```shell
git add corsi catalogo templates
git commit -m "Proteggiamo creazione ed aggiornamento da login"
git push origin main
```

## Esercizi

Rendiamo le viste di creazione ed aggiornamento delle categoria disponibili solo per gli utenti
autenticati ed aggiorniamo i test. Salva i progressi su git e pubblicali su GitHub.

Consulta la documentazione di [LoginRequiredMixin](https://docs.djangoproject.com/en/3.2/topics/auth/default/#the-loginrequired-mixin).

Consulta la documentazione di [LoginView](https://docs.djangoproject.com/en/3.2/topics/auth/default/#django.contrib.auth.views.LoginView).

Leggi la documentazione di [LOGIN_REDIRECT_URL](https://docs.djangoproject.com/en/3.2/ref/settings/#login-redirect-url).

Guarda quali valori vengono messi per default nel [contesto dei template](https://docs.djangoproject.com/en/3.2/ref/templates/api/#built-in-template-context-processors)

Consulta la documentazione di [LogoutView](https://docs.djangoproject.com/en/3.2/topics/auth/default/#django.contrib.auth.views.LogoutView).

Leggi la documentazione di [LOGOUT_REDIRECT_URL](https://docs.djangoproject.com/en/3.2/ref/settings/#std:setting-LOGOUT_REDIRECT_URL).
