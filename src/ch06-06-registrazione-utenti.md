# La registrazione degli utenti

L'ultimo pezzo per completare il puzzle è permettere agli utenti di registrarsi in autonomia. Non
implenteremo un flusso di registrazione in autonomia ma ci affideremo ad una applicazione esterna,
[django-registration](https://django-registration.readthedocs.io).

Per prima cosa installmia l'ultima versione di django-registration, al momento della scrittura siamo
alla versione 3.1.2:

```shell
pip install django-registration
```

Quando aggiungiamo delle applicazioni esterne è buona norma congelare le dipendenze in modo da
rendere il nostro progetto riproducibile. Nel mondo Python la gestione delle dipendenze è abbastanza
in fermento e ci sono diversi progetti concorrenti, in questo corso useremo le funzionalità previste
da `pip`.

Per congelare le dipendenze con `pip` possiamo usare il comando `pip freeze`:

```shell
pip freeze
```

Che stamperà un output simile a questo:

```shell
asgiref==3.3.4
confusable-homoglyphs==3.2.0
Django==3.2
django-registration==3.1.2
mysqlclient==2.0.3
pytz==2021.1
sqlparse==0.4.1
```

Per salvare una copia di questo file possiamo redirigere l'output su un file `requirements.txt` come
da convenzione:

```shell
pip freeze > requirements.txt
```

Per installare in un altro ambiente virtuale le stesse dipendenze si usa `pip install -r`:

```shell
pip install -r requirements.txt
```

Salviamo il file `requirements.txt` in git:

```shell
git add requirements.txt
git commit -m "Aggiungiamo file requirements.txt"
git push origin main
```

Salvate le dipendenze ora passiamo ad integrare `django-registration` nella nostra applicazione.
Vogliamo implementare il flusso a *2 passi* documentato nella
[documentazione ufficiale](https://django-registration.readthedocs.io/en/3.1.2/quickstart.html#configuring-the-two-step-activation-workflow). Questo flusso prevede che l'utente inserisca i campi richiesti
dalla registrazione e confermi il corretto inserimento dell'indirizzo email tramite una email di
conferma.
Faremo i primi passi assieme e lascieremo la finalizzazione come esercizio.

Per prima cosa dobbiamo configurare una variabile nella nostra configurazione per decidere per quanto
tempo lasciamo la possibilità agli utenti di finalizzare la registrazione, 7 giorni è un buon valore.

Apriamo `catalogo/settings.py` ed inseriamo:

```python
ACCOUNT_ACTIVATION_DAYS = 7
```

Visto che la conferma dell'iscrizione viene inviata tramite email e che configurare un server di posta
ci potrerebbe via del tempo utile configuriamo Django per usare un sistema di invio email che stampi
il contenuto delle email in console. Dovremmo vedere le email inviate nella stessa shell in cui
facciamo girare il server di sviluppo con `runserver`.

Sempre in `catalogo/settings.py` aggiungiamo:

```python
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
```

Quindi colleghiamo le viste di `django-registration` in `catalogo/urls.py`:

```python
urlpatterns = [
    path('admin/', admin.site.urls),
    path('corsi/', include('corsi.urls')),
    path('accounts/', include('django_registration.backends.activation.urls')),
    path('accounts/login/', auth_views.LoginView.as_view(), name='login'),
    path('accounts/logout/', auth_views.LogoutView.as_view(), name='logout'),
]
```

`django-registration` richiede diversi template da implementare, creiamo nella nostra directory dei
templates una directory per contenerli:

```shell
mkdir templates/django_registration
```

Ora manca solo creare i template; segui la [documentazione ufficiale](https://django-registration.readthedocs.io/en/3.1.2/quickstart.html#required-templates) per sapere quali creare, a cosa servono e quali
variabili ricevono.

Dopo aver creato i templates puntando il browser all'indirizzo
[http://127.0.0.1:8000/accounts/register/](http://127.0.0.1:8000/accounts/register/) possiamo testare
il processo di registrazione.

Una volta che tutto funziona aggiorniamo i nostri progressi su git:

```shell
git add catalogo templates
git commit -m "Aggiunta registrazione"
git push origin main
```

## Esercizi

Se vuoi saperne di più sull'invio delle email in Django consulta la
[documentazione](https://docs.djangoproject.com/en/3.2/topics/email/) e anche quella specifica dei
[test](https://docs.djangoproject.com/en/3.2/topics/testing/tools/#email-services).
