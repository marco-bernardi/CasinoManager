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

// CON VIEW
DROP VIEW IF EXISTS vincite;
CREATE VIEW vincite AS
SELECT Nome, COUNT(IDTx) as Vincite FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione 
WHERE Tipo='Vincita' GROUP BY Nome,Tipo;
 
DROP VIEW IF EXISTS perdite;
CREATE VIEW perdite AS
SELECT Nome, COUNT(IDTx) as Perdite FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione 
WHERE Tipo='Perdita' GROUP BY Nome,Tipo ;

SELECT v.Nome,Vincite,Perdite FROM vincite v INNER JOIN perdite p ON v.Nome = p.Nome  

// SENZA VIEW

SELECT vin.Nome,Vincite,Perdite FROM 
(SELECT Nome, COUNT(IDTx) as Vincite FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione 
WHERE Tipo='Vincita' GROUP BY Nome,Tipo) as vin 
INNER JOIN 
(SELECT Nome, COUNT(IDTx) as Perdite FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione 
WHERE Tipo='Perdita' GROUP BY Nome,Tipo) as per ON vin.Nome = per.Nome


// Mostrare i tavoli che hanno la media delle vittorie superiore a quella delle perdite;




// Mostrare i le ultime 10 transazioni di un cliente ( o ultima settimana)

SELECT COUNT(IDPostazione) FROM Transazione WHERE IDPostazione = 4 AND Tipo='Vincita'
34 AR







CREATE INDEX idx_transazione ON transazione(idpostazione,idcliente)
