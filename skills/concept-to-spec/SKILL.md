---
name: concept-to-spec
description: Porta un'idea o un file di concept fino alla documentazione da cui si scrive codice, per interrogazione. Tre momenti - intervista (da un'idea nuda alla lista delle funzionalità e ai confini del prodotto), scomposizione (da un concept alle funzionalità, con lo stato di ciascuna), specifica (da una funzionalità ai documenti di dettaglio). Usala quando l'utente dice "ho un'idea", "ho scritto un concept", "aiutami a capire cosa deve fare", "quali funzionalità servono", "trasforma questo in documentazione". Per una singola decisione di prodotto che merita un documento suo, usa invece prd-builder.
---

# Dal concept alla documentazione, per interrogazione

Il compito è portare un'idea fino a documenti da cui si può scrivere codice, facendo le domande giuste nell'ordine giusto.

Tre momenti, da riconoscere dall'input:

- **Intervista**: l'utente ha un'idea o due righe di concept. Non c'è ancora niente da scomporre, la superficie del prodotto va generata chiedendo.
- **Scomposizione**: esiste un concept che descrive qualcosa. Va trasformato in un elenco di funzionalità con lo stato di ciascuna.
- **Specifica**: una funzionalità è stata scelta. Va portata al dettaglio da cui si scrive codice.

Una regola vale in tutti e tre, ed è la ragione per cui questa skill esiste: **non decidere di nascosto**.
Ogni volta che per andare avanti serve una scelta che l'utente non ha mai espresso, fermati e chiedila.
Una specifica che incorpora una decisione mai discussa è il modo più efficiente di costruire la cosa sbagliata con grande precisione.

## Fase 1: intervista

Obiettivo: la **superficie** del prodotto e i suoi confini, non il dettaglio.
Si chiude quando esiste una lista di funzionalità con tre stati (dentro, fuori, da decidere), non quando sai come sono fatte.

Come condurla:

- **Domande a giri di tre o quattro**, mai di più. Una raffica produce risposte affrettate su tutto.
- Procedi per aree, in quest'ordine, perché ognuna rende più facile la successiva:
  1. **Attori**: chi usa il prodotto, e chi altro tocca i dati senza usarlo.
  2. **Il lavoro dell'utente oggi**: come fa adesso, senza il tuo prodotto, la cosa che gli vuoi risolvere.
  3. **Cosa consegna o vende** al proprio cliente finale.
  4. **Cosa deve vedere il cliente finale**, se lo vede.
  5. **Quali dati raccoglie**, e se qualcuno di questi è sensibile o soggetto a obblighi.
  6. **Cosa usa già e non vuole sostituire.**
- L'area 6 è la più preziosa e quasi nessuno la chiede: gli strumenti che l'utente ha già rodato sono il confine naturale del prodotto.
- **"Non lo so ancora" è sempre una risposta valida.** Va nella colonna "da decidere" e non blocca il giro.
- **Dopo ogni giro rimostra la lista aggiornata**, così l'utente vede crescere il prodotto invece di rispondere al buio.
- **Su ogni sì, una sola domanda di approfondimento**, quella che cerca il bivio: esiste un modo alternativo e ragionevole di fare questa cosa, che cambierebbe il modello dati o il posizionamento?
  Se il bivio non c'è, la funzionalità è lavoro: passa oltre e mettila in coda per la specifica.
  Se c'è, segnalo come candidato PRD e **non deciderlo qui**.
- **Chiudi sempre chiedendo cosa resta fuori.** È la domanda che nessuno si fa da solo, e la risposta vale quanto tutto il resto.

Output: **un solo documento**, il PRD del prodotto, non della funzionalità.
Numeralo `0000` se il progetto usa PRD numerati.
Contiene cosa fa il prodotto, per chi, cosa non fa e perché, e la lista delle funzionalità nei tre stati.

**Anti-pattern della fase 1**: trasformare ogni sì in un PRD.
Da un'intervista escono venti funzionalità e due o tre bivi veri.
Venti documenti non li leggerà nessuno, il primo compreso.

## Fase 2: scomposizione

Prima di scomporre, **leggi**: il concept, la documentazione già presente e le sue convenzioni, e il codice per sapere cosa esiste davvero.
Non chiedere all'utente cose che il repo può dirti.

Produci una tabella delle funzionalità con, per ciascuna, uno stato:

- **esiste già**, con il riferimento al file che lo prova;
- **da specificare**, con il pattern o il documento esistente da riusare;
- **decisione aperta**, quando specificarla ora significherebbe incorporare una scelta mai discussa;
- **bloccata da**, quando dipende da qualcosa che non c'è ancora.

Poi **fermati e chiedi da dove partire**.
Non incatenare la scomposizione alla scrittura delle specifiche: sono due momenti, e in mezzo c'è una scelta dell'utente.

## Fase 3: specifica

Una funzionalità alla volta.

**Controllo a monte, sempre**: se la funzionalità dipende da una riga "decisione aperta", dillo prima di scrivere, e offri due strade.
O l'utente risponde a voce, e allora la risposta va registrata come decisione nella documentazione con il suo perché.
Oppure la decisione merita un documento suo, e allora si passa a `prd-builder`.

Le domande di specifica, sempre a gruppi piccoli, lungo questi assi:

- **Entità e campi**: cosa esiste, cosa contiene, cosa è obbligatorio, a cosa è legato.
- **Schermate**: quali sono, cosa mostrano, cosa ci si fa.
- **Elenchi**: colonne, ordinamenti, filtri, ricerca, azioni singole e massive.
- **Stati limite**: vuoto, in caricamento, errore, permesso negato, elemento cancellato mentre lo guardi.
- **Gli altri attori**: cosa vede, e cosa non deve vedere, chi non è l'utente che stai specificando.

**Imita i documenti esistenti** del progetto: struttura, livello di dettaglio, lingua, stile dei riferimenti.
Una specifica scritta in una forma diversa dalle altre costringe a impararla due volte.
Solo se non esiste alcun precedente, proponi tu una struttura e falla approvare.

Alla fine aggiorna anche i documenti trasversali che il progetto tiene allineati: indici, modello dati, elenco delle entità, checklist di stato.

## Regole trasversali

- **Non inventare fatti sul codice.** Ogni affermazione su cosa esiste oggi va verificata aprendo il file, e citata.
- **Non produrre più documenti di quelli che servono adesso.** La documentazione scritta molto prima dell'implementazione arriva vecchia.
- **Non riscrivere il concept dell'utente.** È la fonte, non una bozza da migliorare.
- Se il concept e il codice si contraddicono, **segnalalo** invece di scegliere in silenzio quale dei due ha ragione.

## Quando fermarsi

- Fine fase 1: c'è la lista con i confini. Chiedi da quale funzionalità partire.
- Fine fase 2: c'è la tabella con gli stati. Chiedi da dove partire.
- Fine fase 3: la specifica è scritta. Elenca cosa resta aperto e cosa hai aggiornato.

In tutti e tre i casi il turno finisce con una domanda all'utente, non con l'inizio della fase successiva.
