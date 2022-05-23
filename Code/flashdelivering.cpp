#include <cstdio>
#include <iostream>
#include <string>
#include "dependencies/include/libpq-fe.h"
using std::cout;
using std::endl;
using std::string;
using std::cin;

PGconn* connect(const char* host, const char* user, const char* db, const char* pass, const char* port) {
    char conninfo[256];
    sprintf(conninfo, "user=%s password=%s dbname=\'%s\' hostaddr=%s port=%s",
        user, pass, db, host, port);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        std::cerr << "Errore di connessione" << endl << PQerrorMessage(conn);
        PQfinish(conn);
        exit(1);
    }

    return conn;
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

void printLine(int campi, int* maxChar) {
    for (int j = 0; j < campi; ++j) {
        cout << '+';
        for (int k = 0; k < maxChar[j] + 2; ++k)
            cout << '-';
    }
    cout << "+\n";
}
void printQuery(PGresult* res) {
    // Preparazione dati
    const int tuple = PQntuples(res), campi = PQnfields(res);
    string v[tuple + 1][campi];

    for (int i = 0; i < campi; ++i) {
        string s = PQfname(res, i);
        v[0][i] = s;
    }
    for (int i = 0; i < tuple; ++i)
        for (int j = 0; j < campi; ++j) {
            if (string(PQgetvalue(res, i, j)) == "t" || string(PQgetvalue(res, i, j)) == "f")
                if (string(PQgetvalue(res, i, j)) == "t")
                    v[i + 1][j] = "si";
                else
                    v[i + 1][j] = "no";
            else
                v[i + 1][j] = PQgetvalue(res, i, j);
        }

    int maxChar[campi];
    for (int i = 0; i < campi; ++i)
        maxChar[i] = 0;

    for (int i = 0; i < campi; ++i) {
        for (int j = 0; j < tuple + 1; ++j) {
            int size = v[j][i].size();
            maxChar[i] = size > maxChar[i] ? size : maxChar[i];
        }
    }

    // Stampa effettiva delle tuple
    printLine(campi, maxChar);
    for (int j = 0; j < campi; ++j) {
        cout << "| ";
        cout << v[0][j];
        for (int k = 0; k < maxChar[j] - v[0][j].size() + 1; ++k)
            cout << ' ';
        if (j == campi - 1)
            cout << "|";
    }
    cout << endl;
    printLine(campi, maxChar);

    for (int i = 1; i < tuple + 1; ++i) {
        for (int j = 0; j < campi; ++j) {
            cout << "| ";
            cout << v[i][j];
            for (int k = 0; k < maxChar[j] - v[i][j].size() + 1; ++k)
                cout << ' ';
            if (j == campi - 1)
                cout << "|";
        }
        cout << endl;
    }
    printLine(campi, maxChar);
}

char* chooseParam(PGconn* conn, const char* query, const char* table) {
    PGresult* res = execute(conn, query);
    printQuery(res);

    const int tuple = PQntuples(res), campi = PQnfields(res);
    int val;
    cout << "Inserisci il numero del " << table << " scelto: ";
    cin >> val;
    while (val <= 0 || val > tuple) {
        cout << "Valore non valido\n";
        cout << "Inserisci il numero del " << table << " scelto: ";
        cin >> val;
    }
    return PQgetvalue(res, val - 1, 0);
}

