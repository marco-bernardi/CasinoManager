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

const char* query[4] = {
        // Statistiche tavoli
        "SELECT vin.Nome,Vincite,vin.med,Perdite,per.med FROM \
        (SELECT Nome, COUNT(IDTx) as Vincite, AVG(Importo) as med FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione \
        WHERE Tipo='Vincita' GROUP BY Nome,Tipo) as vin \
        INNER JOIN \
        (SELECT Nome, COUNT(IDTx) as Perdite, AVG(Importo) as med FROM Postazioni LEFT JOIN Transazione ON Numero=IDPostazione \
        WHERE Tipo='Perdita' GROUP BY Nome,Tipo) as per ON vin.Nome = per.Nome;",

        // Gioco con payout sopra la media
        "SELECT g.Nome, AVG(tx.Importo) FROM Transazione tx \
        INNER JOIN Postazioni ps ON tx.IDPostazione = ps.Numero \
        INNER JOIN Giochi as g ON g.IDGioco = ps.IDGioco \
        WHERE tx.tipo='Vincita' \
        GROUP BY g.Nome \
        HAVING AVG(tx.Importo) > (SELECT AVG(tx.Importo) FROM Transazione tx WHERE tx.tipo='Vincita');",
        // Vincita maggiore alla roulette
        "SELECT DISTINCT Nome, Cognome, Importo FROM Clienti \
        INNER JOIN Transazione ON Clienti.IDCliente=Transazione.IDCliente \
        WHERE Importo = (SELECT MAX(Importo) FROM Transazione \
        WHERE Tipo='Vincita' AND IDPostazione IN \
        (SELECT Numero FROM Postazioni WHERE IDGioco IN (SELECT IDGioco FROM Giochi WHERE Tipo ='Roulette')))",
        // Vincitore di un torneo
        "SELECT c.Nome,c.Cognome, disp.SaldoMano FROM Clienti c \
        INNER JOIN Disputano disp ON disp.IDCliente = c.IDCliente \
        INNER JOIN Match m ON disp.IDMatch = m.IDMatch \
        WHERE m.IsFinal = true AND m.IDTorneo = 1 AND disp.SaldoMano != 0"
};

void print(PGresult* result){
    int tuple = PQntuples(result);
    int campi = PQnfields(result);
    for (int i=0; i<campi; ++i) {
    	cout << left << setw(25) << PQfname(result, i);
    }
    cout << "\n\n"; 
    for(int i=0; i<tuple; ++i) {
    	for (int n=0; n<campi; ++n) {
    		cout << left << setw(25) << PQgetvalue(result, i, n);
    	}
    	cout << '\n';
    }
    cout<<'\n'<< endl;
}


int main(int argc, char **argv){

    PGconn* conn = connect();
    char queryTemp[1500];
    PGresult *result;
    while (true) {
        cout << endl;
        cout << "1. Statistiche tavoli\n";
        cout << "2. Gioco con payout sopra la media\n";
        cout << "3. Vincita maggiore alla roulette\n";
        cout << "4. Vincitore di un torneo\n";
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
        switch (q) {
        case 1:
            system("clear");
            sprintf(queryTemp, query[0]);
            result = execute(conn, queryTemp);
            print(result);
            break;
        case 2:
            system("clear");
            sprintf(queryTemp, query[1]);
            result = execute(conn, queryTemp);
            print(result);
            break;
        case 3:
            system("clear");
            sprintf(queryTemp, query[2]);
            result = execute(conn, queryTemp);
            print(result);
            break;
        case 4:
            system("clear");
            sprintf(queryTemp, query[3]);
            result = execute(conn, queryTemp);
            print(result);
            break;
        default:
            break;
        }
    }
    PQfinish(conn);
}
