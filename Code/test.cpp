#include <cstdio>
#include <iomanip>
#include <iostream>
#include <fstream>
#include "libpq-fe.h"

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

const char* query[1] = {
        "select Nome, Cognome, contatto \
        from Personale;"
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
    sprintf(queryTemp, query[0]);
    PGresult *result;
    result = execute(conn, queryTemp);
    print(result);

}
