# Menzioni

In questa sezione tratteremo brevemente degli argomenti che possono risultare utili e che eventualmente
saranno promossi in una sezione separata.

## Funzioni di aggregazione

Django permette di annotare ogni oggetto di un QuerySet usando delle
[espressioni](https://docs.djangoproject.com/en/3.2/ref/models/expressions/) tramite il metodo
[annotate](https://docs.djangoproject.com/en/3.2/ref/models/querysets/#annotate).

Questo strumento è un ottimo alleato per sfruttare le funzioni più avanzate del database.

## Paginazione

Django comprende un [sistema di paginazione](https://docs.djangoproject.com/en/3.2/topics/pagination/)
già integrato nelle viste a classi.

## Upload di un file

L'upload di file tramite form su Django è ben documentato in un
[articolo apposito](https://docs.djangoproject.com/en/3.2/topics/http/file-uploads/).

## Comandi

Possiamo estendere il nostro progetto con ulteriori comandi rispetto a quelli forniti da Django
implementando delle classi come descrive la documentazione per scrivere i
[propri comandi](https://docs.djangoproject.com/en/3.2/howto/custom-management-commands/).

## Azioni per l'admin

Possiamo inoltre scrivere per interagire con i nostri modelli tramite l'interfaccia di admin delle
[azioni](https://docs.djangoproject.com/en/3.2/ref/contrib/admin/actions/).

Dei casi d'uso per le azioni potrebbe essere aggiornare qualche flag od effetture qualche ricalcolo
su dei modelli specifici usando le feature dell'admin come i filtri e la ricerca per aiutarci.
