# I modelli

Come abbiamo visto il nostro progetto `catalogo` dovrà contenere una libreria di corsi. Procediamo
quindi a creare una nuova applicazione `corsi`:

```shell
python3 manage.py startapp corsi
```

Fatta l'applicazione è ora di definire come vogliamo modellare i corsi che vogliamo gestire. Ribadiamo
ancora che questa è ovviamente una visione semplificata del problema!
Per cominciare per ogni corso vogliamo avere un titolo ed una descrizione e vogliamo tenere traccia
della data di inserimento e di modifica di ogni corso.

Come abbiamo visto i modelli della nostra applicazione sono contenuti nel file `models.py`, aprendolo
con il nostro editor dovrebbe apparire così:

```python
from django.db import models

# Create your models here.
```

Cominciamo a scrivere il nostro modello per il singolo corso che chiameremo `Corso`:

```python
from django.db import models


class Corso(models.Model):
    titolo = models.CharField(max_length=100)
    descrizione = models.TextField()

    creato = models.DateTimeField(auto_now_add=True)
    aggiornato = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.titolo

    class Meta:
        verbose_name_plural = "Corsi"
```

La prima cosa da dire è che i modelli in Django seguono il pattern [Active Record](https://en.wikipedia.org/wiki/Active_record_pattern) cioè c'è una mappatura 1:1 tra una classe ed una tabella in database,
dove ogni istanza della classe identifica una riga.
Di norma tutte le classi che ereditano da `models.Model` implementano questo pattern.

Gli attributi della classe quindi sono le colonne della nostra tabella in database. Ogni attributo è una
istanza di una classe `*Field`. Ognuna di queste classi implementa un tipo diverso di dato nel database
a seconda del backend usato.
Il backend `mysql` genera il seguente SQL per la classe `Corso`:

```sql
CREATE TABLE `corsi_corso` (
    `id` integer AUTO_INCREMENT NOT NULL PRIMARY KEY,
    `titolo` varchar(100) NOT NULL,
    `descrizione` longtext NOT NULL,
    `creato` datetime(6) NOT NULL,
    `aggiornato` datetime(6) NOT NULL
);
```

Possiamo notare:

- il nome della tabella viene generato unendo il nome dell'applicazione `corsi` con quello della classe
  `Corso`;
- viene inserito per default in campo `id` numerico come chiave primaria, è possibile specificarne uno
  diverso definendo un attributo con parametro `primary_key=True`;
- tutti i campi sono non *nullable* per default a meno che non venga specificato `null=True`;
- le opzioni `auto_now_add` e `auto_now` per settare automaticamente una data rispettivamente alla
  creazione e all'aggiornamento di una istanza non sono gestite dal database ma da Django.

Nella nostra classe `Corso` abbiamo implementato il metodo `__str__` che viene usato da Django quando
stampiamo una istanza, in questo caso restituiamo il titolo. Come suggerisce il nome questo metodo deve
restituire una stringa.

Per gestire dei metadati dei modelli Django utilizza la metaprogrammazione tramite la definizione di
`Meta` dove andiamo a mettere tutto quello che non è un campo del database, in questo caso la usiamo
solamente per definire il nome plurale della nostra classe che verrà usato nell'interfaccia di
amministrazione ma qui possiamo forzare un altro nome per la tabella in database, un ordine di default
o anche la definizione di indici della tabella.

Ora che abbiamo un modello vogliamo aggiungerla la nostra applicazione in `catalogo/settings.py`:

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'corsi',
]
```

Ora possiamo generare ed applicare le migrazioni con i seguenti comandi:

```shell
python3 manage.py makemigrations
python3 manage.py migrate
```

Entrambi i comandi prendono opzionalmente la lista delle applicazioni a cui limitarsi, per default
usano tutte le applicazioni configurate.

Salviamo i nostri progessi in git e inviamoli a GitHub:

```shell
git add catalogo/settings.py corsi
git commit -m "Aggiungiamo applicazione per gestire i corsi"
git push origin main
```

## Esercizi

Leggi la documentazione dei campi dei modelli che abbiamo usato nella [reference](https://docs.djangoproject.com/en/3.2/ref/models/fields/).

Leggi la [documentazione](https://docs.djangoproject.com/en/3.2/topics/migrations/) dei comandi delle
migrazioni che abbiamo usato.
