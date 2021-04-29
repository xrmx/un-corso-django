# Gestione dei docenti

L'applicazione *corsi* permette a qualsiasi utente registrato di essere inserito come docente di un
corso. Vogliamo creare un sistema più raffinato per separare i docenti dal resto degli utenti
registrati.

Creiamo una nuova applicazione chiamata *profili* per gestire un nuovo modello *Profilo* da mettere
in relazione *1-a-1* tramite un campo
[OneToOneField](https://docs.djangoproject.com/en/3.2/ref/models/fields/#django.db.models.OneToOneField)
al modello *User*.

Nel modello *Profilo* vogliamo tracciare:
- il paese di provenienza
- un flag per distinguere i docenti dal resto degli utenti

Per avere una lista dei paesi si può sfruttare il pacchetto
[pycountry](https://pypi.org/project/pycountry/) da usare in combinazione con il parametro
[choices](https://docs.djangoproject.com/en/3.2/ref/models/fields/#choices) di un campo `CharField`.

Ogni utente può accedere tramite delle viste a dei form di inserimento e di modifica del proprio profilo.
Da questi form però è escluso il flag per distinguere i docenti dagli utenti normali. Questo flag
può essere settato solo tramite l'interfaccia di amministrazione.

Una volta che gli utenti possono essere profilati come docenti dobbiamo aggiornare l'applicazione
*corsi* per limitare la scelta dei docenti selezionabili tramite il parametro
[limit_choices_to](https://docs.djangoproject.com/en/3.2/ref/models/fields/#django.db.models.ManyToManyField.limit_choices_to) del campo `ManyToManyField` a solo quelli che hanno il flag attivato.

Ricordati di testare modelli, form e viste e di salvare i tuoi progressi su git.
