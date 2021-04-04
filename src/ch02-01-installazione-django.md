# Installazione

Per prima cosa creiamo una directory per contenere il nostro progetto:

```shell
mkdir corso-django-installazione
cd corso-django-installazione
```

Una volta entrati nella nostra directory possiamo creare un ambiente virtuale dove installeremo
Django:

```shell
python3 -m venv venv
```

Abbiamo chiamato il nostro ambiente `venv` come convenzione, ma ovviamente possiamo usare un nome
diverso.

Una volta creato il nostro ambiente, lo attiviamo e procediamo con l'installazione:

```shell
source ./venv/bin/activate
pip install Django wheel
```

> source è una funzionalità della shell per importare un file, viene usato per settare delle variabili
> d'ambiente.
> In Windows con PowerShell per attivare l'ambiente bisogna eseguire il file venv\Scripts\Activate.ps1
> Per dettagli consultare la documentazione del
> [modulo venv](https://docs.python.org/3/library/venv.html).

Con questo comando abbiamo installato l'ultima versione disponibile di Django, al momento della
scrittura 3.1.7. Abbiamo anche installato wheel per aggiungere il supporto all'uso dei pacchetti
binari pre-compilati.

> Django rilascia una nuova versione ogni 8 mesi, ogni versione viene mantenuta per circa un anno.
> Alcune versioni sono designate come `long-term support (LTS)` e mantenute per circa 3 anni.
> Quale versione usare dipende dal tipo di progetto.

Molto bene, abbiamo installato Django!
