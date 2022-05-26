DROP TABLE IF EXISTS Casinò CASCADE;

CREATE TABLE Casinò (
    IDCasinò integer NOT NULL,
    Nome varchar(40) NOT NULL,
    Via varchar(30) NOT NULL,
    CAP varchar(6) NOT NULL,
    Provincia varchar(2) NOT NULL,
    Stato varchar(2) NOT NULL,
    PRIMARY KEY (IDCasinò)
);

DROP TABLE IF EXISTS Ruoli CASCADE;

CREATE TABLE Ruoli (
    IDRuolo integer NOT NULL,
    Nome varchar(20) NOT NULL,
    Descrizione varchar(400),
    Salario MONEY,
    PRIMARY KEY (IDRuolo)
);

DROP TABLE IF EXISTS Personale CASCADE;

CREATE TABLE Personale (
    IDPersonale integer NOT NULL UNIQUE,
    CF varchar(16) NOT NULL,
    Nome varchar(20) NOT NULL,
    Cognome varchar(20),
    Contatto varchar(20) NOT NULL,
    Via varchar(30) NOT NULL,
    CAP varchar(6) NOT NULL,
    Provincia varchar(2) NOT NULL,
    Stato varchar(2) NOT NULL,
    IDRuolo integer NOT NULL,
    IDCasinò integer NOT NULL,
    PRIMARY KEY (IDPersonale),
    FOREIGN KEY (IDRuolo) REFERENCES Ruoli(IDRuolo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDCasinò) REFERENCES Casinò(IDCasinò) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS Sale CASCADE;
DROP TYPE IF EXISTS tipo_sale CASCADE;

CREATE TYPE tipo_sale AS ENUM ('Gambling', 'Ristoro', 'Congressi');

CREATE TABLE Sale (
    Numero integer NOT NULL UNIQUE,
    Nome varchar(20) NOT NULL UNIQUE,
    Posizione varchar(20) NOT NULL,
    Tipo tipo_sale NOT NULL,
    IDCasinò integer NOT NULL,
    PRIMARY KEY (Nome, Numero),
    FOREIGN KEY (IDCasinò) REFERENCES Casinò(IDCasinò) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS Dirige CASCADE;
CREATE TABLE Dirige(
    IDSala integer NOT NULL UNIQUE,
    IDPersonale integer NOT NULL UNIQUE,
    PRIMARY KEY (IDSala, IDPersonale),
    FOREIGN KEY (IDSala) REFERENCES Sale(Numero) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDPersonale) REFERENCES Personale(IDPersonale) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS Giochi CASCADE;

CREATE TABLE Giochi (
    IDGioco integer NOT NULL,
    Tipo varchar(25) NOT NULL,
    Nome varchar(25) NOT NULL,
    Descrizione varchar(500),
    PRIMARY KEY (IDGioco)
);

DROP TABLE IF EXISTS Postazioni CASCADE;

CREATE TABLE Postazioni (
    Numero integer NOT NULL,
    Nome varchar(15) NOT NULL,
    NomeSala varchar(20) NOT NULL,
    NumeroSala integer NOT NULL,
    IDGioco integer NOT NULL, 
    PRIMARY KEY (Numero),
    FOREIGN KEY (NomeSala) REFERENCES Sale(Nome) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (NumeroSala) REFERENCES Sale(Numero) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDGioco) REFERENCES Giochi(IDGioco) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS Lavora CASCADE;

CREATE TABLE Lavora (
    NumeroPs integer NOT NULL,
    IDPersonale integer NOT NULL,
    Ora_Inizio TIMESTAMP NOT NULL,
    Ora_Fine TIMESTAMP NOT NULL,
    PRIMARY KEY (NumeroPs,IDPersonale,Ora_Inizio),
    FOREIGN KEY (NumeroPs) REFERENCES Postazioni(Numero) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDPersonale) REFERENCES Personale(IDPersonale) ON UPDATE CASCADE ON DELETE CASCADE,
    check (Ora_Fine > Ora_Inizio)
);

DROP TABLE IF EXISTS Clienti CASCADE;

CREATE TABLE Clienti (
    IDCliente integer NOT NULL,
    CF varchar(16) NOT NULL,
    Nome varchar(20) NOT NULL,
    Cognome varchar(20) NOT NULL,
    Contatto varchar(20),
    Via varchar(30) NOT NULL,
    CAP varchar(6) NOT NULL,
    Provincia varchar(2) NOT NULL,
    Stato varchar(2) NOT NULL,
    Saldo MONEY DEFAULT 0 NOT NULL,
    PRIMARY KEY (IDCliente)
);

DROP TABLE IF EXISTS ha_clienti CASCADE;

CREATE TABLE ha_clienti (
    IDCliente integer NOT NULL,
    IDCasinò integer NOT NULL,
    PRIMARY KEY (IDCliente,IDCasinò),
    FOREIGN KEY (IDCliente) REFERENCES Clienti(IDCliente) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDCasinò) REFERENCES Casinò(IDCasinò) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS Tornei CASCADE;

CREATE TABLE Tornei (
    IDTorneo integer NOT NULL,
    Nome varchar(20) NOT NULL,
    DataTorneo DATE NOT NULL,
    BuyIN MONEY NOT NULL,
    Premio MONEY NOT NULL,
    NomeSala varchar(10) NOT NULL,
    NumeroSala integer NOT NULL,
    IDGioco integer NOT NULL,
    PRIMARY KEY (IDTorneo),
    FOREIGN KEY (NomeSala) REFERENCES Sale(Nome) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (NumeroSala) REFERENCES Sale(Numero) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDGioco) REFERENCES Giochi(IDGioco) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS Match CASCADE;

CREATE TABLE Match (
    IDMatch integer NOT NULL,
    IsFinal boolean NOT NULL,
    Ora TIME NOT NULL,
    IDTorneo integer NOT NULL,
    PRIMARY KEY (IDMatch),
    FOREIGN KEY (IDTorneo) REFERENCES Tornei(IDTorneo) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO Match(IDMatch, IsFinal,Ora,IDTorneo)
VALUES
    (1, false, '15:00:00',1),
    (2, true, '18:00:00',1);

DROP TABLE IF EXISTS Disputano CASCADE;

CREATE TABLE Disputano (
    IDMatch integer NOT NULL,
    IDCliente integer NOT NULL,
    SaldoMano integer NOT NULL,
    FOREIGN KEY (IDMatch) REFERENCES Match(IDMatch) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDCliente) REFERENCES Clienti(IDCliente) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (IDMatch,IDCliente)
);

DROP TABLE IF EXISTS Regole CASCADE;

CREATE TABLE Regole (
    IDRegola integer NOT NULL,
    Nome varchar(40) NOT NULL,
    Descrizione varchar(300) NOT NULL,
    Penalità varchar(200),
    PRIMARY KEY (IDRegola)
);

DROP TABLE IF EXISTS Regolamento CASCADE;

CREATE TABLE Regolamento (
    IDGioco integer NOT NULL,
    IDRegola integer NOT NULL,
    PRIMARY KEY (IDGioco,IDRegola),
    FOREIGN KEY (IDGioco) REFERENCES Giochi(IDGioco) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDRegola) REFERENCES Regole(IDRegola) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS Transazioni CASCADE;
DROP TYPE IF EXISTS tipo_tx CASCADE;

CREATE TYPE tipo_tx AS ENUM ('Vincita', 'Perdita', 'Ricarica');

CREATE TABLE Transazioni (
    IDTx integer NOT NULL,
    Tipo tipo_tx NOT NULL,
    TimestampTX TIMESTAMP NOT NULL,
    Importo integer NOT NULL,
    IDPostazione integer NOT NULL,
    IDCliente integer NOT NULL,
    PRIMARY KEY (IDTx),
    FOREIGN KEY (IDPostazione) REFERENCES Postazioni(Numero) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDCliente) REFERENCES Clienti(IDCliente) ON UPDATE CASCADE ON DELETE CASCADE
);