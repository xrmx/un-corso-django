# Gestiamo i contenuti in Admin

Come abbiamo visto in precedenza Django offre una interfaccia già pronta per fare operazione di
inserimento, aggiornamento e cancellazione di dati chiamata *Admin*. Per poter visualizzare
i nostri modelli nell'interfaccia di amministrazione dobbiamo *registrarli* (dal nome della funzione
`admin.register`).

Registriamo quindi i modelli della nostra applicazione `corsi` in admin modificando `corsi/admin.py`:

```python
from django.contrib import admin

from corsi.models import Categoria, Corso


@admin.register(Categoria)
class CategoriaAdmin(admin.ModelAdmin):
    search_fields = ("titolo",)


@admin.register(Corso)
class CorsoAdmin(admin.ModelAdmin):
    list_display = ("__str__", "categoria")
    list_filter = ("categoria", "docenti")
    search_fields = ("titolo", "descrizione")
```

L'admin creato per gestire il modello `Categoria` è molto semplice, l'unico attributo che abbiamo
specificato è l'aver aggiunto il campo `titolo` a quelli cercabili.
Per `Corso` invece, tramite l'opzione `list_display` abbiamo modificato i campi che vengono visualizzati
nella pagina che lista tutte le istanze che abbiamo mostrando oltre a quello che restistuisce il metodo
`__str__` nel modello anche l'analogo metodo della `Categoria` associata.
Infine abbiamo abbiamo usatò la funzionalità di filtro tramite l'opzione `list_filter` permettendo di
filtrare i nostri corsi per categoria e per docenti.

Per poter accedere all'admin creiamo quindi un utente superuser con il comando:

```shell
python3 manage.py createsuperuser
```

Possiamo quindi far partire il server web di sviluppo con il seguente comando:

```shell
python3 manage.py runserver
```

Ed infine collegarci all'indirizzo [http://127.0.0.1:8000/admin](http://127.0.0.1:8000/admin) per poter
interagire con i modelli della nostra applicazione `corsi`.

Una volta verificato che tutto funziona aggiorniamo il codice su git:

```shell
git add corsi/admin.py
git commit -m "Admin per modelli corsi"
git push origin main
```

## Esercizi

Inserisci, modifica, cancella, ricerca e filtra i modelli in *Admin*.

Leggi la documentazione delle
[opzioni di ModelAdmin](https://docs.djangoproject.com/en/3.2/ref/contrib/admin/#modeladmin-options)
che abbiamo usato.
