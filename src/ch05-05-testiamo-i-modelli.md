# Testiamo i modelli

Testare la nostra applicazione è necessario per avere una applicazione funzionante adesso quando la
scriviamo e nel futuro.

Per prima cosa quindi andiamo a creare la directory che ospiterà i file dei nostri test e creiamo
il file per contenere i test per i modelli:

```shell
mkdir corsi/tests
touch corsi/tests/__init__.py
git mv corsi/tests.py corsi/tests/test_models.py
```

Apriamo il file `corsi/tests/test_models.py` con il nostro editor e cominciamo a scrivere dei test per il
modello `Categoria`:

```python
from django.test import TestCase

from corsi.models import Categoria


class CategoriaTestCase(TestCase):
    def test_posso_creare_categoria(self):
        categoria = Categoria.objects.create(titolo="titolo")
        self.assertTrue(categoria)

    def test_posso_stampare_categoria(self):
        categoria = Categoria.objects.create(titolo="titolo")
        self.assertEqual(str(categoria), "titolo")

    def test_categoria_mantiene_la_data_di_creazione(self):
        categoria = Categoria.objects.create(titolo="titolo")
        self.assertTrue(categoria.creato)
        data_creazione = categoria.creato
        categoria.save()
        self.assertEqual(categoria.creato, data_creazione)

    def test_categoria_aggiorna_la_data_di_aggiornamento(self):
        categoria = Categoria.objects.create(titolo="titolo")
        self.assertTrue(categoria.aggiornato)
        data_aggiornamento = categoria.aggiornato
        categoria.save()
        self.assertGreater(categoria.aggiornato, data_aggiornamento)
```

Il sistema di testing di Django estende quello della libreria standard di Python chiamato
[unittest](https://docs.python.org/3/library/unittest.html). Il runner dei test di Django esegue i test
presenti nella directory `tests` della nostra applicazione presenti in file il cui nome inizia per
`test`.

I test vengono raggruppati in classi che ereditano da `TestCase`, i singoli test sono implementati 
come metodi di questa classe ed il loro nome deve cominciare con `test_`. Ogni test viene eseguito
in una transazione del database che poi viene annullata, quindi le query fatte durante ogni test non
inficiano gli altri. I test usano un database diverso rispetto a quello usato dal progetto, per default
viene usato come nome quello configurato in `settings.py` prefissato da *test_*.

Facciamo girare i test con il comando:

```shell
python3 manage.py test
```

Quindi salviamo i nostri progressi:

```shell
git add corsi/tests
git commit -m "Aggiungiamo test per il modello Categoria"
git push origin main
```

## Esercizi

Scrivi dei test analoghi per il modello `Corso`, salvali su git e pubblicali su GitHub.

Leggi [l'overview sui test](https://docs.djangoproject.com/en/3.2/topics/testing/overview/) di Django.

Scopri nella documentazione come puoi far [eseguire un singolo test](https://docs.djangoproject.com/en/3.2/topics/testing/overview/#running-tests).

Consulta la [lista degli assert](https://docs.python.org/3/library/unittest.html#assert-methods) del
modulo `unittest` di Python.
