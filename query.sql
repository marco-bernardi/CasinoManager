// Mostrare il vincitore di un torneo e 

SELECT c.Nome,c.Cognome, disp.SaldoMano FROM Clienti c INNER JOIN Disputano disp ON disp.IDCliente = c.IDCliente INNER JOIN Match m ON disp.IDMatch = m.IDMatch WHERE m.IsFinal = true AND m.IDTorneo = 1 AND disp.SaldoMano != 0 


/////////////////////////////////

// Mostrare i turni di lavoro di un dipendente

SELECT Ora_Inizio, Ora_Fine FROM Lavora WHERE IDPersonale = 20

// Mostrare i dipendenti che hanno turni registrati

SELECT DISTINCT Nome, Cognome FROM Personale INNER JOIN Lavora ON  Personale.IDPersonale=Lavora.IDPersonale

////////////////////////////////

// Mostrare il cliente che ha vinto la maggior somma di denaro alla roulette

SELECT DISTINCT Nome, Cognome, Importo FROM Clienti INNER JOIN Transazione ON Clienti.IDCliente=Transazione.IDCliente 
WHERE Importo= (SELECT MAX(Importo) FROM Transazione 
WHERE Tipo='Vincita' AND IDPostazione IN (SELECT Numero FROM Postazioni WHERE IDGioco IN (SELECT IDGioco FROM Giochi WHERE Tipo ='Roulette')))


// Mostrare statistiche tavolo vincite sconfitte

SELECT Nome, COUNT(IDTx) as vincite, COUNT(IDTx) as perdite
FROM Postazioni LEFT JOIN Transazione tx ON Numero=tx.IDPostazione GROUP BY Nome,tx.Tipo HAVING tx.Tipo='Vincita'

(SELECT COUNT(IDTx) FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione GROUP BY Nome,Tipo HAVING Tipo='Perdita') as perdite

SELECT Nome, COUNT(tx.IDTx) as vincite, COUNT(tx1.IDTx) as perdite FROM Postazioni p, Transazione tx, Transazione tx1 WHERE tx.tipo='Vincita' AND tx1.tipo='Perdita'
GROUP BY p.Nome,p.Numero,tx.IDPostazione,tx1.IDPostazione HAVING p.Numero=tx.IDPostazione AND p.Numero=tx1.IDPostazione





// Mostrare i le ultime 10 transazioni di un cliente ( o ultima settimana)

SELECT COUNT(IDPostazione) FROM Transazione WHERE IDPostazione = 4 AND Tipo='Vincita'
34 AR







CREATE INDEX idx_transazione ON transazione(idpostazione,idcliente)
