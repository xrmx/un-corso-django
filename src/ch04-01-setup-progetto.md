# Setup del progetto

Ogni volta che creiamo un nuovo progetto dobbiamo partire da zero.

Quindi spostiamoci in una directory vuota, ricreiamo l'ambiente virtuale di Python ed installiamo
Django e wheel:

```shell
python3 -m venv venv
source ./venv/bin/activate
pip install Django wheel
```

Ora creiamo un nuovo progetto che chiameremo catalogo:

```shell
django-admin startproject catalogo
```

Ora nella nostra directory dovremmo avere due directory: `venv` e `catalogo`.

Come abbiamo detto vogliamo usare `git` come sistema di versionamento del codice e quindi posizionamoci
nella directory del progetto Django `catalogo` ed inizializziamo il repository:

```shell
cd catalogo
git init
```

Ottimo, abbiamo inizializzato il nostro repository! Prima di effettuare il nostro primo commit
creiamo un file `README.md`, l'estensione *.md* sta per Markdown il formato di markup che usa GitHub,
con il seguente contenuto:

```markdown
# catalogo

Un progetto Django di studio per gestire dei corsi
```

Quindi scarichiamo un file [gitignore](https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore) per evitare di inserire in `git` i file che invece vogliamo ignorare e salviamolo nella nostra
directory come `.gitignore`.

Ora la nostra directory corrente dovrebbe contenere i seguenti file e directory:

```shell
catalogo
manage.py
README.md
.git
.gitignore
```

Se non hai mai usato `git` devi configurare il nome e l'email con cui farai i commit:

```shell
git config --global user.name "Mio Nome"
git config --global user.email mia@email.it
```

Ora facciamo un commit con tutti i nostri file:

```shell
git add .
git commit -m "Primo commit"
```

Infine configuriamo *main* come *branch* di default di `git`:

```shell
git branch -m main
```

> Non serve che usi `git` da linea di comando, puoi usare il tuo IDE

## Esercizi

Se non ti senti sicuro con `git` puoi leggere questa
[introduzione](https://guides.github.com/introduction/git-handbook/).
