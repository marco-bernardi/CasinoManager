    ,-----.        .-''-.  .-------.       ____     __  
  .'  .-,  '.    .'_ _   \ |  _ _   \      \   \   /  / 
 / ,-.|  \ _ \  / ( ` )   '| ( ' )  |       \  _. /  '  
;  \  '_ /  | :. (_ o _)  ||(_ o _) /        _( )_ .'   
|  _`,/ \ _/  ||  (_,_)___|| (_,_).' __  ___(_ o _)'    
: (  '\_/ \   ;'  \   .---.|  |\ \  |  ||   |(_,_)'     
 \ `"/  \  )  \ \  `-'    /|  | \ `'   /|   `-'  /      
  '. \_/``"/)  ) \       / |  |  \    /  \      /       
    '-----' `-'   `'-..-'  ''-'   `'-'    `-..-'        
    
------- 1 // MOSTRARE I GIOCHI CON UN PAYOUT SUPERIORE ALLA mediaIA 

SELECT g.Nome as Nome_Gioco, AVG(tx.Importo) as Media_Vittorie FROM Transazioni tx 
INNER JOIN Postazioni AS ps ON tx.IDPostazione = ps.Numero 
INNER JOIN Giochi AS g ON g.IDGioco = ps.IDGioco 
WHERE tx.tipo='Vincita' 
GROUP BY g.Nome 
HAVING AVG(tx.Importo) > (SELECT AVG(tx.Importo) FROM Transazioni tx WHERE tx.tipo='Vincita')

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
(SELECT ps.Nome, COUNT(IDTx) AS Vincite, AVG(Importo) AS media FROM Postazioni ps LEFT JOIN Transazioni tx ON Numero=IDPostazione
INNER JOIN Sale ON  NomeSala = Sale.Nome AND NumeroSala = Sale.Numero
WHERE tx.Tipo='Vincita' AND IDCasinò=2 GROUP BY ps.Nome,tx.Tipo) AS vin 
INNER JOIN 
(SELECT ps.Nome, COUNT(IDTx) AS Perdite, AVG(Importo) AS media FROM Postazioni ps LEFT JOIN Transazioni tx ON Numero=IDPostazione
INNER JOIN Sale ON  NomeSala = Sale.Nome AND NumeroSala = Sale.Numero
WHERE tx.Tipo='Perdita' AND IDCasinò=2 GROUP BY ps.Nome,tx.Tipo) AS per ON vin.Nome = per.Nome

------- 3 // Mostrare il cliente che ha vinto la maggior somma di denaro ad un tipo di gioco

SELECT DISTINCT Nome, Cognome, Importo FROM Clienti 
INNER JOIN Transazioni ON Clienti.IDCliente=Transazioni.IDCliente 
WHERE Importo = (SELECT MAX(Importo) FROM Transazioni 
WHERE Tipo='Vincita' AND IDPostazione IN 
(SELECT Numero FROM Postazioni WHERE IDGioco IN (SELECT IDGioco FROM Giochi WHERE Tipo ='Roulette')))

------- 4 // Mostrare il vincitore di un torneo e 

SELECT c.Nome,c.Cognome, disp.SaldoMano FROM Clienti c 
INNER JOIN Disputano AS disp ON disp.IDCliente = c.IDCliente 
INNER JOIN Match AS m ON disp.IDMatch = m.IDMatch 
WHERE m.IsFinal = true AND m.IDTorneo = 1 AND disp.SaldoMano != 0 

------- 5 // Mostrare i turni di lavoro di un dipendente

SELECT ps.nome,ps.cognome,pst.Nome,pst.NomeSala,lv.Ora_Inizio,lv.Ora_Fine 
FROM Lavora lv 
INNER JOIN Personale ps ON lv.IDPersonale=ps.IDPersonale 
INNER JOIN Postazioni pst ON lv.NumeroPs=pst.Numero 
WHERE ps.IDPersonale=1

SELECT DISTINCT Nome, Cognome FROM Personale WHERE IDPersonale IN (SELECT IDPersonale FROM Lavora)

------- 6 // Mostrare i dipendenti che hanno una media di transazioni perdenti sopra la media

SELECT DISTINCT p.nome,p.cognome,p.IDPersonale,alldata.mediaImporto FROM (SELECT pe.IDPersonale,AVG(tr.Importo) as mediaImporto 
                FROM ((Personale as pe INNER JOIN Lavora as l ON pe.IDPersonale=l.IDPersonale) 
                INNER JOIN Postazioni AS po ON l.NumeroPs=po.Numero) 
                INNER JOIN Transazioni AS tr ON po.Numero=tr.IDPostazione
WHERE tr.Tipo='Perdita'
GROUP BY pe.IDPersonale
HAVING AVG(tr.importo) > (SELECT AVG(tr.importo) FROM 
                ((Personale as pe INNER JOIN Lavora as l ON pe.IDPersonale=l.IDPersonale) 
                INNER JOIN Postazioni AS po ON l.NumeroPs=po.Numero) 
                INNER JOIN Transazioni AS tr ON po.Numero=tr.IDPostazione
                WHERE tr.Tipo='Perdita')) as alldata
                INNER JOIN Personale as p on alldata.IDPersonale=p.IDPersonale
                order by p.IDPersonale




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
