#include <cstdio>
#include <iomanip>
#include <iostream>
#include <fstream>
#include "./dependencies/include/libpq-fe.h"
#define PG_HOST "127.0.0.1"
#define PG_USER "postgres"
#define PG_DB "CasinoManager"
#define PG_PASS "ciao1234"
#define PG_PORT 5432

using namespace std;

void prettyPrint(PGresult* res);
PGconn* connect();
PGresult* paramExec(PGconn* conn, string queries[], int input);
void checkResults(PGresult* res, const PGconn* conn);
void separateLines(int fields, int* maxLen);
void prettyPrint(PGresult* res);
void printParams(PGresult* res, PGconn* conn, string queries[], int input);

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
PGresult* paramExec(PGconn* conn, string queries[], int input) {
    PGresult* stmt = PQprepare(conn, "queryParam" + input, queries[input-1].c_str(), 1, NULL);
    string parametro;
    cout << "Inserire il parametro: ";
    cin >> parametro;
    const char* param = parametro.c_str();
    return PQexecPrepared(conn, "queryParam" + input, 1, &param, NULL, 0, 0);
}
void checkResults(PGresult* res, const PGconn* conn) {
    if(PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Inconsistent results! " << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }
}
void separateLines(int fields, int* maxLen) {
    for(int i=0; i<fields; i++) {
        cout << '+';
        for(int j=0; j<maxLen[i]+2; j++)
            cout << '-';
    }
    cout << '+' << endl;
}
void printParams(PGresult* res, PGconn* conn, string queries[], int input){
    res = PQexec(conn, queries[input].c_str());
    checkResults(res, conn);
    prettyPrint(res);
    PQclear(res);
}
void prettyPrint(PGresult* res) {
    // n. tuple
    int tuples = PQntuples(res);
    // n. campi
    int fields = PQnfields(res);
    // array di supporto per salvare le colonne della query
    string query[tuples + 1][fields];

    for(int i=0; i<fields; i++)
        query[0][i] = PQfname(res, i);

    for(int i=0; i<tuples; i++) {
        for(int j=0; j<fields; j++)
            query[i+1][j] = PQgetvalue(res, i, j);
    }

    // Trova l'elemento piu' lungo per ogni colonna
    int maxLen[fields];
    for(int i=0; i<fields; i++) {
        maxLen[i] = 0;
        for(int j=0; j<tuples+1; j++) {
            int size = query[j][i].size();
            maxLen[i] = size > maxLen[i] ? size : maxLen[i];
        }
    }

    // Stampa il risultato della query
    separateLines(fields, maxLen);
    for(int i=0; i<fields; i++) {
        cout << "| ";
        cout << query[0][i];
        for(int j=0; j<maxLen[i]-query[0][i].size()+1; j++)
            cout << ' ';
        if(i == fields-1)
            cout << '|';
    }
    cout << endl;
    separateLines(fields, maxLen);
    for(int i=1; i<tuples+1; i++) {
        for(int j=0; j<fields; j++) {
            cout << "| ";
            cout << query[i][j];
            for(int k=0; k<maxLen[j]-query[i][j].size()+1; k++)
                cout << ' ';
            if(j == fields-1)
                cout << '|';
        }
        cout << endl;
    }
    separateLines(fields, maxLen);
}


string paramQueries[4] = {
    "SELECT * FROM Casinò",
    "SELECT DISTINCT tipo FROM Giochi",
    "select idtorneo as NumeroTorneo, nome, datatorneo as data from tornei",
    "SELECT DISTINCT IDPersonale, Nome, Cognome  \
    FROM Personale WHERE IDPersonale IN (SELECT IDPersonale FROM Lavora) ORDER BY IDPersonale"
};
string queries[6] = {
    // Gioco con payout sopra la media
    "SELECT g.Nome as Nome_Gioco, AVG(tx.Importo) as Media_Vittorie FROM Transazioni tx \
    INNER JOIN Postazioni as ps ON tx.IDPostazione = ps.Numero \
    INNER JOIN Giochi as g ON g.IDGioco = ps.IDGioco \
    WHERE tx.tipo='Vincita' \
    GROUP BY g.Nome \
    HAVING AVG(tx.Importo) > (SELECT AVG(tx.Importo) FROM Transazioni tx WHERE tx.tipo='Vincita');",
    // Statistiche tavoli
    "SELECT vin.Nome,Vincite,round(vin.media,2),Perdite,round(per.media,2) FROM \
    (SELECT ps.Nome, COUNT(IDTx) AS Vincite, AVG(Importo) AS media FROM Postazioni ps LEFT JOIN Transazioni tx ON Numero=IDPostazione \
    INNER JOIN Sale ON  NomeSala = Sale.Nome AND NumeroSala = Sale.Numero \
    WHERE tx.Tipo='Vincita' AND IDCasinò=$1::integer GROUP BY ps.Nome,tx.Tipo) AS vin \
    INNER JOIN \
    (SELECT ps.Nome, COUNT(IDTx) AS Perdite, AVG(Importo) AS media FROM Postazioni ps LEFT JOIN Transazioni tx ON Numero=IDPostazione \
    INNER JOIN Sale ON  NomeSala = Sale.Nome AND NumeroSala = Sale.Numero \
    WHERE tx.Tipo='Perdita' AND IDCasinò=$1::integer GROUP BY ps.Nome,tx.Tipo) AS per ON vin.Nome = per.Nome",
    // Vincita maggiore al gioco selezionato
    "SELECT DISTINCT Nome, Cognome, Importo FROM Clienti \
    INNER JOIN Transazioni ON Clienti.IDCliente=Transazioni.IDCliente \
    WHERE Importo = (SELECT MAX(Importo) FROM Transazioni \
    WHERE Tipo='Vincita' AND IDPostazione IN \
    (SELECT Numero FROM Postazioni WHERE IDGioco IN (SELECT IDGioco FROM Giochi WHERE Tipo =$1::varchar)))",
    // Vincitore di un torneo
    "SELECT c.Nome,c.Cognome, disp.SaldoMano FROM Clienti c \
    INNER JOIN Disputano disp ON disp.IDCliente = c.IDCliente \
    INNER JOIN Match m ON disp.IDMatch = m.IDMatch \
    WHERE m.IsFinal = true AND m.IDTorneo = $1::integer AND disp.SaldoMano != 0",
    // Turni di lavoro di un dipendete
    "SELECT ps.nome,ps.cognome,pst.Nome,pst.NomeSala,lv.Ora_Inizio,lv.Ora_Fine \
    FROM Lavora lv \
    INNER JOIN Personale ps ON lv.IDPersonale=ps.IDPersonale \
    INNER JOIN Postazioni pst ON lv.NumeroPs=pst.Numero \
    WHERE ps.IDPersonale=$1::integer",
    // Dipendenti con vincite sopra la media
    "SELECT p.nome,p.cognome,p.IDPersonale,round(alldata.mediaImporto,2) FROM (SELECT pe.IDPersonale,AVG(tr.Importo) as mediaImporto \
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


int main(int argc, char **argv){
    PGconn* conn = connect();
    PGresult *result = nullptr;
    PGresult *paramsresult = nullptr;
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
        int i = 0;
        char* idx;
        switch (q) {
        case 1:
            system("clear");
            result = PQexec(conn, queries[q-1].c_str());
            checkResults(result, conn);
            prettyPrint(result);
            PQclear(result);            
            break;
        case 2:
            system("clear");
            printParams(paramsresult,conn,paramQueries,0);
            cout << "Parametro = ID Casinò" << endl;
            result = paramExec(conn, queries, q);
            checkResults(result, conn);
            prettyPrint(result);
            PQclear(result);
            break;
        case 3:
            system("clear");
            printParams(paramsresult,conn,paramQueries,1);
            cout << "Parametro = Tipo Gioco" << endl;
            result = paramExec(conn, queries, q);
            checkResults(result, conn);
            prettyPrint(result);
            PQclear(result);
            break;
        case 4:
            system("clear");
            printParams(paramsresult,conn,paramQueries,2);
            cout << "Parametro = Numero Torneo" << endl;
            result = paramExec(conn, queries, q);
            checkResults(result, conn);
            prettyPrint(result);
            PQclear(result);
            break;
        case 5:
            system("clear");
            printParams(paramsresult,conn,paramQueries,3);
            cout << "Parametro = Id Personale" << endl;
            result = paramExec(conn, queries, q);
            checkResults(result, conn);
            prettyPrint(result);
            PQclear(result);
            break;
        case 6:
            system("clear");
            result = PQexec(conn, queries[q-1].c_str());
            checkResults(result, conn);
            prettyPrint(result);
            PQclear(result);            
            break;                
        default:
            break;
        }
    }
    PQfinish(conn);
}