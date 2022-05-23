#include <string>
#include <iostream>
#include <iomanip>
#include "./dependencies/include/libpq-fe.h"

using namespace std;

#define PG_HOST "127.0.0.1"
#define PG_USER "postgres"
#define PG_PASS "password"
#define PG_PORT 5432
#define PG_DB "test"

class Query {
	
	string _name;
	string _query;
	int _n_params;
	char** params;
	char** _def_params;
	PGresult *result;
	PGresult *stmt;
	
	void getParams() {
		if(_n_params == 0) return;
		
		params = (char**)::operator new(_n_params);
		
		cout << "Inserisci "<< _n_params << " parametro(i): \n";
		for(int i=0; i<_n_params; ++i) { 
			params[i] = new char[30];
			cin >> params[i];
		}
	}
	
public: 

	Query(string name, string query, int n_params, PGconn* conn, char** def_params=0) 
		: _name(name), _query(query), _n_params(n_params), params(0), result(0), stmt(0), _def_params(def_params)
	{
		stmt = PQprepare(conn, _name.c_str(), _query.c_str(), _n_params, 0);
		if (PQresultStatus(stmt) != 1) 
		{ 
			cout << "Risultati inconsistenti in preparazione!" << PQerrorMessage(conn) << endl; 
			PQclear(stmt); 
			stmt = 0;
			exit(1);
		}
	}
	
	~Query() {
		PQclear(stmt);
		PQclear(result);
		if(params!=0) delete[] params;
	}
	
	bool execute(PGconn* conn, bool use_def_params=false) 
	{
		if(!(use_def_params && _def_params)) {
			cout << "\nEseguendo: \n" << _name << "\n\n";
			getParams();
		} else {
			cout << "\nEseguendo: \n" << _name << "\n\ncon parametro(i):  ";
			for(int i=0; i<_n_params; ++i) { 
				cout << _def_params[i] << "; ";
			}
			cout << '\n';
		}
		
		if(result != 0) {
			PQclear(result);
			result=0;
		}

		result = PQexecPrepared(conn, _name.c_str(), _n_params, use_def_params && _def_params ? _def_params : params, 0, 0, 0);
		
		if (PQresultStatus(result) != PGRES_TUPLES_OK) 
		{ 
			cout << "\nRisultati inconsistenti in esecuzione!" << PQerrorMessage(conn) << endl; 
			PQclear(result); 
			result = 0;
			return false;
		}
		else return true;
	}
	
