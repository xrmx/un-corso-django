# Autenticazione con LDAP

Usare [LDAP](https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol) per l'autenticazione
ad un sito interno permette di configurare utenti e permessi in un solo posto.

L'applicazione che possiamo usare per integrare LDAP nel nostro progetto Django si chiama
[django-auth-ldap](https://github.com/django-auth-ldap/django-auth-ldap).
*django-auth-ldap* dipende da *python-ldap* che a sua volta dipende dalle librerie *OpenLDAP* che
dobbiamo installare nel nostro sistema.

In un sistema Debian / Ubuntu possiamo installare tutto quello che ci serve con questo comando:

```shell
sudo apt install build-essential python3-dev libldap2-dev libsasl2-dev
```

Quindi possiamo procedere ad installare i nostri pacchetti:

```shell
pip install python-ldap django-auth-ldap
```

Per usare esclusivamente l'autenticazione ed ereditare completamente i permessi da LDAP dobbiamo
configurare nel nostro settings `AUTHENTICATION_BACKENDS` per usare esclusivamente il backend
di autenticazione fornito *django-auth-ldap*:

```python
AUTHENTICATION_BACKENDS = [
    'django_auth_ldap.backend.LDAPBackend',
]
```

Se invece vogliamo gestire i permessi individualmente usando il supporto di Django dobbiamo
comunque mantenere il backend di autenticazione `ModelBackend`:

```python
AUTHENTICATION_BACKENDS = [
    'django_auth_ldap.backend.LDAPBackend',
    'django.contrib.auth.backends.ModelBackend',
]
```

Per configurare l'integrazione con il server LDAP per prima cosa bisogna specificare l'indirizzo:

```python
AUTH_LDAP_SERVER_URI = "ldap://ldap.example.com"
```

Quindi bisogna autenticarsi settando `AUTH_LDAP_USER_SEARCH` in questo modo diremo a Django di cercare
gli utenti nella *organisational unit* (ou) `users` sotto il *distinguished name* `example.com` cercando
il valore che useremo come username al login:

```python
import ldap
from django_auth_ldap.config import LDAPSearch

AUTH_LDAP_USER_SEARCH = LDAPSearch(
    'ou=users,dc=example,dc=com',
    ldap.SCOPE_SUBTREE,
    '(uid=%(user)s)',
)
```

Discorso analogo vale per i gruppi configurabili tramite `AUTH_LDAP_GROUP_SEARCH`:

```python
AUTH_LDAP_GROUP_SEARCH = LDAPSearch(
    'ou=django,ou=groups,dc=example,dc=com',
    ldap.SCOPE_SUBTREE,
    '(objectClass=groupOfNames)',
)
```

Trovati gli utenti dobbiamo mapparli con i modelli già presenti in Django tramite
`AUTH_LDAP_USER_ATTR_MAP`:

```python
AUTH_LDAP_USER_ATTR_MAP = {
    'first_name': 'givenName',
    'last_name': 'sn',
    'email': 'mail',
}
```

In questo esempio stiamo mappando tramite `AUTH_LDAP_USER_ATTR_MAP` i campi del modello `User`
`first_name`, `last_name` ed `email` rispettivamente sui campi LDAP `givenName`, `sn` e `mail`.

Infine dobbiamo mappare i gruppi con gli attributi dei nostri utenti tramite
`AUTH_LDAP_USER_FLAGS_BY_GROUP`:

```python
AUTH_LDAP_USER_FLAGS_BY_GROUP = {
    'is_active': 'cn=active,ou=django,ou=groups,dc=example,dc=com',
    'is_staff': 'cn=staff,ou=django,ou=groups,dc=example,dc=com',
    'is_superuser': 'cn=superuser,ou=django,ou=groups,dc=example,dc=com',
}
```

Con questa configurazione stiamo mappando l'oggetto con *common name* (cn) `active` sotto
`django.groups` con il flag `is_active`, `staff` con il flag `is_staff` e `superuser` con il flag
`is_superuser`.


Sono disponibili ovviamente ulteriori configurazioni e si rimanda alla documentazione ufficiale di
[django-auth-ldap](https://django-auth-ldap.readthedocs.io/en/latest/).

## Esercizi

Consulta la documentazione sulla [gestione dei permessi](https://docs.djangoproject.com/en/3.2/topics/auth/default/#permissions-and-authorization).
