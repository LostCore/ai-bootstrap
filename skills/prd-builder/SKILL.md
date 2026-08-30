---
name: prd-builder
description: Crea e raffina un Product Requirements Document (PRD) ancorato al codice reale del progetto, separando ciò che è già deciso da ciò che l'utente deve ancora decidere. Usala quando l'utente chiede un PRD, un documento di prodotto, una specifica di prodotto, di "mettere per iscritto cosa vogliamo costruire", quando chiede di rileggere, completare o migliorare un PRD esistente, o quando una decisione di prodotto va formalizzata prima di implementarla. Non usala per specifiche tecniche, design doc o ADR.
---

# Scrivere e raffinare un PRD ancorato al codice

Un PRD risponde a quattro domande e a nessun'altra: quale problema, per quale utente, cosa deve essere vero perché sia considerato fatto, cosa resta esplicitamente fuori.
Non contiene schemi di tabelle, endpoint o nomi di componenti: il design tecnico vive accanto al codice e il PRD lo linka.

Il valore non sta nella struttura, che è banale, ma in tre cose: **indagare prima di scrivere**, **non spacciare per deciso ciò che l'utente non ha deciso**, e **chiudere** invece di raffinare all'infinito.

Due modalità, decise da cosa esiste già:

- **Creare** un PRD nuovo: passi 1-4 qui sotto.
- **Raffinare** un PRD esistente: vedi "Modalità raffinamento".

## Serve davvero un PRD?

Da valutare prima di scrivere, e da rispondere all'utente se è lui a chiederlo.
Scrivere un PRD per qualcosa che non ne ha bisogno costa più della sua utilità, perché produce un documento che nessuno rileggerà.

**Serve se almeno una è vera:**

1. **Il costo dell'errore è alto**: il lavoro crea schema di database, contratti pubblici, prezzi, o dati su cui qualcuno comincerà a dipendere. Tornare indietro costerebbe una migrazione o una comunicazione agli utenti.
2. **Esiste una vera domanda di prodotto aperta**: due persone ragionevoli sceglierebbero diversamente, e il codice non contiene la risposta. Non confonderla con "come si implementa", che non è mai un PRD.
3. **Attraversa più repo o più applicazioni**: la decisione deve valere per tutte e nessun singolo codebase può ospitarla.
4. **Si sta decidendo di non fare qualcosa**: un confine senza motivazione scritta verrà riproposto in buona fede entro pochi mesi.

**Non serve se:**

- È un bug fix, un refactor o un aggiustamento di UI.
- La risposta è già determinata da un documento o da un pattern esistente: allora è lavoro, non una decisione.
- È reversibile in poche ore, senza migrazioni e senza che nessun utente se ne accorga.
- L'utente sa già la risposta e non l'ha ancora scritta: basta una riga nella documentazione descrittiva.

In una riga: se la domanda è *cosa deve fare e per chi*, è un PRD; se è *come lo costruiamo*, è documentazione tecnica accanto al codice; se è *perché non lo facciamo*, è un confine nella documentazione descrittiva della funzionalità.

## Passo 1: indagine, prima di scrivere una riga

Non partire dal template. Parti da cosa esiste già.

- **Cerca la documentazione esistente** (`docs/`, `doc/`, `documentation/`, i README) e capisci come è organizzata prima di aggiungere qualcosa.
- **Cerca le decisioni non prese**, che sono il vero punto di partenza di un PRD: `grep -rn "da decidere\|TBD\|TODO\|aperto\|non ancora\|open question\|to be decided"` sulla documentazione e sul codice.
  Un PRD nasce quasi sempre da righe che qualcuno ha già scritto e poi rimandato.
- **Cerca lo scaffold morto**: pagine placeholder, rotte singole, moduli con le dipendenze installate ma nessun uso reale.
  Dicono con precisione dove il lavoro si è fermato e perché.
- **Chiedi all'utente il contesto che il codice non può contenere**: chi è l'utente, che problema ha, cosa è già stato deciso a voce.

Se il progetto ha già una convenzione per questi documenti, **seguila** invece di imporre la tua: numerazione, lingua, stile dei link, posizione.
Proponi una struttura di default solo se non esiste nulla.

## Passo 2: verifica ogni affermazione sullo stato attuale

Ogni frase del PRD che descrive com'è il sistema oggi deve venire da un file che hai aperto, e va citata con il percorso.
Vale anche per le cose ovvie: "il pagamento è già integrato" letto in un README può essere vero da diciotto mesi e falso da diciassette.

Se non hai potuto verificare qualcosa, scrivilo come non verificato invece di ometterlo.

### Se il codice non esiste ancora

