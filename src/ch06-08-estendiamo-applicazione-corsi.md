# Estendiamo l'applicazione corsi

Un ultimo tocco per concludere la nostra applicazione `corsi` sarà quello di aggiungere un
sistema di commenti (semplificato!) per permettere agli utenti autenticati di commentare uno specifico
corso.

Il sistema di commenti deve proporre un form nella pagina di dettaglio di un corso per poter inserire
un commento. Di ogni commento vogliamo tracciarne l'autore e vogliamo visualizzare i commenti ordinati
in modo decrescente per data di inserimento. I commenti non devono poter essere cancellati, ma possono
essere aggiornati dal loro autore.

Questo sistema può essere implementato usando le competenze acquisite fino ad ora, si raccomanda la
lettura di [questo capitolo](https://docs.djangoproject.com/en/3.2/topics/class-based-views/generic-editing/#models-and-request-user) per creare una esperienza utente migliore e di [questo](https://docs.djangoproject.com/en/3.2/topics/class-based-views/generic-display/#adding-extra-context) per scoprire come
aggiungere altre variabili nel contesto della vista di dettaglio.

Una volta implementata la funzionalità vanno ovviamente aggiunti i test e salvati i progressi in git.
