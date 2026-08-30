---
name: prd-to-tickets
description: Trasforma un PRD approvato in ticket individuali con le dipendenze fra loro, dimensionati perché una sessione ne chiuda uno avendo caricato solo i documenti che gli servono. Serve anche a vedere cosa si può portare avanti in parallelo e cosa sta sul cammino critico. Usala quando l'utente dice "spezza questo PRD in ticket", "fammi la kanban", "da dove comincio", "cosa posso parallelizzare", "dividi il lavoro".
---

# Dal PRD ai ticket

Un ticket è **un'unità di lavoro che una sessione chiude avendo caricato solo ciò che le serve**.
È questa, e non lo sforzo o i punti, la regola che ne detta la dimensione: se per chiuderne uno servono il PRD, tre specifiche e mezzo modello dati, quel ticket è troppo grande, indipendentemente da quanto sia veloce da scrivere.

## Precondizione: solo da un PRD approvato

Da un PRD in bozza non si generano ticket.
Le questioni aperte diventerebbero scelte prese di nascosto da chi implementa, che è esattamente ciò che il PRD serviva a evitare.

Se il PRD è in bozza, **fermati e dillo**, indicando quali questioni restano.
L'unica eccezione ammessa è un ticket che serve a *chiudere* una questione aperta, tipicamente uno spike per raccogliere i dati su cui l'utente deciderà.

## Passo 1: leggi il PRD e il codice

Un requisito può essere già soddisfatto a metà: verificalo prima di trasformarlo in lavoro.
Un ticket che chiede di costruire qualcosa che esiste già è il modo più rapido per far perdere fiducia a tutta la board.

Guarda anche le specifiche funzionali collegate, se esistono: sono la fonte del "dove si lavora" di ogni ticket.

## Passo 2: tagliare

Parti dai **requisiti** del PRD, non dalle sue sezioni.
Ogni requisito genera da uno a tre ticket, quasi mai di più.

**Taglio verticale, non orizzontale.** Un ticket porta un requisito da un capo all'altro fino a qualcosa di osservabile, invece di fare "tutti i modelli", poi "tutte le API", poi "tutta la UI".
Con il taglio orizzontale nulla è verificabile finché non è finito tutto, e l'ordine di lavoro diventa obbligato dove non serviva.

**L'eccezione deliberata è il contratto.** Quando un requisito tocca due lati (un'API e chi la consuma), il contratto fra i due è un ticket a sé, piccolo, che li sblocca entrambi insieme.
È il singolo intervento che produce più parallelismo di qualunque altro.

Un ticket è **troppo grande** se: richiede più di due o tre documenti per essere capito, tocca più di un repo, oppure eredita più di quattro o cinque criteri di accettazione.

Un ticket è **troppo piccolo** se non produce niente di osservabile da fuori.
"Aggiungi la colonna" non è un ticket, è un passo dentro un ticket.

## Passo 3: dipendenze

**Ogni ticket dichiara solo da cosa è bloccato, mai cosa blocca.**
La direzione opposta si deriva leggendo gli altri ticket.
Scrivere entrambe a mano garantisce che prima o poi divergano, e una board con dipendenze sbagliate è peggio di una senza.

Distingui due cose che si confondono sempre:

- **Blocco vero**: senza A, B non è scrivibile né verificabile. L'esempio tipico è un contratto che ancora non esiste.
- **Preferenza d'ordine**: B è più comodo dopo A, ma si può fare prima. Non è un blocco, e dichiararlo tale distrugge il parallelismo.

La maggior parte dei blocchi che vengono in mente sono preferenze.
Prima di dichiarare un blocco, chiediti se B sia davvero impossibile o solo scomodo.

## Passo 4: scrivere

Un file per ticket, più un indice.
Se il progetto ha già una convenzione per posizione, numerazione e stati, **seguila**; altrimenti proponi questa:

```markdown
# NNNN-MM - Titolo che dice cosa sarà vero alla fine

**PRD:** NNNN, requisito N
**Repo/modulo:** dove atterra il codice
**Bloccato da:** NNNN-MM, oppure nessuno
**Stato:** da fare | in corso | fatto

## Obiettivo
Una o due frasi: cosa esiste alla fine che prima non c'era.

## Criteri di accettazione
Ereditati dal requisito del PRD, ristretti a ciò che questo ticket copre.

## Dove si lavora
I percorsi reali, verificati.

## Cosa non fare qui
Il confine esplicito, per impedire alla sessione di allargarsi.

## Documenti da leggere
Due o tre, mai di più: è il budget di contesto del ticket, non una bibliografia.
```

L'identificativo porta con sé la provenienza (`0002-03` è il terzo ticket del PRD 0002), così un ticket isolato dice sempre da quale decisione discende.

Nell'**indice** vanno tutti i ticket con stato e bloccanti, e in testa la sezione che conta davvero: **pronti ora**, cioè i ticket senza bloccanti ancora aperti.
È la risposta alla domanda che l'utente si fa quando si siede.

Non aggiungere un grafo delle dipendenze accanto alla tabella: sarebbe la terza copia della stessa relazione, e la prima a divergere.

## Passo 5: consegnare

Non consegnare solo i file. Di':

- **cosa si può fare oggi**, e quali di quei ticket possono procedere davvero in parallelo perché toccano parti diverse;
- **qual è il cammino critico**, cioè la catena più lunga di blocchi veri, perché è quella che determina quando si finisce;
- **cosa hai scelto di non trasformare in ticket** e perché.

## Manutenzione

Quando un ticket passa a fatto, cambia solo lo stato nel suo file, e l'indice lo riflette.
Lo stato vive in un posto solo.

Se durante il lavoro emerge che un ticket era tagliato male, è un segnale sul taglio, non sul lavoro: rifallo invece di gonfiare quello esistente.

## Anti-pattern

- Generare ticket da un PRD in bozza.
- Taglio orizzontale per fasi tecniche, che rende tutto verificabile solo alla fine.
- Dichiarare come blocchi quelle che sono preferenze d'ordine.
- Ticket che ripetono dentro di sé il contenuto del PRD invece di citarne il requisito: divergeranno, e il ticket vincerà perché è quello che si legge mentre si scrive il codice.
- Una board che cresce oltre quello che si vede in una schermata senza che nulla venga mai chiuso.
