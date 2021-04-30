# Le relazioni molti a molti

Vogliamo aggiungere un'altra funzionalità alla nostra applicazione, vogliamo tracciare i docenti dei
nostri corsi. Per fare questo introdurremo un nuovo di campo, il `ManyToManyField`. Questo campo serve
a nascondere la complessità della creazione di una relazione *molti a molti*, si tratta di una
interfaccia semplificata per inserire le occorrenze in una tabella associativa tra le due che vogliamo
mettere in relazione.

Modifichiamo il modello `Corso` per aggiungere il campo `docenti`:

```python
from django.contrib.auth.models import User

...

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

A differenza del campo `ForeignKey` in questo caso non serve usare gli attributi `null`, `blank` e
`on_delete`. L'attributo sul nostro modello infatti non implica un campo in questa tabella, è solo
l'interfaccia per la tabella associativa. Le cancellazioni di un oggetto associato ad un altro tramite
un campo `ManyToManyField` cancellano anche l'associazione.

Dopo aver aggiornato il modello generiamo la migrazione, applichiamola e salviamo i progressi:

```shell
python3 manage.py makemigrations
python3 manage.py migrate
git add corsi
git commit -m "Aggiungiamo docenti a Corso"
git push origin main
```

## Esercizi

Leggi la [documentazione](https://docs.djangoproject.com/en/3.2/ref/models/fields/#django.db.models.ManyToManyField) di `ManyToManyField`.