Su un prodotto nuovo non c'è niente da verificare, e una skill che ci prova finisce per inventare.
In quel caso la fonte delle "Decisioni già prese" è **il file di concept dell'utente**, che è il posto dove le sue scelte già stanno, citato riga per riga come citeresti un file di codice.
Tutto ciò che non è nel concept è una proposta, e va dichiarato come tale.
È una sostituzione della fonte, non un allentamento della regola: continua a valere che senza una fonte citabile non è una decisione presa.

## Passo 3: scrivere, tenendo separati fatti e proposte

È la regola più importante della skill.

- **Decisioni già prese**: solo ciò che è nel codice o scritto in un documento, ciascuna con il riferimento.
  Se non riesci a citare la fonte, non è una decisione presa.
- **Questioni aperte**: tutto il resto, marcato come aperto, **ciascuna con una proposta esplicita** da confermare o respingere.
  Una proposta motivata è utile; la stessa proposta scritta nei requisiti come se fosse stata decisa è un danno, perché l'utente deve prima accorgersene e poi smontarla.
- Sui numeri che dipendono dal mercato o dalla strategia (prezzi, soglie, obiettivi commerciali) **non proporre**: lascia la domanda aperta e dichiara che serve una decisione dell'utente.
  Inventare un prezzo plausibile è il modo più rapido di rendere inaffidabile tutto il documento.
- Non duplicare la documentazione descrittiva esistente: linkala.
  Un PRD che ricopia com'è fatta una funzionalità diventa una seconda copia che divergerà.
- **Cita i documenti come percorsi, mai con una sintassi che il tuo strumento interpreta come inclusione automatica di file.**
  In Claude Code è il prefisso `@`: un `@percorso.md` carica quel file nel contesto di chi legge.
  Nella documentazione descrittiva può avere senso, perché chi la apre sta per lavorare su quel codice.
  In un PRD no: cita molti documenti proprio perché serve a decidere, e caricarli tutti consuma contesto senza aggiungere nulla alla decisione.
  Scrivi il percorso tra backtick, con la sottosezione dopo `>` quando serve.

### Come si scrive un requisito

Tre parti, perché ognuna serve a qualcosa di diverso: **chi** ne beneficia, **cosa** vuole, **così da** quale beneficio.

> Come *ruolo*, voglio *azione*, così da *beneficio*.

Il "così da" non è cortesia narrativa, è la parte che cambia cosa si costruisce.
"Vedere la scheda così da consultarla" e "vedere la scheda così da eseguirla con il telefono in mano" producono due schermate diverse: la seconda si legge a mezzo metro, con le mani occupate.

Due segnali da riconoscere mentre scrivi:

- **Il beneficio è tautologico** ("voglio vedere le schede, così da vedere le schede"): il requisito è già scritto al livello dell'implementazione, va risalito di un gradino.
- **Il beneficio non si riesce a scrivere** senza girare in tondo: quasi sempre quel requisito è arrivato lì per simmetria con un altro, e va tolto o motivato. Segnalalo all'utente invece di riempirlo di parole.

Fai attenzione al **ruolo**: a volte chi beneficia non è l'utente della schermata.
Un requisito di sola lettura nell'app di A esiste per il beneficio di B, e accorgersene spiega perché quel vincolo c'è.

Sotto ogni requisito vanno i **criteri di accettazione**: due o quattro righe che dicono quando è soddisfatto, osservabili da fuori.
Sono la risposta a "come faccio a sapere che è fatta", e in un progetto con test end to end diventano quasi parola per parola i suoi scenari.
Non sono il posto per il dettaglio tecnico: dicono cosa deve essere vero, non come ottenerlo.

Non applicare questa forma a tutto per obbligo.
Un requisito la cui utilità è ovvia in una riga resta una riga: la cerimonia completa su quindici voci rende il documento più lungo e meno letto.

Struttura di default, se il progetto non ne ha una:

```markdown
# PRD NNNN - Titolo

**Stato:** bozza | approvato | rilasciato | abbandonato
**Aperto il:** AAAA-MM-GG
**Ambito:** quali repo/moduli tocca

## Di cosa parla, e di cosa non parla   ← solo se esiste un rischio di ambiguità
## Problema
## Utente e scenario
## Obiettivo e criteri di successo
## Requisiti                            ← ruolo, azione, così da; criteri di accettazione sotto
## Fuori scope
## Decisioni già prese                  ← con riferimenti verificati
## Questioni aperte                     ← con una proposta ciascuna
## Rinviato, non dimenticato            ← solo se qualcosa è stato consapevolmente parcheggiato
## Vincoli e dipendenze                 ← cosa blocca cosa
## Riferimenti
```

