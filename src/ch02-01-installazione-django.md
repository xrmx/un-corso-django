# Installazione

Per prima cosa creiamo una directory per contenere il nostro progetto:

```shell
mkdir corso-django-installazione
cd corso-django-installazione
```

Una volta entrati nella nostra directory possiamo creare un ambiente virtuale dove installeremo
Django. Gli ambienti virtuali servono a creare degli ambienti isolati per evitare di creare conflitti
con il sistema o con altre applicazioni.

Creiamo l'ambiente virtuale con il comando:

```shell
python3 -m venv venv
```

Abbiamo chiamato il nostro ambiente `venv` come convenzione, ma ovviamente possiamo usare un nome
diverso.

Una volta creato il nostro ambiente, lo attiviamo:

```shell
source ./venv/bin/activate
```

> In Windows con PowerShell per attivare l'ambiente bisogna eseguire il file venv\Scripts\Activate.ps1
> Per dettagli consultare la documentazione del
> [modulo venv](https://docs.python.org/3/library/venv.html).

`source` è una funzionalità della shell per importare un file e viene usato per settare delle variabili
d'ambiente. Queste variabili di ambiente istruiscono Python di usare la directory `venv` come
sua directory di lavoro.

D'ora in poi tutti i comandi assumono che l'ambiente virtuale sia attivato.

Gli ambienti virtuali possono essere disattivati con:

```shell
deactivate
```

Quindi, con l'ambiente virtuale attivo, procediamo con l'installazione:

```shell
pip install Django wheel
```

Con questo comando abbiamo installato l'ultima versione disponibile di Django, al momento della
scrittura 3.2. Abbiamo anche installato *wheel*, una pacchetto Python che aggiunge il supporto
all'installazione di pacchetti con binari pre-compilati.

> Django rilascia una nuova versione ogni 8 mesi, ogni versione viene mantenuta per circa un anno.
> Alcune versioni sono designate come `long-term support (LTS)` e mantenute per circa 3 anni.
> Quale versione usare dipende dal tipo di progetto. Django 3.2 è una versione LTS.

Molto bene, abbiamo installato Django!
