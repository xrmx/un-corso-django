# Validazione nei form

L'interfaccia dei form di Django offre diversi metodi per validare i dati inseriti in un form.
Il primo metodo è quello di usare un validatore specifico su un singolo campo. Ipotizziamo di voler
creare un form per implementare una ricerca e di voler validare che la *query* contenga un numero
minimo di caratteri. Il nostro codice potrebbe assomigliare al seguente:

```python
from django import forms
from django.core.exceptions import ValidationError


def almeno_tre_caratteri(value):
    if len(value) < 3:
        raise ValidationError("La query deve essere di almeno 3 caratteri")


class RicercaForm(forms.Form):
    query = forms.CharField(validators=[almeno_tre_caratteri])
```

Abbiamo creato un `Form` con un singolo campo `query` che viene validato dalla funzione
`almeno_tre_caratteri` che in caso il valore non abbiamo sia lungo almeno 3 caratteri alza l'eccezione
`ValidationError` con un messaggio di errore. Come possiamo notare il validatore non è altro che una
semplice funzione che prende il valore del campo come parametro.

Per verificare che il nostro form ed il nostro validatore funzionino a dovere dobbiamo scrivere dei
test come i seguenti:

```python
from corsi.forms import RicercaForm, almeno_tre_caratteri


class RicercaFormTestCase(TestCase):
    def test_validatore_alza_eccezione_con_meno_di_3_caratteri(self):
        with self.assertRaisesMessage(ValidationError, "La query deve essere di almeno 3 caratteri"):
            almeno_tre_caratteri("ab")

    def test_validatore_non_alza_eccezione_con_almeno_3_caratteri(self):
        self.assertIsNone(almeno_tre_caratteri("abc"))

    def test_form_valida_campo_query(self):
        form = RicercaForm({"query": "abc"})
        self.assertTrue(form.is_valid())

    def test_form_restituisce_errore_con_query_minore_di_3_caratteri(self):
        form = RicercaForm({"query": "ab"})
        self.assertFalse(form.is_valid())

    def test_form_restituisce_errore_senza_dati(self):
        form = RicercaForm({})
        self.assertFalse(form.is_valid())
```

In questi stiamo testando che il validatore validi correttamente la stringa passata e in caso di
errore restituisca il messaggio che ci aspettiamo. Validiamo invece che il form applichi il validatore
e cambi il valore restituito dal metodo `is_valid()`.

Django offre altri due metodo per validare un form: il metodo `clean()` del form e i metodi
`clean_<nomecampo>()` per validare ogni singolo campo. A differenza del sistema col validatore questi
metodi permettono di cambiare il contenuto del campo che stanno controllando.

Possiamo reimplementare il form precedente validando il singolo campo in questo modo:

```python
class RicercaForm(forms.Form):
    query = forms.CharField()

    def clean_query(self):
        query = self.cleaned_data["query"]
        if len(query) < 3:
            raise ValidationError("La query deve essere di almeno 3 caratteri")
        return query
```

Possiamo notare che ora dobbiamo sempre restituire qualcosa che verrà salvato nella chiave `query`
di `cleaned_data` al termine della validazione.

A differenza del metodo `clean` per il singolo campo, quello generico del form ha visione su tutti i
campi del form e quindi è possibile validare un campo in relazione agli altri.

```python
class RicercaForm(forms.Form):
    query = forms.CharField()

    def clean(self):
        super().clean()
        query = self.cleaned_data.get("query", "")
        if len(query) < 3:
            raise ValidationError("La query deve essere di almeno 3 caratteri")
```

Qui dobbiamo fare attenzione ad una cosa importante. A differenza dei due metodi precedenti in questo
caso non possiamo dare per scontato che i campi dei form siano valorizzati. Infatti stiamo usando la
stringa vuota `""` come default nel caso che il campo `query` non sia definito. Per il metodo `clean`
non è obbligatorio restituire il valore di `cleaned_data` se non abbiamo cambiato il contenuto da quello
che ha settato la chiamata al metodo `clean()` di default.

## Esercizi

Leggi la documentazione sui [validatori](https://docs.djangoproject.com/en/3.2/ref/validators/) e quale
validatore avremmo potuto usare al posto di implementarne una nostra versione.

Leggi la documentazione ufficiale sulla
[validazione dei form](https://docs.djangoproject.com/en/3.2/ref/forms/validation/).
