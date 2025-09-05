# Relazione Progetto: CartExpress

Sviluppato da: Luca Vignali, Cappella Filippo

## Descrizione

CartExpress è un’applicazione mobile progettata per semplificare l’acquisto di prodotti online da negozi di piccole e medie dimensioni.

L’app consente agli utenti di esplorare i prodotti organizzati per categoria, aggiungerli al carrello e completare l’ordine in pochi passaggi.

Il processo di pagamento avviene tramite integrazione con servizi sicuri esterni, e al termine dell’acquisto l’utente riceve una conferma via email con il riepilogo dell’ordine.

L’applicazione è sviluppata in **Flutter** per garantire un’esperienza fluida e uniforme su dispositivi **Android**, supportata da API dedicate per la gestione dei dati e delle operazioni.

## Struttura Progetto

### API Mail

Abbiamo sviluppato un server JS dove utilizza le librerie Express e NodeMailer principalmente.

Una volta ricevuti i dati dal servizio Android l’API costruisce e invia la mail, il server rimane attivo in localhost sulla porta 5000, per eseguire il server basterà scaricare il file zip, installare le librerie tramite il comando `npm install` e lanciare il comando `node server.js` per attivare il servizio.

Momentaneamente non avendo un indirizzo IP fisso utilizziamo il localhost della macchina che emula il progetto, per collegarsi dobbiamo trovare l’ indirizzo IP del nostro localhost, `ipconfig` ci permette di visualizzarlo, dopodiché basterà modificare in **PaymentService** la variabile **backednUrl** con l’ IP del nostro localhost.

### Services

- Payment_service: Servizio per la gestione del pagamento del carrello, invoca un’API su server locale per la gestione dell’invio mail.
- Product_service: Servizio per la raccolta dei prodotti e categorie da un API pubblico, caricando i dati tramite un file JSON
- User_service: Servizio per la gestione degli utenti, carica gli utenti da un file locale `users.json` , creando gli oggetti Utente che saranno poi utilizzati per il login e invio Mail
- ZenQuotesService: Servizio API pubblico per visualizzare nella home una frase motivazionale per l’Utente, tramite un bottone l’utente può richiedere una nuova citazione

### ViewModels

- Cart: Logica per la gestione del carrello:
    - loadCart, lettura da `SharedPreferences` del carrello attuale
    - saveCart, salvataggio cartello in `SharedPreferences`
    - addToCart, aggiunta prodotto in oggetto e poi lancia saveCart
    - removeFromCart, eliminazione singolo prodotto da carrello
    - clearCart, eliminazione totale prodotti carrello
    - processPayment, gestione del processo di pagamento e invio mail
- Login: Logica per la gestione dell’utente
    - loadUsers, lettura da file JSON delle credenziali utenti
    - login, gestione del login e controllo credenziali inserite
    - logout, uscita utente
- Product: Logica per la gestione dei prodotti e categorie
    - fetchProducts/fetchCategories, raccolta da API di categorie e prodotti
    - productsByCategory, assegnazione prodotti alle categorie
    - addToCart, aggiunta prodotto con quantità al carrello
    - removeFromCart, rimozione prodotto dal carrello
    - addReviewToProduct, gestione recensioni per prodotto

### Schermate

**Login**, pagina inziale dove l’utente dovrà inserire le credenziali di accesso per procedere al servizio

**Home**, home del servizio, l’utente può accedere alla lista delle categorie, accedere al carrello, interagire con la citazione e uscire dal servizio

**Categorie**, visione della lista delle categorie dei prodotti

**Prodotti**, visione dei prodotti filtrata per categoria, qui l’utente potrà visionari i vari prodotti scorrendo la lista, cliccando un prodotto l’utente può vedere la descrizione e recensioni (potrà anche lasciare una recensione), l’utente poi può selezionare la quantità del prodotto necessario per il prodotto e aggiungerlo al carrello

**Carrello**, Visione del carrello con tutti gli articoli che sono stati aggiunti, è possibile eliminare i prodotti dal carrello singolarmente, procedendo al pagamento ci sarà un caricamento e l’inoltro della mail di conferma dell’ordine tramite mail, successivamente il carrello sarà liberato

## Funzionalità

- Sistema di gestione Utente (Login, Logout)
- Aggiunta prodotti nel carrello, in quantità singole o multiple
- Visione del dettaglio dei prodotti
- Possibilità di visionare e lasciare recensioni
- Gestione del carrello
- Invio mail verso utente per conferma e visione dell’ordine

## Funzionalità Future

- Aggiunta di un Database per la gestione centralizzata dei dati utilizzati in app
- Gestione del profilo utente, con possibilità di modifica dati
- Registrazione di nuovi utenti
- Ricerca prodotti nel sito, tramite ricerca standard e utilizzo di filtri avanzati
- Funzione di wishlist per salvare prodotti preferiti
- Possibilità di creare ordini regalo
- Funzione di pagamento con carta di credito o altri servizi(PayPal, Satispay, etc)

## Conclusione

CartExpress ha un’interfaccia intuitiva e un sistema di gestione centralizzato, il proprietario del negozio può aggiornare facilmente i prodotti e le informazioni disponibili, senza necessità di competenze tecniche avanzate.

CartExpress al momento presenta funzioni minimali, ma mantiene uno sguardo al futuro, pronto ad accogliere nuove funzionalità, come la ricerca avanzata, la registrazione di nuovi utenti e l’invio di regali che lo renderanno ancora più completo.

CartExpress offre un’esperienza nuova e innovativa rispetto ai servizi sul mercato, grazie alla sua grafica User Friendly, facilità di comprensione del servizio e alte prestazioni.
