# Creiamo una vista

Ora che abbiamo creato la nostra applicazione homepage cominciamo con l'implementazione di una vista.

Come abbiamo visto precedentemente le viste sono contenute nel file *views.py* e se lo apriamo con il
nostro editor ci ritroveremo con qualcosa del genere:

```python
from django.shortcuts import render

# Create your views here.
```

Sostituiamo tutto il contenuto del file con il seguente:

```python
from django.http import HttpResponse
from django.views import View


class HomepageView(View):
    def get(self, request):
        return HttpResponse("This is the homepage")
```

Abbiamo creato una vista chiamata `Homepage` implementata a classi, in inglese *class-based view (CBV)*.
L'implementazione è abbastanza semplice: estendiamo la classe `View` ed implementiamo il metodo `get`
che ci permette di definire un handler per richieste HTTP con metodo GET. A queste richieste
rispondiamo con `This is the homepage`.  Non specifichiamo lo *status code*, perché il default è 200.

> Django permette di scrivere le viste anche come funzioni, anche qui non c'è un modo migliore per
> farlo, dipende dalla necessità. In questo libro usiamo sempre le viste a classi perché per la nostra
> esperienza permettono di riusare più codice e attenersi alle interfacce già previste da Django
> tende a far scrivere più omogeneo.

Fatta la vista dobbiamo collegarla al routing delle URL. Il routing delle URL del progetto è definito
nel file `nuovoprogetto/urls.py`.

Aperto con l'editor, esclusa la documentazione all'inizio, dovrebbe essere così:

```python
from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('admin/', admin.site.urls),
]
```

Aggiungiamo nel routing la nostra vista `Homepage` modificando il file in questo modo:

```python
from django.contrib import admin
from django.urls import path

from homepage.views import HomepageView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', HomepageView.as_view()),
]
```

Il sistema di routing si aspetta una *callable* perciò dobbiamo chiamare il metodo `as_view()` della
nostra classe.

Rifacciamo partire il `runserver` se lo abbiamo spento con il comando:

```shell
python3 manage.py runserver
```

Se puntiamo il browser su [http://127.0.0.1:8000/](http://127.0.0.1:8000/) dovremmo vedere la nostra
homepage.

## Esercizi

- Come possiamo restituire uno status code diverso da 200? Guarda nella documentazione ufficiale di
  [HttpResponse](https://docs.djangoproject.com/en/3.2/ref/request-response/#httpresponse-objects)
  come sia possibile farlo.
