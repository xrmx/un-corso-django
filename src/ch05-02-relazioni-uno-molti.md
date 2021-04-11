# Le relazioni uno a molti

Vogliamo estendere il nostro modello `Corso` per poter classificare i corsi in categorie. Per fare
questo introdurremo un nuovo modello `Categoria` collegato a `Corso` da una chiave esterna.

Modifichiamo il nostro file `models.py` così:

```python
from django.db import models


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

    creato = models.DateTimeField(auto_now_add=True)
    aggiornato = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.titolo

    class Meta:
        verbose_name_plural = "Corsi"
```

Abbiamo aggiunto un nuovo modello `Categoria` con il solo attributo `titolo` usando gli stessi elementi
visti in precedenza. In `Corso` invece abbiamo usato un nuovo tipo di campo `ForeignKey` che serve a
definire una chiave esterna e tre nuovi parametri `null`, `blank` e `on_delete`.
`null` rende il campo *nullable*, ci serve perché potremmo avere delle istanza di `Corso` già inserite
in database e quindi non fornendo un valore di default non potremmo applicare la migrazione.
`blank` invece permette al campo di essere *vuoto* nell'interfaccia di amministrazione,  *vuoto* può
assumere diversi significati: una relazione opzionale per le chiavi esterne ma anche del testo vuoto
per un campo testuale.
`on_delete` infine specifica come vogliamo Django (e non il database!) tratti la cancellazione di un
oggetto referenziato. In questo caso come venga trattata la cancellazione di una `Categoria`
associata ad un `Corso`. Abbiamo scelto di usare `models.PROTECT` cioè di impedire la cancellazione di
una `Categoria` se questa viene referenziata da un `Corso`.

Creiamo ed applichiamo le migrazioni:

```shell
python3 manage.py makemigrations
python3 manage.py migrate
```

E quindi salviamo i progressi in git:

```shell
git add corsi
git commit -m "Aggiungiamo categorie ai corsi"
git push origin main
```

## Esercizi

Leggi la documentazione di
[ForeignKey](https://docs.djangoproject.com/en/3.2/ref/models/fields/#foreignkey) facendo attenzione
alle varie opzioni di [on_delete](https://docs.djangoproject.com/en/3.2/ref/models/fields/#django.db.models.ForeignKey.on_delete)
