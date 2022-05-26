 ________ .-./`) ,---.   .--.   ____      .---.    .-./`)  
|        |\ .-.')|    \  |  | .'  __ `.   | ,_|    \ .-.') 
|   .----'/ `-' \|  ,  \ |  |/   '  \  \,-./  )    / `-' \ 
|  _|____  `-'`"`|  |\_ \|  ||___|  /  |\  '_ '`)   `-'`"` 
|_( )_   | .---. |  _( )_\  |   _.-`   | > (_)  )   .---.  
(_ o._)__| |   | | (_ o _)  |.'   _    |(  .  .-'   |   |  
|(_,_)     |   | |  (_,_)\  ||  _( )_  | `-'`-'|___ |   |  
|   |      |   | |  |    |  |\ (_ o _) /  |        \|   |  
'---'      '---' '--'    '--' '.(_,_).'   `--------`'---'  
                                                           

------- 1 // MOSTRARE I GIOCHI CON UN PAYOUT SUPERIORE ALLA mediaIA 

SELECT g.Nome, AVG(tx.Importo) FROM Transazione tx 
INNER JOIN Postazioni AS ps ON tx.IDPostazione = ps.Numero 
INNER JOIN Giochi AS g ON g.IDGioco = ps.IDGioco 
WHERE tx.tipo='Vincita' 
GROUP BY g.Nome 
HAVING AVG(tx.Importo) > (SELECT AVG(tx.Importo) FROM Transazione tx WHERE tx.tipo='Vincita')

------- 2 // Mostrare statistiche tavolo vincite sconfitte

-- // CON VIEW
DROP VIEW IF EXISTS vincite;
CREATE VIEW vincite AS
SELECT Nome, COUNT(IDTx) AS Vincite FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione 
WHERE Tipo='Vincita' GROUP BY Nome,Tipo;
 
DROP VIEW IF EXISTS perdite;
CREATE VIEW perdite AS
SELECT Nome, COUNT(IDTx) AS Perdite FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione 
WHERE Tipo='Perdita' GROUP BY Nome,Tipo ;

SELECT v.Nome,Vincite,Perdite FROM vincite v INNER JOIN perdite p ON v.Nome = p.Nome  

-- // SENZA VIEW

SELECT vin.Nome,Vincite,vin.media,Perdite,per.media FROM 
(SELECT Nome, COUNT(IDTx) AS Vincite, AVG(Importo) AS media FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione 
WHERE Tipo='Vincita' GROUP BY Nome,Tipo) AS vin 
INNER JOIN 
(SELECT Nome, COUNT(IDTx) AS Perdite, AVG(Importo) AS media FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione 
WHERE Tipo='Perdita' GROUP BY Nome,Tipo) AS per ON vin.Nome = per.Nome WHERE vin.media > per.media

------- 3 // Mostrare il cliente che ha vinto la maggior somma di denaro alla roulette

SELECT DISTINCT Nome, Cognome, Importo FROM Clienti 
INNER JOIN Transazione ON Clienti.IDCliente=Transazione.IDCliente 
WHERE Importo = (SELECT MAX(Importo) FROM Transazione 
WHERE Tipo='Vincita' AND IDPostazione IN (SELECT Numero FROM Postazioni WHERE IDGioco IN (SELECT IDGioco FROM Giochi WHERE Tipo ='Roulette')))

------- 4 // Mostrare il vincitore di un torneo e 

SELECT c.Nome,c.Cognome, disp.SaldoMano FROM Clienti c 
INNER JOIN Disputano AS disp ON disp.IDCliente = c.IDCliente 
INNER JOIN Match AS m ON disp.IDMatch = m.IDMatch 
WHERE m.IsFinal = true AND m.IDTorneo = 1 AND disp.SaldoMano != 0 

.-./`) ,---.   .--. ______         .-''-.   _____     __   
\ .-.')|    \  |  ||    _ `''.   .'_ _   \  \   _\   /  /  
/ `-' \|  ,  \ |  || _ | ) _  \ / ( ` )   ' .-./ ). /  '   
 `-'`"`|  |\_ \|  ||( ''_'  ) |. (_ o _)  | \ '_ .') .'    
 .---. |  _( )_\  || . (_) `. ||  (_,_)___|(_ (_) _) '     
 |   | | (_ o _)  ||(_    ._) ''  \   .---.  /    \   \    
 |   | |  (_,_)\  ||  (_.\.' /  \  `-'    /  `-'`-'    \   
 |   | |  |    |  ||       .'    \       /  /  /   \    \  
 '---' '--'    '--''-----'`       `'-..-'  '--'     '----' 
                                                           

CREATE INDEX idx_transazione ON transazione(idpostazione,idcliente)