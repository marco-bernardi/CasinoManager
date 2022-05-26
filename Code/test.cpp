#include <cstdio>
#include <iomanip>
#include <iostream>
#include <fstream>
#include "./dependencies/include/libpq-fe.h"

using namespace std;

#define PG_HOST "127.0.0.1"
#define PG_USER "postgres"
#define PG_DB "CasinoManager"
#define PG_PASS "ciao1234"
#define PG_PORT 5432

PGconn* connect(){
    PGconn * conn;
    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER, PG_PASS, PG_DB, PG_HOST, PG_PORT);
    conn = PQconnectdb(conninfo);
    if(PQstatus(conn) != CONNECTION_OK){
        cout<<"Errore di connessione "<<PQerrorMessage(conn);
        PQfinish(conn);
        exit(1);
    }
    else{
        cout<<"Connessione avvenuta correttamente\n";
        return conn;
    }

}

PGresult* execute(PGconn* conn, const char* query) {
    PGresult* res = PQexec(conn, query);
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << " Risultati inconsistenti!" << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }

    return res;
}

const char* query[6] = {
        // Gioco con payout sopra la media
        "SELECT g.Nome as Nome_Gioco, AVG(tx.Importo) as Media_Vittorie FROM Transazioni tx \
        INNER JOIN Postazioni as ps ON tx.IDPostazione = ps.Numero \
        INNER JOIN Giochi as g ON g.IDGioco = ps.IDGioco \
        WHERE tx.tipo='Vincita' \
        GROUP BY g.Nome \
        HAVING AVG(tx.Importo) > (SELECT AVG(tx.Importo) FROM Transazioni tx WHERE tx.tipo='Vincita');",

        // Statistiche tavoli
        "SELECT vin.Nome,Vincite,vin.media,Perdite,per.media FROM \
        (SELECT ps.Nome, COUNT(IDTx) AS Vincite, AVG(Importo) AS media FROM Postazioni ps LEFT JOIN Transazioni tx ON Numero=IDPostazione \
        INNER JOIN Sale ON  NomeSala = Sale.Nome AND NumeroSala = Sale.Numero \
        WHERE tx.Tipo='Vincita' AND IDCasinò=%s GROUP BY ps.Nome,tx.Tipo) AS vin \
        INNER JOIN \
        (SELECT ps.Nome, COUNT(IDTx) AS Perdite, AVG(Importo) AS media FROM Postazioni ps LEFT JOIN Transazioni tx ON Numero=IDPostazione \
        INNER JOIN Sale ON  NomeSala = Sale.Nome AND NumeroSala = Sale.Numero \
        WHERE tx.Tipo='Perdita' AND IDCasinò=%s GROUP BY ps.Nome,tx.Tipo) AS per ON vin.Nome = per.Nome",

        // Vincita maggiore al gioco selezionato
        "SELECT DISTINCT Nome, Cognome, Importo FROM Clienti \
        INNER JOIN Transazioni ON Clienti.IDCliente=Transazioni.IDCliente \
        WHERE Importo = (SELECT MAX(Importo) FROM Transazioni \
        WHERE Tipo='Vincita' AND IDPostazione IN \
        (SELECT Numero FROM Postazioni WHERE IDGioco IN (SELECT IDGioco FROM Giochi WHERE Tipo ='%s')))",

        // Vincitore di un torneo
        "SELECT c.Nome,c.Cognome, disp.SaldoMano FROM Clienti c \
        INNER JOIN Disputano disp ON disp.IDCliente = c.IDCliente \
        INNER JOIN Match m ON disp.IDMatch = m.IDMatch \
        WHERE m.IsFinal = true AND m.IDTorneo = %s AND disp.SaldoMano != 0",

        "SELECT ps.nome,ps.cognome,pst.Nome,pst.NomeSala,lv.Ora_Inizio,lv.Ora_Fine \
        FROM Lavora lv \
        INNER JOIN Personale ps ON lv.IDPersonale=ps.IDPersonale \
        INNER JOIN Postazioni pst ON lv.NumeroPs=pst.Numero \
        WHERE ps.IDPersonale=%s",

        "SELECT p.nome,p.cognome,p.IDPersonale,alldata.mediaImporto FROM (SELECT pe.IDPersonale,AVG(tr.Importo) as mediaImporto \
        FROM ((Personale as pe INNER JOIN Lavora as l ON pe.IDPersonale=l.IDPersonale) \
        INNER JOIN Postazioni AS po ON l.NumeroPs=po.Numero) \
        INNER JOIN Transazioni AS tr ON po.Numero=tr.IDPostazione \
        WHERE tr.Tipo='Perdita' \
        GROUP BY pe.IDPersonale \
        HAVING AVG(tr.importo) > (SELECT AVG(tr.importo) FROM \
        ((Personale as pe INNER JOIN Lavora as l ON pe.IDPersonale=l.IDPersonale) \
        INNER JOIN Postazioni AS po ON l.NumeroPs=po.Numero) \
        INNER JOIN Transazioni AS tr ON po.Numero=tr.IDPostazione \
        WHERE tr.Tipo='Perdita')) as alldata \
        INNER JOIN Personale as p on alldata.IDPersonale=p.IDPersonale \
        order by p.IDPersonale"
};