Un file per PRD, numerato progressivamente e mai riusato.
Il PRD resta in **bozza** finché le questioni aperte non hanno risposta: non promuoverlo tu.
Una volta rilasciata la funzionalità il documento si congela e non si aggiorna più, perché la descrizione viva sta nella documentazione descrittiva.

## Passo 4: rileggere da freddo, prima di consegnare

Tre controlli, tutti su un difetto che si vede solo da fuori:

- **Il titolo e la prima sezione sono comprensibili a chi non ha seguito la conversazione?**
  Se nel progetto esistono due cose con nomi simili (due sistemi di pagamento, due tipi di utente, due nozioni di "account"), il documento deve dire in apertura di quale parla, e possibilmente evitare la parola ambigua nel titolo.
- **Ogni requisito è verificabile?** "L'esperienza è fluida" non lo è, "l'utente completa l'operazione senza intervento manuale nostro" sì.
  Il criterio pratico: se non riesci a scrivere i criteri di accettazione di un requisito, non è verificabile, ed è inutile lasciarlo com'è.
- **Le questioni aperte sono davvero tutte le domande che restano?**
  Alla consegna, elenca all'utente quali decisioni servono da lui, indicando quale blocca cosa.

## Modalità raffinamento

Si applica a un PRD che esiste già, per portarlo da bozza ad approvabile.
L'obiettivo **non** è la completezza assoluta: un PRD che chiede tutto non viene letto e non chiude mai.
L'obiettivo è togliere una alla volta le domande che bloccano l'implementazione.

Una passata funziona così.

**1. Rileggi il documento e il codice, non solo il documento.**
Nel frattempo qualcosa può essere stato costruito: una questione aperta può già avere una risposta nel codice, e in quel caso non va chiesta all'utente ma spostata nelle decisioni con il riferimento.

**2. Chiedi al massimo tre o quattro domande per volta.**
Ordinale mettendo per prime quelle che ne sbloccano altre, e dì esplicitamente quale blocca cosa.
Quando le opzioni sono discrete, presentale come scelte con una raccomandazione, non come una domanda aperta.
Una raffica di dieci domande produce dieci risposte affrettate.

**3. Dopo ogni risposta, aggiorna il documento subito.**
La voce si sposta da "Questioni aperte" a "Decisioni già prese" **portandosi dietro la motivazione che ha dato l'utente**, con le sue parole se sono già buone.
La scelta si ricostruisce sempre, il perché no: è la prima cosa che si perde e quella che serve di più dopo mesi.
Se l'utente sceglie contro la tua proposta, registra la sua scelta e cancella la tua, senza lasciare traccia argomentativa a favore dell'opzione scartata.

**4. Genera le domande derivate.**
Ogni decisione ne apre di nuove, e sono le più facili da dimenticare perché non erano nell'elenco iniziale.
Deciso che l'accesso scaduto diventa sola lettura, restano da decidere dopo quanti giorni scatta, se ci sia una fascia di solo avviso, e cosa vedono nel frattempo gli altri utenti coinvolti.

**5. Passa la checklist di completezza.**
- Ogni requisito ha un beneficio dichiarato e criteri di accettazione osservabili da fuori.
- I casi limite sono coperti: fallimento, stato vuoto, annullamento, e **cosa succede agli utenti e ai dati già esistenti** al momento del rilascio.
- Le dipendenze dicono cosa blocca cosa, non solo cosa serve.
- Il documento non contraddice la documentazione descrittiva esistente. Se la contraddice, è un problema da segnalare all'utente, non da appianare in silenzio.

**6. Chiudi, o dichiara perché non puoi.**
Separa le domande **bloccanti** (senza risposta non si può implementare) da quelle **rinviabili** (si può partire e decidere dopo, senza rifare il lavoro).
Le rinviabili vanno in "Rinviato, non dimenticato" con il motivo del rinvio, non restano a fare massa tra le aperte.
Quando restano solo rinviabili, **dillo**: proponi il passaggio ad approvato invece di continuare a raffinare.

## Anti-pattern

- Riempire il template con requisiti verosimili senza aver letto il codice.
- Presentare come deciso ciò che hai proposto tu.
- Infilare nel PRD lo schema del database o l'API: quel materiale invecchia in fretta e appartiene alla documentazione tecnica.
- Scrivere un PRD per qualcosa che è già stato costruito.
  Quel materiale è un confine di prodotto e va nella documentazione descrittiva della funzionalità, accanto a ciò che descrive.
- Raffinare senza mai chiudere, aggiungendo domande a ogni passata.
  Se il numero di questioni aperte non cala di passata in passata, stai scrivendo un secondo documento invece di finire il primo.
