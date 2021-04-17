# Fare le query

Ora che abbiamo creato i nostro modelli possiamo usare l'interfaccia di Django per creare delle istanze,
modificarle ed eliminarle.

Questi sono i nostri modelli:

```python
from django.db import models
from django.contrib.auth.models import User


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

    class Meta:
        verbose_name_plural = "Corsi"
```

## Creare oggetti

Come abbiamo visto in precedenza Django implementa il pattern *Active record* e quindi per creare i
nostri dati dobbiamo interagire con le classi che abbiamo definito.

Per eseguire il codice qua sotto useremo la shell Django, richiamabile con il comando:

```shell
python3 manage.py shell
```

La shell si presenterà come una REPL simile a quella di Python:

```
Python 3.9.2 (default, Feb 28 2021, 17:03:44) 
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
(InteractiveConsole)
>>>
``` 

Da questa shell possiamo eseguire tutti gli esempi successivi.

Per cominciare creiamo una `Categoria`:

```python
from corsi.models import Categoria
categoria = Categoria(titolo="Sviluppo software")
categoria.save()
```

Creare una istanza della classe non è sufficiente per persisterla nel database, bisogna chiamare il
metodo `save()`. `save()` si occupa sia dell'inserimento che dell'aggiornamento in database
automaticamente, chiamandolo più di una volta sulla stessa istanza non ne creerà di nuove.

Esiste un helper che raggruppa le due operazioni che useremo negli esempi successivi:

```python
Categoria.objects.create(titolo="Sviluppo software")
```

## Relazioni uno a molti

Ora procediamo creando il `Corso`:

```python
from corsi.models import Corso
corso = Corso.objects.create(
    titolo="Corso Django", descrizione="Un corso su Django", categoria=categoria)
```

Come potete vedere i campi di relazione si assegnano usando una istanza **salvata in database** del
modello a cui fanno riferimento.

## Relazioni molti a molti

Per comporre una relazione *molti a molti* abbiamo bisogno che entrambi i modelli siano già
*salvati in database*. Quindi procediamo con la creazione di un utente che fungerà da docente per il
nostro corso:

```python
from django.contrib.auth.models import User
docente = User.objects.create_user("docente")
```

Il modello `User` implementa un metodo specifico `create_user` come interfaccia per creare una istanza,
questo è un pattern abbastanza diffuso per nascondere un po' di complessità per gli utilizzatori.

Per aggiungere il docente al corso si usa la seguente sintassi:

```python
corso.docenti.add(docente)
```

L'interfaccia per aggiornare i `ManyToManyField` ha delle somiglianze con quella dei `set` del linguaggio
Python.

## Leggere dal database

Il metodo per recuperare una singola istanza è `.get()`, può essere chiamato senza parametri se esiste
una sola istanza in database per un dato modello oppure possiamo passargli dei parametri:

```python
categoria = Categoria.objects.get()
categoria_con_parametri = Categoria.objects.get(titolo="Sviluppo software")
categoria == categoria_con_parametri
```

La nostra comparazione restituisce  `True` perché l'istanza è la stessa.

Per recuperare tutte le istanze si usa `.all()`:

```python
Categoria.objects.all()
```

Per recuperare invece più di una istanza filtrandola per qualche parametro si usa `.filter()`:

```python
Categoria.objects.filter(titolo="Sviluppo software")
```

I campi `ForeignKey` e `ManyToManyField` si possono filtrare usando una istanza di un altro modello o
un suo attributo:

```python
Corso.objects.filter(categoria=categoria)
Corso.objects.filter(categoria__titolo="Sviluppo software")
Corso.objects.filter(docenti=docente)
Corso.objects.filter(docenti__username="docente")
```

Sia `all()` che `filter()` restituiscono dei `QuerySet`. I `QuerySet` sono *lazy* nel senso che sono
valutati solo quando ci vengono fatte sopra delle operazioni come iterarci sopra o stamparli. Nei nostri
esempi sono stati valutati perché nella shell viene stampato la rappresentazione dell'output delle
istruzioni date. Ad esempio se assegniamo un `QuerySet` ad una variabile, il `QuerySet` non sarebbe
valutato e quindi la query SQL sottostante non sarebbe eseguita.

Possiamo filtrare le nostre istanze anche in modo negativo cioè specificando dei criteri per
l'esclusione usando il metodo `.exclude()`:

```python
Corso.objects.exclude(categoria=categoria)
```

Con la query precedente abbiamo escluso tutti i corsi facenti parte di una categoria specifica.
I metodi `filter` ed `exclude` possono essere usati contemporaneamente per costruire lo stesso QuerySet.

I QuerySet sono ordinabili usando il metodo `order_by()`:

```python
Corso.objects.order_by("titolo")
```

Se non ordiniamo esplicitamente i QuerySet non sono ordinati, anche se può sembrare lo siano. Possiamo
ordinare i QuerySet per un numero arbitriario di campi.

I metodi che abbiamo visto finora restituiscono sempre un QuerySet contente istanze di modelli,
questo comporta:
- fare una query SQL per recuperare tutte le colonne delle righe coinvolte
- per ognuna di queste righe creare una nuova istanza del nostro modello

In alcuni casi questo potrebbe comportare far fare alla nostra applicazione più lavoro di quello
necessario. Esistono altri due metodi che ci permettono di restituire un sottoinsieme dei campi senza
costruire le istanze dei modelli.

Il metodo `values()` restituisce un QuerySet di dizionari con chiave il nome del campo e come valore
il valore del campo:

```python
Corso.objects.values("titolo", "categoria")
```

Ogni elemento del QuerySet sarà un dizionario del tipo `{"titolo": "titolo", "categoria": 1}` dove
`1` è il valore della chiave primaria dell'istanza di `Categoria` collegata al `Corso`. Se non
specifichiamo alcun campo saranno restituiti tutti quelli del modello.

Il metodo `values_list()` invece restituisce un QuerySet di tuple:

```python
Corso.objects.values_list("titolo", "categoria")
```

Ogni elemento del QuerySet sarà una tupla del tipo `("titolo", 1)`. `values_list()` dispone di un
parametro che permette di rendere *flat* l'output restituito:

```python
Corso.objects.values_list("categoria", flat=True)
```

Ogni elemento del QuerySet sarà un numero che identifica il valore di una chiave primaria di `Categoria`.
Questo metodo si sposa bene con `distinct()` che elimina i duplicati dal nostro QuerySet.

Infine altri due metodi utili sono `count()` per far contare al database quante istanze ci sono in un
QuerySet, mentre `exists()` restituisce un valore boolean che indica la presenza o meno di istanze
nel QuerySet:

```python
Corso.objects.filter(categoria=categoria).count()
Corso.objects.filter(categoria=categoria).exists()
```

## Eliminare istanze modelli

Per eliminare delle istanze di modelli possiamo usare il metodo `delete()` sia sulla istanza che sui
`QuerySet`:

```python
Corso.objects.all().delete()
Categoria.objects.get().delete()
```

Abbiamo cancellato prima tutte le istanze di `Corso` e successivamente la `Categoria` perché abbiamo
configurato Django per proteggere la cancellazione di una `Categoria` quando viene usata da un `Corso`.

## Esercizi

Apri una [shell Django](https://docs.djangoproject.com/en/3.2/ref/django-admin/#shell) e prova a creare, modificare ed eliminare dei modelli.

Leggi l'introduzione della [documentazione dei QuerySet](https://docs.djangoproject.com/en/3.2/ref/models/querysets/).
