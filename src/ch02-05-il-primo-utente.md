# Il primo utente

Come abbiamo visto nel capitolo precedente Django di default comprende una applicazione per gestire
gli utenti. Possiamo rendercene conto guardando la lista delle migrazioni e scorgendo quelle di
`auth`.

Django include una gestione degli utenti basilare, non include infatti già il supporto alla registrazione. Per cominciare quindi dobbiamo creare un superutente manualmente tramite il comando `createsuperuser`:

```shell
python3 manage.py createsuperuser
```

Inseriamo i dati richiesti, l'email non è obbligatoria:

```
Username (leave blank to use 'rm'): 
Email address: 
Password: 
Password (again): 
Superuser created successfully. 
```

Non possiamo inserire qualsiasi password, ci sono dei requisiti minimi di sicurezza, potreste aver visto
o meno qualcuno dei seguenti errori:

```shell
This password is too short. It must contain at least 8 characters.
This password is too common.
This password is entirely numeric.
```
