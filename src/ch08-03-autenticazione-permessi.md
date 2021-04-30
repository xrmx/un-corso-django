# Autenticazione e permessi

Come abbiamo visto esiste già in Django una applicazione per gestire gli utenti chiamata
`auth` in `django.contrib`.

Ogni istanza di utente ha tre flag:
- `is_active`, che serve per definire se un utente è attivo o meno. Quando non è flaggato l'utente non
  viene autenticato e quindi non può completare il login.
- `is_staff`, serve per abilitare o meno ad un utente l'accesso al sito di admin.
- `is_superuser`, abilita qualsiasi permesso senza assegnarli esplicitamente, un flag da usare con
  parsimonia.

Oltre agli utenti l'applicazione ci mette a disposizione altri due modelli interessati: `Group` per
gestire gruppi di utenti e `Permission` per implementare un sistema di permessi.

I gruppi permetto di raggruppare gli utenti e ad ogni gruppo possono essere associati dei
permessi. Associare i permessi ai gruppi e non direttamente ai singoli utenti permette di mantenere un
progetto più ordinato.

I permessi sono legati ad una specifica azione da compiere su uno specifico modello, per ogni modello
abbiamo 4 permessi: permesso di inserire una nuova istanza, permesso di cambiare una istanza, permesso
di cancellare una istanza e permesso di visualizzare una istanza.

Prendiamo confidenza questi concetti tramite [l'admin](http://127.0.0.1:8000/admin/auth/), prova a 
creare un utente staff ma non superuser e vedi come reagisce l'admin a seconda dei permessi che
vengono assegnati.

Nel caso siano necessari dei permessi custom è possibile crearli tramite l'attributo `Meta` di un
modello come descritto nella
[documentazione](https://docs.djangoproject.com/en/3.2/topics/auth/customizing/#custom-permissions).

I permessi possono essere validati dalla nostra applicazione tramite il metodo `has_perm` del modello
utente. Ad esempio usando il modello `Corso` della nostra applicazione `corsi` dovremmo usare:

- `user.has_perm('corsi.add_corso')`, per controllare che un utente possa creare un `Corso`
- `user.has_perm('corsi.change_corso')`, per controllare che un utente possa modificare un `Corso`
- `user.has_perm('corsi.delete_corso')`, per controllare che un utente possa eliminare un `Corso`
- `user.has_perm('corsi.view_corso')`, per controllare che un utente possa visualizzare un `Corso`

## Controlli nelle viste

Per le nostre viste fatte a classi esistono un paio di mixin che possiamo usare per limitare
comodamento l'accesso ad una vista solo agli utenti che rispettano alcuni requisiti.

Possiamo limitare una vista agli utenti  che passano un controllo specifico usando `UserPassesTestMixin`
ed implementando il metodo `test_func`.

Ad esempio possiamo limitare una vista solo agli utenti che sono attivi e che sono staff:

```python
from django.contrib.auth.mixins import UserPassesTestMixin


class CorsoCreateView(UserPassesTestMixin, CreateView):
    model = Corso
    form_class = CorsoForm

    def test_func(self):
        utente = self.request.user
        return utente.is_active and utente.is_staff
```

> Nel caso l'utente non sia loggato self.request.user è una istanza di `AnonymousUser` che offre la
> stessa interfaccia di un utente loggato

Allo stesso possiamo usare il mixin `PermissionRequiredMixin` per limitare l'accesso ad una vista solo
agli utenti che hanno dei permessi attivi specificando l'attributo `permission_required`:

```python
from django.contrib.auth.mixins import PermissionRequiredMixin


class CorsoCreateView(PermissionRequiredMixin, CreateView):
    model = Corso
    form_class = CorsoForm
    permission_required = ('corsi.add_corso',)
```

### Usare un altro modello utente

`auth` permette una buona dose di personalizzazione permettendo anche di sostituire
il modello usato per l'utente. Può essere una buona idea usare un modello specifico quando si fanno
progetti nuovi e si hanno esigenze particolari, ad esempio richieste di performance estreme, per cui
non vogliamo pagare il costo di una *join SQL* per recuperare dati accessori per l'utente.
In questi casi esiste una
[ricca documentazione ufficiale](https://docs.djangoproject.com/en/3.2/topics/auth/customizing/) da
consultare.

## Esercizi

Leggi la documentazione ufficiale del sistema di
[autenticazione](https://docs.djangoproject.com/en/3.2/ref/contrib/auth/default).

Leggi la documentazione di [UserPassesTestMixin](https://docs.djangoproject.com/en/3.2/topics/auth/default/#django.contrib.auth.mixins.UserPassesTestMixin).

Leggi la documentazione di [PermissionRequiredMixin](https://docs.djangoproject.com/en/3.2/topics/auth/default/#the-permissionrequiredmixin-mixin).