void print(PGresult* result){
    int tuple = PQntuples(result);
    int campi = PQnfields(result);
    for (int i=0; i<campi; ++i) {
    	cout << left << setw(40) << PQfname(result, i);
    }
    cout << "\n\n"; 
    for(int i=0; i<tuple; ++i) {
    	for (int n=0; n<campi; ++n) {
    		cout << left << setw(40) << PQgetvalue(result, i, n);
    	}
    	cout << '\n';
    }
    cout<<'\n'<< endl;
}

char* chooseParam(PGconn* conn, const char* query, const char* table, int idx) {
    PGresult* res = execute(conn, query);
    print(res);
    const int tuple = PQntuples(res), campi = PQnfields(res);
    int val;
    cout << "Inserisci il numero del " << table << " scelto: ";
    cin >> val;
    while (val <= 0) {
        cout << "Valore non valido\n";
        cout << "Inserisci il numero del " << table << " scelto: ";
        cin >> val;
    }
    return PQgetvalue(res, val - 1, idx);
}

int main(int argc, char **argv){

    PGconn* conn = connect();
    char queryTemp[1500];
    PGresult *result;
    while (true) {
        cout << endl;
        cout << "1. Gioco con payout sopra la media\n";
        cout << "2. Statistiche tavoli\n";
        cout << "3. Vincita maggiore al gioco selezionato\n";
        cout << "4. Vincitore di un torneo\n";
        cout << "5. Visualizzare i turni di lavoro di un dipendente \n";
        cout << "6. Dipendenti con vincite sopra la media \n";
        cout << "Query da eseguire (0 per uscire): ";

        int q = 0;
        cin >> q;
        while (q < 0 || q > 6) {
            cout << "Le query vanno da 1 a 6...\n";
            cout << "Query da eseguire (0 per uscire): ";
            cin >> q;
        }
        if (q == 0) break;
        char queryTemp[1500];

        int i = 0;
        char* idx;
        switch (q) {
        case 1:
            system("clear");
            sprintf(queryTemp, query[0]);
            result = execute(conn, queryTemp);
            print(result);
            break;
        case 2:
            system("clear");
            idx = chooseParam(conn, "SELECT * FROM Casinò","Casinò", 0);
            sprintf(queryTemp, query[1],idx,idx );
            result = execute(conn, queryTemp);
            print(result);
            break;
        case 3:
            system("clear");
            sprintf(queryTemp, query[2],chooseParam(
                conn, "SELECT * FROM Giochi", "Gioco",1
            ));
            result = execute(conn, queryTemp);
            print(result);
            break;
        case 4:
            system("clear");
            sprintf(queryTemp, query[3],chooseParam(
                conn, "select idtorneo as NumeroTorneo, nome, datatorneo as data from tornei", "Torneo",0
            ));
            result = execute(conn, queryTemp);
            print(result);
            break;
        case 5:
            system("clear");
            sprintf(queryTemp, query[4],chooseParam(
                conn, "SELECT DISTINCT IDPersonale,Nome, Cognome FROM Personale WHERE IDPersonale IN (SELECT IDPersonale FROM Lavora) ORDER BY IDPersonale ASC", "Dipendenti",0
            ));
            result = execute(conn, queryTemp);
            print(result);
            break;
        case 6:
            system("clear");
            sprintf(queryTemp, query[5]);
            result = execute(conn, queryTemp);
            print(result);
            break;
        default:
            break;
        }
    }
    PQfinish(conn);
}