	void print()
	{
		if(result==0) return;
		
		int tuple = PQntuples(result);
		int campi = PQnfields(result);
		
		cout << "\nRisultato: \n\n";
		
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
};

int selectQuery() {
	int a=0;
	while(a==0) {
		cout << "Inserire il numero della query desiderata (-1 per uscire): ";
		if(!(cin >> a)) {
			cin.clear();
			cin.ignore(10000,'\n');
			cout << "invalid input error try again \n";
		}
	}
	return a;
}

int main(int argc, char** argv) {
	char conninfo[250];
	sprintf(conninfo , "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER , PG_PASS , PG_DB , PG_HOST , PG_PORT);
	
	PGconn* conn;
	conn = PQconnectdb(conninfo);
	
	cout << '\n';
	if(PQstatus(conn) != CONNECTION_OK) { 
		cout << "Errore di connessione \n\n" << PQerrorMessage(conn); 
		PQfinish(conn); 
		exit(1);
	} else { 
		cout << "Connessione avvenuta correttamente \n\n";
	}
	
	char* p1="DNK192";
	Query q1("1 - Mostrare la classifica di un votante(varchar(6)) nella finale del 2019 \n default: televoto danimarca(DNK192), parametri esempio: giuria italia(ITA191), televoto francia(FRA192)", 
	         "select c.titolo,c.nazione,punteggio from voto as v join canzone as c on v.canzone=c.codice where votante=$1::varchar(6) and serata='2019-05-16' order by punteggio desc", 1, conn, &p1);
	q1.execute(conn, true); q1.print();
	
	char* p2="ITA";
	Query q2("2 - Stampare le nazioni che hanno sia dato che ricevuto 12 punti da una nazione durante le finali \n default italia(ITA), parametri esempio: russia(RUS), cipro(CYP), belgio(BEL)", 
	         "select distinct c.nazione from voto as v join votante as vt on v.votante=vt.id join canzone as c on v.canzone=c.codice where vt.nazione=$1::varchar(3) and v.punteggio=12 and c.nazione IN (select distinct vt.nazione from voto as v join serata as s on v.serata=s.data_serata join canzone as c on v.canzone=c.codice join votante as vt on v.votante=vt.id where c.nazione=$1::varchar(3) and v.punteggio=12 and s.codice=3)", 1, conn, &p2);
	q2.execute(conn, true); q2.print();

	Query q3("3 - Mostrare, per ogni canzone vincitrice, il titolo, i punti totali ricevuti durante la finale e l'anno di partecipazione. Ordinare i risultato per punti ricevuti", 
	         "select c.titolo, punti,c.partecipazione from (select v.canzone, sum(v.punteggio) as punti from canzone as c join voto as v on c.codice=v.canzone join serata as s on s.data_serata=v.serata and s.codice=3 join esc on esc.vittoria=c.codice group by v.canzone) as vp join canzone as c on c.codice=vp.canzone order by punti desc", 0, conn);
	q3.execute(conn, true); q3.print();
	
	Query q4("4 - Tra le canzoni vincitrici, mostrare quale è stata cantata per prima, nel senso di ora dell’esibizione all’interno della finale", 
	         "select titolo,ora_inizio from vit_es where ora_inizio in(select min(ora_inizio) from vit_es)", 0, conn);
	q4.execute(conn, true); q4.print();
	
	Query q5("5 - Tra le canzoni interpretate da almeno 3 artisti, mostrare quale ha ricevuto piu' punti in finale. mostrare anche il cognome,nome,nazionalità degli artisti che la interpretano.", 
	         "select cognome,nome,nazionalita,c.titolo from artista as a join interpretazione as i on a.codice_fiscale=i.artista join pnt_3_art as pnt on pnt.codice=i.canzone join canzone as c on i.canzone=c.codice where pnt.sum in (select max(sum)from pnt_3_art)", 0, conn);
	q5.execute(conn, true); q5.print();
	
	Query q6("6 - Seleziona tutti gli artisti che hanno fatto la prima ed unica apparizione all'ESC da soli(non in gruppo) e non sono mai apparsi all'ESC con un altro ruolo (Conduttore, Ospite, Spokeperson, Curatore)", 
	         "select codice_fiscale, nome_arte, nome, cognome from Artista A join Interpretazione I on A.codice_fiscale = I.artista where I.nome_gruppo is null and A.codice_fiscale not in (select codice_fiscale from Interpretazione I1 where I1.artista= I.artista and I1.canzone <> I.canzone) and A.codice_fiscale not in ((select codice_fiscale from Conduttore ) union (select codice_fiscale from Ospite) union (select codice_fiscale from Collaboratore) union (select codice_fiscale from Spokeperson))", 0, conn);
	q6.execute(conn, true); q6.print();

	bool end=false;
	while(end!=true) {
		switch(selectQuery()) {
			case -1:
				end=true;
				break;
			case 1:
				q1.execute(conn);
				q1.print();	
				break;
			case 2:
				q2.execute(conn);
				q2.print();	
				break;
			case 3:
				q3.execute(conn);
				q3.print();	
				break;
			case 4:
				q4.execute(conn);
				q4.print();	
				break;
			case 5:
				q5.execute(conn);
				q5.print();	
				break;
			case 6:
				q6.execute(conn);
				q6.print();	
				break;
			default: 
				cout << "invalid input number \n";
		}
	}
	
	PQfinish(conn);
	return 0;
}