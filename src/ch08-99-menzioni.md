# Menzioni

In questa sezione tratteremo brevemente degli argomenti che possono risultare utili e che eventualmente
saranno promossi in una sezione separata.

## Funzioni di aggregazione

Django permette di annotare ed aggregare valori nei QuerySet usando delle
[espressioni](https://docs.djangoproject.com/en/3.2/ref/models/expressions/) tramite i metodi
[annotate](https://docs.djangoproject.com/en/3.2/ref/models/querysets/#annotate) ed
[aggregate](https://docs.djangoproject.com/en/3.2/ref/models/querysets/#django.db.models.query.QuerySet.aggregate). Si consiglia la lettura della documentazione ufficiale sulle
[aggregazioni](https://docs.djangoproject.com/en/3.2/topics/db/aggregation/).
Questi strumenti permettono di demandare più lavoro al database sfruttandone le funzioni più avanzate.

## Query N+1

L'ORM di Django si presta al creare il problema delle query N+1, dove quando si itera sopra ad un
QuerySet vengono fatte altre query per ogni occorrenza.
Per sopperire a questo si possono usare rispettivamente
[select_related](https://docs.djangoproject.com/en/3.2/ref/models/querysets/#select-related)
per i campi `ForeignKey` o `OneToOneField` e
[prefetch_related](https://docs.djangoproject.com/en/3.2/ref/models/querysets/#prefetch-related) per i
`ManyToManyField`.

## Modelli astratti

Ci sono dei casi in cui potrebbe far comodo ereditare classi che estendono `models.Model` per riusarne
i campi definiti. Django permette questo pattern impostando nella classe *Meta* l'attributo
[abstract](https://docs.djangoproject.com/en/3.2/topics/db/models/#abstract-base-classes).

## Indici e vincoli

Django permette di aggiungere facilmente degli indici ai nostri campi tramite l'attributo
[db_index](https://docs.djangoproject.com/en/3.2/ref/models/fields/#db-index). Per avere più controllo
sugli indici è possibile configurarli tramite [indexes](https://docs.djangoproject.com/en/3.2/ref/models/options/#indexes) nella classe *Meta*.
Sempre nella classe *Meta* si possono configurare dei vincoli sui campi tramite
[constraints](https://docs.djangoproject.com/en/3.2/ref/models/options/#django.db.models.Options.constraints
).

## Viste per gestire gli errori

Django offre per default delle viste che gestiscono i maggiori casi di errore ossia 403, 404 e 500.
Le viste per gli errori 403 e 404 possono essere richiamate rispettivamente tramite le eccezioni
`PermissionDenied` e `Http404`, mentre la vista per gli errori 500 viene richiamata automaticamente
in caso di errori a runtime non gestiti. Si rimanda alla documentazione delle
[viste di errore](https://docs.djangoproject.com/en/3.2/ref/views/#error-views) e alla loro
[customizzazione](https://docs.djangoproject.com/en/3.2/topics/http/views/#customizing-error-views).

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