int main(int argc, char** argv) {
    cout << "Password: ";
    char pass[50];
    cin >> pass;
    PGconn* conn = connect("127.0.0.1", "postgres", "Flash Delivering", pass, "5432");

    const char* query[6] = {
        "select stelleristorante, testo, rider, stellerider \
        from recensione rec, ristorante ris \
        where rec.ristorante = ris.id and ris.id = %s \
        order by stelleristorante desc;",

        "select c.mail, p.nome as Piatto, r.nome as ristorante, a.nome as allergene \
        from cliente c, allergene a, ordine o, allergie_clienti ac, piatti_ordinati po, \
        piatto p, allergie_piatti ap, ristorante r \
        where c.mail = o.cliente and c.mail = ac.cliente and o.id = po.ordine and \
        po.piatto = p.nome and po.ristorante = p.ristorante and ap.piatto = p.nome and \
        ap.ristorante = p.ristorante and ac.allergene = a.nome and ap.allergene = a.nome and r.id = o.ristorante \
        group by c.mail, p.nome, a.nome, r.nome;",

        "select cf, nome, cognome, dipendente,stipendio as guadagno_maggio2020 \
        from rider \
        where dipendente = true \
        union \
        select cf, nome, cognome,dipendente, sum(costospedizione) \
        from rider r, spedizione s \
        where r.dipendente = false and s.rider = r.CF and s.DataoraArrivo >= '2020-05-01' and \
        s.DataoraArrivo <= '2020-05-31' \
        group by r.cf \
        order by guadagno_maggio2020 desc;",

        "drop view if exists piatti_clienti; \
        create view piatti_clienti as \
        select c.mail,po.piatto,sum(quantita) as tot \
        from cliente c, ordine o, piatti_ordinati po \
        where c.mail = o.cliente and o.id = po.ordine \
        group by c.mail,po.piatto; \
        select p1.mail as cliente, p1.tot as n_ordinazioni \
        from piatti_clienti p1 \
        where p1.piatto = '%s' \
        except \
        select p1.mail, p1.tot \
        from piatti_clienti p1, piatti_clienti p2 \
        where p1.mail = p2.mail and p1.tot < p2.tot \
        order by n_ordinazioni desc;",

        "drop view if exists importo_tot_clienti; \
        create view importo_tot_clienti as \
        select c.mail, sum( \
            p.prezzo * po.quantita * coalesce(r.percentualesconto * 0.01, 1) \
        ) as tot \
        from cliente c, ordine o, piatti_ordinati po, piatto p, ristorante r \
        where c.mail = o.cliente and po.ordine = o.id and \
            po.piatto = p.nome and po.ristorante = p.ristorante and \
            p.ristorante = r.id \
        group by c.mail; \
        drop view if exists spese_sped_tot_clienti; \
        create view spese_sped_tot_clienti as \
        select c.mail, coalesce(sum(s.costospedizione), 0) as tot \
        from cliente c, ordine o left join spedizione s on(s.ordine = o.id) \
        where o.cliente = c.mail and c.premium = false \
        group by c.mail; \
        select c.nome, c.cognome, \
            round(i.tot, 2) as importo_pagato, \
            coalesce(s.tot, 0) as tot_spedizione, \
            round(i.tot + coalesce(s.tot, 0), 2) as totale_pagato \
        from cliente c, \
            importo_tot_clienti i left join spese_sped_tot_clienti s \
            on(i.mail = s.mail) \
        where c.mail = i.mail \
        order by totale_pagato desc \
        limit 10;",

        "select r.nome as ristorante, \
        g.oraapertura as orario_di_apertura, g.orachiusura as orario_di_chiusura \
        from ristorante r, giorno g, ( \
            select c.mail, r.id \
            from cliente c, ristorante r \
            except(select ac.cliente, ap.ristorante \
                from allergie_clienti ac, allergie_piatti ap \
        where ac.allergene = ap.allergene) \
                ) as cr \
        where r.id = g.ristorante and g.data = '%s' and \
            g.oraapertura <= '%s' and g.orachiusura >= '%s' and \
            r.id = cr.id and cr.mail = '%s' \
            order by cr.mail, r.id;"
    };

    while (true) {
        cout << endl;
        cout << "1. Mostrare tutte le recensioni di un ristorante\n";
        cout << "2. Per ogni cliente visualizzare i piatti che hanno ordinato (nome, ristorante)\n";
        cout << "   a cui sono allergici mostrando l'allergene in questione\n";
        cout << "3. Visualizzare il guadagno dei rider nel mese di maggio 2020, tenendo conto\n";
        cout << "   che quelli dipendenti hanno uno stipendio fisso mentre gli altri guadagnano in\n";
        cout << "   base alle consegne\n";
        cout << "4. Stampare i clienti che hanno un determinato piatto preferito e quante volte lo\n";
        cout << "   hanno ordinato\n";
        cout << "5. Mostrare i dieci clienti che hanno speso di piu' sull'applicazione\n";
        cout << "6. Mostrare i ristoranti aperti in un determinato momento che preparano solo piatti a cui\n";
        cout << "   uno specifico cliente non e' allergico\n";

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
            sprintf(queryTemp, query[0], chooseParam(
                conn, "select id, nome from ristorante", "Ristorante"
            ));
            printQuery(execute(conn, queryTemp));
            break;
        case 4:
            char piatto[20];
            cout << "Inserisci il nome del Piatto: ";
            cin >> piatto;
            sprintf(queryTemp, query[3], piatto);
            printQuery(execute(conn, queryTemp));
            break;
        case 6:
            char data[11], ora[6], mail[40], password[30];
            cout << "Data (AAAA-MM-GG): ";
            cin >> data;
            cout << "Ora (HH:MM): ";
            cin >> ora;
            cout << "Inserisci la tua mail: ";
            cin >> mail;
            cout << "password: ";
            cin >> password;
            sprintf(
                queryTemp, "select count(*) from cliente where mail = '%s' and password = '%s'",
                mail, password
            );
            i = 0;
            while (*PQgetvalue(execute(conn, queryTemp), 0, 0) == '0' && i < 5) {
                cout << "Le credenziali inserite per l'utente " << mail << " non sono corrette\n";
                cout << "password (tentativi rimasti " << 5 - i << "): ";
                cin >> password;
                sprintf(
                    queryTemp, "select count(*) from cliente where mail = '%s' and password = '%s'",
                    mail, password
                );
                ++i;
            }

            if (*PQgetvalue(execute(conn, queryTemp), 0, 0) == '0') {
                cout << "Tentativi per accedere esauriti: non e' possibile eseguire la query\n\n";
                break;
            }
            sprintf(queryTemp, query[5], data, ora, ora, mail);
            printQuery(execute(conn, queryTemp));
            break;
        default:
            printQuery(execute(conn, query[q - 1]));
            break;
        }
        system("pause");
    }

    PQfinish(conn);
}
