# Upload dei file

Dopo aver visto come gestire i file statici del nostro progetto ora andiamo a vedere come è possibile
gestire file dinamici caricati dagli utenti. In questa sezione vogliamo estendere il modello `Corso`
per poter caricare un pdf contenente la brochure del corso.

Per prima cosa andiamo a creare nella directory principale del progetto la directory che conterrà
i file caricati:

```shell
mkdir uploads
```

Quindi andiamo a configurare in `catalogo/settings.py` il path alla directory che abbiamo appena
creato come `MEDIA_ROOT` ed il path da prefissare nelle url dai quali servire i file caricati come
`MEDIA_URL`:

```python
MEDIA_ROOT = BASE_DIR / 'uploads'
MEDIA_URL = '/media/'
```

Per poter accedere ai file caricati in sviluppo possiamo usare l'helper `static` che servirà i file
presenti in `MEDIA_ROOT` alle url prefissate da `MEDIA_URL` aggiungendolo alle url in
`catalogo/urls.py`:

```python
from django.conf import settings
from django.conf.urls.static import static
...

urlpatterns = [
...
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

`static` funziona esclusivamente quando `DEBUG` è attivato nella nostra configurazione.

Una volta configurato il nostro progetto per gestire i file caricati dagli utenti andiamo a modificare
il modello `Corso` aggiungendo il nuovo campo `brochure` di tipo `FileField` in `corsi/models.py`:

```python
class Corso(models.Model):
    titolo = models.CharField(max_length=100)
    descrizione = models.TextField()
    categoria = models.ForeignKey(Categoria, null=True, blank=True, on_delete=models.PROTECT)
    docenti = models.ManyToManyField(User)
    brochure = models.FileField(upload_to="corsi/corso/brochure/", null=True, blank=True)

    creato = models.DateTimeField(auto_now_add=True)
    aggiornato = models.DateTimeField(auto_now=True)

    def get_absolute_url(self):
        return reverse("corsi-detail", args=[self.pk])

    def __str__(self):
        return self.titolo

    class Meta:
        verbose_name_plural = "Corsi"
```

Per il campo `brochure` andiamo a configurare il parametro `upload_to` per specificare il path dentro
a `MEDIA_ROOT` nel quale salvare i file caricati; abbiamo usato `corsi/corso/brochure` per identificare
rispettivamente l'applicazione, il modello e quindi il campo dove abbiamo associato il file caricato.
Rendiamo il campo *nullable* perché lo stiamo aggiungendo quando abbiamo già delle istanze di Corso in
database.

Quindi creiamo la migrazione ed applichiamola:

```shell
python3 manage.py makemigrations
python3 manage.py migrate
```

Il prossimo passo consiste nell'aggiornare il form del corso. Aggiorniamo `CorsoForm` in
`corsi/forms.py`:

```python
class CorsoForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_id = "corso-form"
        self.helper.form_method = "post"
        self.helper.form_action = ""
        self.helper.attrs = {"enctype": "multipart/form-data"}
        self.helper.add_input(Submit('submit', 'Salva'))

    class Meta:
        model = Corso
        fields = ["titolo", "descrizione", "categoria", "docenti", "brochure"]
```

Abbiamo modificato il form per permettere di modificare il nuovo campo `brochure` aggiungendolo in
`fields` e abbiamo aggiunto tramite l'attributo `attrs` dell'istanza di `FormHelper` l'attributo
`enctype` con valore `multipart/form-data` in modo da permettere l'upload di file in aggiunti ai normali
campi del form.

Dopo il form aggiorniamo anche il template di dettaglio del corso per visualizzare il valore del nuovo
campo `brochure` aggiornando il file `corsi/templates/corsi/corso_detail.html`:

```django
{% extends "corsi/base.html" %}

{% block content %}
<h2>Corso: {{ corso }}</h2>
<p><a href="{% url 'corsi-update' corso.pk %}">Modifica</a></p>

<p>Categoria: {{ corso.categoria }}</p>
<p>Docenti: {% for docente in corso.docenti.all %}{{ docente.username }}{% endfor %}</p>
<p>Descrizione: {{ corso.descrizione }}</p>
<p>Brochure: {% if corso.brochure %}
<a href="{{ corso.brochure.url }}">Scarica</a>
{% else %}
Nessuna brochure disponibile
{% endif %}</p>

<p><a href="{% url 'corsi-list' %}">Torna alla lista</a></p>
{% endblock %}
```

In questo caso stiamo mostrando un link al file quando presente o in alternativa un messaggio di assenza
del file. Facciamo attenzione al fatto che viene valutata la presenza del file tramite l'attributo
`brochure` mentre l'url è disponibile come attributo `url` solo quando il campo ha un file associato.

Possiamo verificare di poter caricare una brochure puntando il nostro browser all'indirizzo
[http://127.0.0.1:8000/corsi/corsi](http://127.0.0.1:8000/corsi/corsi) e aggiungendo od aggiornando
un corso.

Dal momento che i file caricati dagli utenti non devono essere salvati in git, aggiungiamo la directory
`uploads` ai file che git deve ignorare:

```shell
echo "uploads/" >> .gitignore
```

Infine aggiorniamo i nostri progressi su git e GitHub:

```shell
git add corsi catalogo .gitignore
git commit -m "Aggiungiamo il campo brochure a Corso"
git push origin main
```

## Esercizi

Leggi la documentazione delle configurazioni
[MEDIA_ROOT](https://docs.djangoproject.com/en/3.2/ref/settings/#std:setting-MEDIA_ROOT) e 
[MEDIA_URL](https://docs.djangoproject.com/en/3.2/ref/settings/#std:setting-MEDIA_URL).

Leggi la reference del campo
[FileField](https://docs.djangoproject.com/en/3.2/ref/models/fields/#filefield) e un articolo specifico
sulla [gestione dei file](https://docs.djangoproject.com/en/3.2/topics/files/) in Django.

Consulta la documentazione per scoprire come è implementato 
[l'upload dei file](https://docs.djangoproject.com/en/3.2/topics/http/file-uploads/).
