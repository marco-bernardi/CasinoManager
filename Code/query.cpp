#include <string>
#include <iostream>
#include <iomanip>
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
int main(int argc, char **argv){
    PGconn* conn = connect();
}