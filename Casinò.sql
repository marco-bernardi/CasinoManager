DROP TABLE IF EXISTS Casinò CASCADE;

CREATE TABLE Casinò (
    IDCasinò integer NOT NULL,
    Nome varchar(40),
    Via varchar(30),
    CAP varchar(6),
    Provincia varchar(2),
    Stato varchar(2),
    PRIMARY KEY (IDCasinò)
);

INSERT INTO Casinò(IDCasinò, Nome, Via, CAP, Provincia, Stato)
VALUES
    ('1', 'Casinò di Venezia','Cannaregio, 2040','30121 ','VE','IT'),
    ('2', 'Casinò di Venezia Ca'' Noghera','Via Paliaga, 4/8','30173','VE','IT');

DROP TABLE IF EXISTS Ruoli CASCADE;

CREATE TABLE Ruoli (
    IDRuolo integer NOT NULL,
    Nome varchar(20) NOT NULL,
    Descrizione varchar(400) NOT NULL,
    Salario varchar(8) NOT NULL,
    PRIMARY KEY (IDRuolo)
);

INSERT INTO Ruoli(IDRuolo, Nome, Descrizione, Salario)
VALUES
    ('1', 'Direttore','Gestisce la struttura', 5000),
    ('2', 'Controllore di Sala','Gestisce i turni dei croupier e verifica la corretta esecuzione delle attività', 3000),
    ('3', 'Croupier','Si occupa di accettare le scommesse dei giocatori, servire al tavolo da gioco, controllare la liceità delle puntate dei giocatori e pagare le vincite.', 2000),
    ('4', 'Inserviente', 'Si occupa della pulizia della struttura', 1500),
    ('5', 'Barista','Serve i clienti ai punti ristoro della struttura', 2000),
    ('6', 'Sicurezza', 'Si occupa della sicurezza del casinò', 2500);
    

DROP TABLE IF EXISTS Personale CASCADE;

CREATE TABLE Personale (
    IDPersonale integer NOT NULL UNIQUE,
    CF varchar(16) NOT NULL,
    Nome varchar(20) NOT NULL,
    Cognome varchar(20) NOT NULL,
    Contatto varchar(20) NOT NULL,
    Via varchar(30) NOT NULL,
    CAP varchar(6) NOT NULL,
    Provincia varchar(2) NOT NULL,
    Stato varchar(2) NOT NULL,
    IDRuolo integer NOT NULL,
    IDCasinò integer NOT NULL,
    PRIMARY KEY (CF),
    FOREIGN KEY (IDRuolo) REFERENCES Ruoli(IDRuolo) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDCasinò) REFERENCES Casinò(IDCasinò) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO Personale(IDPersonale,CF, Nome, Cognome, Contatto, Via, CAP, Provincia, Stato, IDRuolo, IDCasinò)
VALUES
    (1,'LPPSFO65A45F558R', 'Sofia','Lo Papa', '3902816714', 'Via Don Gianola, 13','20024','MI','IT','4','1'),
    (2,'CCLRHD73P44E615N', 'Orchidea','Auccello', '0425927530', 'Via Altichieri Da Zevio, 1','35132','PD','IT','4','1'),
    (3,'DVNMDL71C44G107H', 'Maddalena','Dovana', '0439441900', 'Via Delle Corniole, 4','38030','TN','IT','4','1'),
    (4,'GRSSRG87P25H511L', 'Sergio','Garsone', '3735871836', 'Via Delle Villette, 15','57128','LI','IT','4','1'),
    (5,'VVNDCM58A28H019O', 'Decimo','Viviani', '3736082147', 'Via Amerigo Vespucci, 19','24040','BG','IT','4','1'),
    (6,'STCDLF67S13E911M', 'Adolfo','Sticchiotti', '3701826472', 'Via Melvin Jones, 10','00049','RM','IT','4','1'),
    (7,'MNCSNS81H03G979J', 'Stanislao','Stanislao', '3137103658', 'Via Cavour, 2','17055','SV','IT','4','1'),
    (8,'GLLLRD76P51I494O', 'Alfreda','Gallamini', '3701871436', '	Via Dei Pioppi, 43','26039','CR','IT','4','1'),
    (9,'BRGRNG59A08D360E', 'Arcangelo','Brughi', '3736482032', 'Via Del Salciolo, 2','59100','PO','IT','4','1'),
    (10,'MNLLVO97D62G613P', 'Olivia','Manelfi', '3791476032', 'Viale Dante Alighieri, 40','57028','LI','IT','4','1'),

    (11,'BRNRNS70L55F158E', 'Ortensia','Brandileone', '3730825471', 'Via Sabaudia, 8','20124','MI','IT','4','2'),
    (12,'LTGRNT83H60H472M', 'Renata','Leitgeb', '3903258714', 'Via Giuseppe Dossetti, 10','42048','RE','IT','4','2'),
    (13,'CRCLVC63R57H507F', 'Ludovica','Cariccio', '3791476032', 'Via San Rocco, 62','70010','BA','IT','4','2'),
    (14,'PZZPRN73M43E606O', 'Petronilla','Pozzolo', '3791476032', 'Via Cardinale Massimi, 8','00167','RM','IT','4','2'),
    (15,'BSSMRA91E70I098W', 'Mara','Bossardi', '3701821476', '	Via Manarola, 4','43126','PR','IT','4','2'),

    (16,'BSSMRA91E70I096W', 'Iona', 'Iannelli', '173-712-7666', '145 Holmberg Parkway', '37142', 'VN', 'IT', 2, 1),
    (17,'BSSMRA91E70I097W', 'Haley', 'Beaney', '941-352-0620', '9 7th Street', '35129', 'VN', 'IT', 2, 1),
    (18,'BSSMRA91E70I095W', 'Ranee', 'Deveral', '442-429-1805', '3132 Onsgard Hill', '37142', 'VN', 'IT', 2, 1),
    (19,'BSSMRA91E70I048W', 'Mada', 'Haselden', '457-443-3057', '97942 Brown Terrace', '35129', 'VN', 'IT', 2, 1),

    (20,'BSSMRA91E70I038W', 'Lila', 'Ashington', '855-183-3458', '7 6th Lane', '35129', 'VN', 'IT', 3, 1),
    (21,'BSSMRA91E70I078W', 'Hardy', 'Lyngsted', '838-351-7600', '98 Westend Point', '10129', 'PM', 'IT', 3, 1),
    (22,'BSSMRA91E70I099W', 'Gabey', 'Roo', '717-383-5286', '61895 Mesta Drive', '35141', 'VN', 'IT', 3, 1),
    (23,'BSSMRA91E70I079W', 'Billy', 'Orcas', '546-519-3126', '32052 Sunbrook Parkway', '40128', 'ER', 'IT', 3, 1),
    (24,'BTTMRE91E70I098W', 'Zia', 'Durdle', '701-233-2068', '5747 Colorado Lane', '30175', 'VN', 'IT', 3, 1),
    (25,'BRTMRE81E70I198W','Clareta', 'Blann', '176-291-4228', '81123 Nelson Park', '10141', 'PM', 'IT', 3, 1); 
    
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

INSERT INTO Sale(Numero, Nome, Posizione, Tipo, IDCasinò)
VALUES
    (1, 'Sala Verde','Piano Terra', 'Gambling', 1),
    (2, 'Sala Rossa','Piano Terra', 'Gambling', 1),
    (3, 'Sala Gialla','Piano Terra', 'Gambling', 1),
    (4, 'Ristoro 1','Piano Terra', 'Ristoro', 1),
    (5, 'Ristoro 2','Primo Piano', 'Ristoro', 1),
    (6, 'Sala Elite','Primo Piano', 'Congressi', 1),
    (7, 'Sala Master','Primo Piano', 'Congressi', 1);


DROP TABLE IF EXISTS Giochi CASCADE;

CREATE TABLE Giochi (
    IDGioco integer NOT NULL,
    Tipo varchar(25) NOT NULL,
    Nome varchar(25) NOT NULL,
    Descrizione varchar(500) NOT NULL,
    PRIMARY KEY (IDGioco)
);

INSERT INTO Giochi(IDGioco, Tipo, Nome, Descrizione)
VALUES
    (1, 'Poker','Texas hold ''em', 'Il gioco di poker più famoso del mondo sia dei casinò'),
    (2, 'Blackjack','Normale', 'Il blackjack è un gioco d''azzardo di carte che si svolge tra il banco, e i giocatori. Vincono i giocatori che realizzano un punteggio più alto del banco e non superiore a 21.'),
    (3, 'Roulette','Fair Roulette', 'Gioco d''azzardo in cui i giocatori scommettono su quale scomparto numerato rosso o nero di una ruota girevole cadrà la pallina'),
    (4, 'Roulette','Roulette Francese', 'Gioco d''azzardo in cui i giocatori scommettono su quale scomparto numerato rosso o nero di una ruota girevole cadrà la pallina'),
    (5, 'Slot Machine','Tipo 1', 'Dispositivo elettronico che permette di vincere'),
    (6, 'Punto Banco','Normale', 'Il giocatore sfida il banco in un gioco di carte'),
    (7, 'Punto Banco','Carte in mano', 'Il giocatore sfida il banco in un gioco di carte');



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

INSERT INTO Postazioni(Numero, Nome, NomeSala, NumeroSala, IDGioco)
VALUES
    (1, 'FR1','Sala Verde', 1, 3),
    (2, 'FR2','Sala Rossa', 2, 3),
    (3, 'AR1','Sala Gialla', 3, 4),
    (4, 'AR2','Sala Verde', 1, 4),
    (5, 'PK1','Sala Rossa', 2, 1),
    (6, 'PK2','Sala Rossa', 2, 1),
    (7, 'SLOT1','Sala Gialla', 2, 5),
    (8, 'SLOT2','Sala Gialla', 2, 5),
    (9, 'SLOT3','Sala Gialla', 2, 5),
    (10, 'SLOT4','Sala Gialla', 2, 5),
    (11, 'SLOT5','Sala Gialla', 2, 5);



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

INSERT INTO Lavora(NumeroPS, IDPersonale, Ora_Inizio, Ora_Fine)
VALUES
-- Prima postazione
    (1, 20,'2020-05-1 10:00:00', '2022-05-1 14:00:00'),
    (1, 20,'2020-06-1 18:00:00', '2022-06-1 22:00:00'),
    (1, 20,'2020-07-1 14:00:00', '2022-07-1 18:00:00'),

    (1, 21,'2020-05-1 14:00:00', '2022-05-1 18:00:00'),
    (1, 21,'2020-06-1 10:00:00', '2022-06-1 14:00:00'),
    (1, 21,'2020-07-1 18:00:00', '2022-07-1 22:00:00'),
-- Seconda Postazione
    (2, 22,'2020-05-1 10:00:00', '2022-05-1 14:00:00'),
    (2, 22,'2020-06-1 18:00:00', '2022-06-1 22:00:00'),
    (2, 22,'2020-07-1 14:00:00', '2022-07-1 18:00:00'),

    (2, 23,'2020-05-1 14:00:00', '2022-05-1 18:00:00'),
    (2, 23,'2020-06-1 10:00:00', '2022-06-1 14:00:00'),
    (2, 23,'2020-07-1 18:00:00', '2022-07-1 22:00:00'),    
-- Terza Postazione
    (3, 24,'2020-05-1 10:00:00', '2022-05-1 14:00:00'),
    (3, 24,'2020-06-1 18:00:00', '2022-06-1 22:00:00'),
    (3, 24,'2020-07-1 14:00:00', '2022-07-1 18:00:00'),

    (3, 25,'2020-05-1 14:00:00', '2022-05-1 18:00:00'),
    (3, 25,'2020-06-1 10:00:00', '2022-06-1 14:00:00'),
    (3, 25,'2020-07-1 18:00:00', '2022-07-1 22:00:00');  

DROP TABLE IF EXISTS Clienti CASCADE;

CREATE TABLE Clienti (
    IDCliente integer NOT NULL,
    CF varchar(16) NOT NULL,
    Nome varchar(20) NOT NULL,
    Cognome varchar(20) NOT NULL,
    Contatto varchar(20) NOT NULL,
    Via varchar(30) NOT NULL,
    CAP varchar(6) NOT NULL,
    Provincia varchar(2) NOT NULL,
    Stato varchar(2) NOT NULL,
    Saldo integer NOT NULL,
    PRIMARY KEY (IDCliente)
);

INSERT INTO Clienti(IDCliente,CF, Nome, Cognome, Contatto, Via, CAP, Provincia, Stato, Saldo)
VALUES
    (1,'NCGZNN97T44I570X', 'Kaycee', 'Geist', '778 697 0266', '63185 Starling Place', '30132', 'VN', 'FV', 35425),
    (2,'DLFXWX64L47H825C', 'Billie', 'Cutmere', '337 200 9793', '8711 Dexter Alley', '35129', 'VN', 'VN', 2841),
    (3,'FSRKRD37D65B259C', 'Zilvia', 'Ellicott', '265 665 1098', '974 Sugar Way', '35141', 'VN', 'VN', 16160),
    (4,'CSDVNC98H15F184Z', 'Selina', 'Rudgard', '153 423 4333', '8 Sunbrook Pass', '37129', 'VN', 'VN', 17204),
    (5,'JCKCHY52M18M055W', 'Ivan', 'Heatherington', '475 136 5639', '0775 Granby Junction', '37129', 'VN', 'FV', 19347),
    (6,'VDYZHG82E57B484I', 'Laure', 'Puddephatt', '135 375 1337', '03 Annamark Trail', '34141', 'FV', 'VN', 12258),
    (7,'LJWMRW92H30H376B', 'Alma', 'Guidotti', '394 391 8550', '9 Ruskin Street', '34141', 'FV', 'VN', 14475),
    (8,'BMWZDS63T06M209N', 'Mahmoud', 'Wybron', '457 302 9067', '008 Warrior Center', '34141', 'FV', 'VN', 38718),
    (9,'PZPCDV50L10C533B', 'Karilynn', 'Bester', '157 523 6400', '7 American Ash Lane', '30175', 'VN', 'VN', 8814),
    (10,'FVBCDQ99P58E074H', 'Wylma', 'Lourens', '331 804 3290', '8318 Mifflin Avenue', '30175', 'VN', 'VN', 3669),
    (11,'NSPNFU44C67L107A', 'Melodee', 'Sleeman', '205 224 2656', '4 Schlimgen Lane', '34141', 'FV', 'VN', 14612),
    (12,'FRGBDF92A58D411P', 'Breena', 'Cheesworth', '152 488 6494', '25 Arkansas Drive', '37142', 'VN', 'FV', 31263),
    (13,'ZZZDXF51B61I339H', 'Andros', 'Main', '288 115 2665', '7 Clove Point', '37129', 'VN', 'VN', 14428),
    (14,'PCTSGP41M63A996X', 'Kata', 'Bonner', '942 993 5266', '6 Badeau Trail', '37142', 'VN', 'VN', 18483),
    (15,'CBBKNM37D21B490N', 'Ignaz', 'Sheddan', '605 457 9913', '4 Spaight Crossing', '37129', 'VN', 'VN', 5031),
    (16,'YTXCYR63R50H017N', 'Trueman', 'McGlashan', '684 395 4770', '40322 Veith Pass', '30132', 'VN', 'VN', 13601),
    (17,'BDPBZW31P45E464E', 'Melanie', 'Tash', '756 814 3544', '47 Rieder Avenue', '35129', 'VN', 'FV', 39939),
    (18,'YDJXNJ58H12Z149M', 'Del', 'Boar', '261 412 0535', '44415 Corscot Plaza', '34141', 'FV', 'VN', 3122),
    (19,'BNSTCW81E60I429R', 'Lindon', 'Ricson', '470 917 3224', '00647 Delaware Road', '37142', 'VN', 'VN', 22491),
    (20,'CSHKSE29B08F290P', 'Tab', 'Doull', '930 445 7929', '8 Starling Point', '34129', 'FV', 'VN', 10357),
    (21,'VVHDRB28A06F221X', 'Gaelan', 'Cherry', '439 953 7278', '45 Grover Center', '30175', 'VN', 'VN', 15426),
    (22,'BBDFYI91S62L777M', 'Theodosia', 'De Robertis', '750 688 1705', '4612 Elmside Point', '35141', 'VN', 'VN', 22855),
    (23,'ZFNFPY46M13B081B', 'Francklyn', 'Stiegar', '681 515 1832', '6 Eliot Street', '35129', 'VN', 'VN', 11161),
    (24,'LCZLTZ31R27H195N', 'Timmi', 'Basil', '499 169 3505', '4488 Tony Lane', '35141', 'VN', 'VN', 6223),
    (25,'SVDHDZ67E23E629F', 'Nanon', 'Brimilcombe', '794 643 0370', '13 Dayton Place', '30175', 'VN', 'VN', 33287),
    (26,'BZEKKF54B18E814R', 'Barthel', 'Plevin', '885 838 1378', '2321 Corscot Road', '37129', 'VN', 'VN', 9546),
    (27,'BGNHPP36T16G751S', 'Ellary', 'Ruggier', '751 441 9975', '421 Vermont Parkway', '37129', 'VN', 'VN', 31530),
    (28,'WQYDRV69D44B927X', 'Bella', 'Crampin', '769 743 5031', '91920 Rigney Pass', '34129', 'FV', 'VN', 4438),
    (29,'RDSGMT68H30I415L', 'Margareta', 'Holleran', '317 669 5023', '4342 Mcguire Circle', '35129', 'VN', 'VN', 39164),
    (30,'RMMDGJ46C26L272A', 'Garfield', 'Croad', '842 649 6723', '10619 Center Way', '34141', 'FV', 'VN', 19528),
    (31,'RMMDGJ46C26L272A', 'Mela', 'Yurenin', '562 422 1566', '26088 Forest Run Junction', '30175', 'VN', 'VN', 18620),
    (32,'TBXMGM31M06L669R', 'Rory', 'Heffernan', '483 384 3011', '18 Di Loreto Circle', '34129', 'FV', 'FV', 20466),
    (33,'JREPDI68T18I688C', 'Ebba', 'Driscoll', '874 700 7196', '63948 Ridge Oak Point', '30175', 'VN', 'VN', 18399),
    (34,'TBRRSV57E68F718N', 'Walsh', 'Strachan', '641 461 1477', '82 Cardinal Junction', '37142', 'VN', 'VN', 1181),
    (35,'RGMZTT69P62A666I', 'Thebault', 'Duplain', '387 837 4814', '3 Delaware Road', '35141', 'VN', 'VN', 35325),
    (36,'ZSFNNL66S42F498A', 'Tabatha', 'Enrdigo', '613 127 7926', '95278 Killdeer Center', '34141', 'FV', 'VN', 35496),
    (37,'TFGBTS43E10I644W', 'Gerta', 'Becker', '702 554 4660', '2 Walton Avenue', '35141', 'VN', 'VN', 1131),
    (38,'SQVNLS95P26I941W', 'Dewain', 'Skippen', '409 288 1274', '3 Sage Center', '35141', 'VN', 'VN', 22162),
    (39,'SGBNAA97P52L603C', 'Nicky', 'Desvignes', '475 491 9648', '6 Fairfield Trail', '35129', 'VN', 'VN', 13883),
    (40,'GGSTRB99B44E932H', 'Rafa', 'Neles', '709 446 9288', '019 Prairie Rose Lane', '34141', 'FV', 'VN', 19711),
    (41,'KPYDJO99P59A519R', 'Randell', 'Volleth', '466 595 5676', '05085 Moulton Street', '30175', 'VN', 'VN', 21550),
    (42,'LRQHCM96D15F190K', 'Krishna', 'Althorp', '925 696 7944', '5866 Pearson Court', '35141', 'VN', 'VN', 26072),
    (43,'PVGFPM44A16E549B', 'Rhona', 'Normavell', '606 212 7215', '2 Myrtle Way', '30132', 'VN', 'VN', 30158),
    (44,'NVZHHN68D45H675I', 'Maure', 'Bernardez', '181 107 4412', '802 Moulton Parkway', '37142', 'VN', 'FV', 36562),
    (45,'NVVLWW51L05H361B', 'Gawen', 'Ramirez', '207 723 6141', '8711 Sachs Terrace', '35129', 'VN', 'VN', 25350),
    (46,'BSHJXV41T53D344T', 'Abram', 'Treleaven', '350 128 7021', '9241 Donald Place', '37129', 'VN', 'FV', 10291),
    (47,'PZMGJE42M11H621B', 'Kinnie', 'Shillabeer', '544 312 2797', '528 Surrey Road', '37129', 'VN', 'VN', 6886),
    (48,'RCLHTC94T43H384O', 'Will', 'Ramalho', '994 874 9844', '6816 Di Loreto Circle', '34129', 'FV', 'FV', 11481),
    (49,'MNPTTL78D23G317U', 'Adolph', 'Steptow', '752 479 3206', '44 Derek Parkway', '35141', 'VN', 'VN', 16672),
    (50,'YJTDTL64S27I448J', 'Christel', 'Divill', '744 514 9270', '274 Birchwood Plaza', '30175', 'VN', 'VN', 17909);

DROP TABLE IF EXISTS ha_clienti CASCADE;

CREATE TABLE ha_clienti (
    IDCliente integer NOT NULL,
    IDCasinò integer NOT NULL,
    PRIMARY KEY (IDCliente,IDCasinò),
    FOREIGN KEY (IDCliente) REFERENCES Clienti(IDCliente) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDCasinò) REFERENCES Casinò(IDCasinò) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO ha_clienti(IDCliente, IDCasinò)
VALUES
    (1,1),   
    (2,1),   
    (3,1),   
    (4,1),   
    (5,1),   
    (6,1),   
    (7,1),   
    (8,1),   
    (9,1),  
    (10,1),
    (11,1),
    (12,1),
    (13,1),
    (14,1),
    (15,1),
    (16,1),
    (17,1),
    (18,1),
    (19,1),
    (20,1),
    (21,1),
    (22,1),
    (23,1),
    (24,1),
    (25,1),
    (26,1),
    (27,1),
    (28,1),
    (29,1),
    (30,1),
    (31,1),
    (32,1),
    (33,1),
    (34,1),
    (35,1),
    (36,1),
    (37,1),
    (38,1),
    (39,1),
    (40,1),
    (41,1),
    (42,1),
    (43,1),
    (44,1),
    (45,1),
    (46,1),
    (47,1),
    (48,1),
    (49,1),
    (19,2),
    (20,2),
    (21,2),
    (22,2),
    (23,2),
    (24,2),
    (25,2),
    (26,2),
    (27,2),
    (28,2),
    (29,2),
    (30,2),
    (31,2),
    (32,2),
    (33,2),
    (34,2),
    (35,2),    
    (50,1);

DROP TABLE IF EXISTS Tornei CASCADE;

CREATE TABLE Tornei (
    IDTorneo integer NOT NULL,
    Nome varchar(20) NOT NULL,
    DataTorneo DATE NOT NULL,
    BuyIN integer NOT NULL,
    Premio integer NOT NULL,
    NomeSala varchar(10) NOT NULL,
    NumeroSala integer NOT NULL,
    IDGioco integer NOT NULL,
    PRIMARY KEY (IDTorneo),
    FOREIGN KEY (NomeSala) REFERENCES Sale(Nome) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (NumeroSala) REFERENCES Sale(Numero) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDGioco) REFERENCES Giochi(IDGioco) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO Tornei(IDTorneo, Nome,DataTorneo,BuyIN,Premio,NomeSala,NumeroSala,IDGioco)
VALUES
    (1,'Italian Poker Tour', '2022-05-15',1000, 50000, 'Sala Rossa', 2,1);

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
    (1, false, '15:00:00',1);

DROP TABLE IF EXISTS Disputano CASCADE;

CREATE TABLE Disputano (
    IDMatch integer NOT NULL,
    IDCliente integer NOT NULL,
    SaldoMano integer NOT NULL,
    FOREIGN KEY (IDMatch) REFERENCES Match(IDMatch) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDCliente) REFERENCES Clienti(IDCliente) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (IDMatch,IDCliente)
);

INSERT INTO Disputano(IDMatch, IDCliente,SaldoMano)
VALUES
    (1, 1, 2000),
    (1, 4, 2000),
    (1, 7, 2000),
    (1, 9, 2000),
    (1, 10, 2000),
    (1, 23, 2000);


DROP TABLE IF EXISTS Regole CASCADE;

CREATE TABLE Regole (
    IDRegola integer NOT NULL,
    Nome varchar(40) NOT NULL,
    Descrizione varchar(300) NOT NULL,
    Penalità varchar(200) NOT NULL,
    PRIMARY KEY (IDRegola)
);

INSERT INTO Regole(IDRegola, Nome, Descrizione,Penalità)
VALUES
    (1, 'Carta Alta','Il principio della carta alta viene utilizzato per determinare quale combinazione è quella vincente a parità di mano, e se non è possibile stabilirlo allora il piatto viene ripartita tra i giocatori, in parti uguali.','Nessuna'),
    (2, 'Coppia','La coppia, nelle regole del poker, è la combinazione vincente di base e più semplice da ottenere, che si verifica quando un giocatore ha in mano due carte dello stesso valore e tre carte diverse e non abbinate.','Nessuna'),
    (3, 'Sorteggio del bottone',' La posizione al tavolo del bottone viene sorteggiata all’inizio del torneo e procede in senso orario ad ogni turno di gioco salvo eccezioni definite al successivo punto 2','Nessuna'),
    (4, 'Split','lo split trasforma una mano in due','Nessuna'),
    (5, 'Raddoppiare','ti permette di raddoppiare la tua scommessa iniziale','Nessuna'),
    (6, 'Resa','ti permette di abbandonare la tua mano e recuperare il 50% della tua scommessa iniziale','Nessuna'),
    (7, 'Numero secco','Puntare su un numero paga 35 a 1.','Nessuna'),
    (8, 'street','La puntata su tre numeri paga 11 a 1.','Nessuna'),
    (9, 'Puntatà massima','Possono essere puntati massimo 3000€','Nessuna');    

DROP TABLE IF EXISTS Regolamento CASCADE;

CREATE TABLE Regolamento (
    IDGioco integer NOT NULL,
    IDRegola integer NOT NULL,
    PRIMARY KEY (IDGioco,IDRegola),
    FOREIGN KEY (IDGioco) REFERENCES Giochi(IDGioco) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (IDRegola) REFERENCES Regole(IDRegola) ON UPDATE CASCADE ON DELETE CASCADE
);

INSERT INTO Regolamento(IDGioco,IDRegola)
VALUES
    (1,1),
    (1,2),
    (1,3),
    (2,4),
    (2,5),
    (2,6),
    (3,7),
    (3,8),
    (3,9);
    


DROP TABLE IF EXISTS Transazione CASCADE;
DROP TYPE IF EXISTS tipo_tx CASCADE;

CREATE TYPE tipo_tx AS ENUM ('Vincita', 'Perdita', 'Ricarica');

CREATE TABLE Transazione (
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

INSERT INTO Transazione(IDTx,Tipo,TimestampTX,Importo,IDPostazione,IDCliente)
VALUES
    (1, 'Vincita',   '2022-05-06 16:46:02', 12976, 7, 10),
    (2, 'Perdita',   '2022-05-02 19:34:20', 12179, 8, 4),
    (3, 'Perdita',   '2022-05-22 22:26:47', 34998, 3, 16),
    (4, 'Vincita',   '2022-04-15 19:25:17', 20482, 1, 22),
    (5, 'Perdita',   '2022-05-22 12:05:51', 45239, 7, 3),
    (6, 'Vincita',   '2022-04-10 14:42:56', 3478, 10, 1),
    (7, 'Vincita',   '2022-06-12 14:56:49', 47475, 4, 30),
    (8, 'Ricarica',  '2022-05-19 12:22:05', 9830, 2, 34),
    (9, 'Perdita',   '2022-06-25 11:34:39', 47344, 4, 25),
    (10, 'Perdita',  '2022-07-02 22:08:02', 34733, 9, 30),
    (11, 'Vincita',  '2022-04-22 16:19:20', 42141, 6, 24),
    (12, 'Ricarica', '2022-04-11 12:55:39', 38996, 10, 17)
    (13, 'Perdita',  '2022-07-03 18:34:49', 36409, 4, 29),
    (14, 'Perdita',  '2022-06-17 19:14:16', 29653, 7, 4),
    (15, 'Ricarica', '2022-06-22 22:35:00', 11591, 3, 11),
    (16, 'Ricarica', '2022-04-09 20:58:28', 2456, 6, 2),
    (17, 'Perdita',  '2022-04-29 10:30:18', 12671, 8, 30),
    (18, 'Vincita',  '2022-04-23 19:21:53', 14056, 7, 10),
    (19, 'Vincita',  '2022-05-12 21:33:15', 33966, 10, 16),
    (20, 'Perdita',  '2022-06-21 13:01:32', 13663, 8, 7),
    (21, 'Perdita',  '2022-06-21 22:17:22', 28752, 10, 19),
    (22, 'Ricarica', '2022-04-08 10:57:42', 4371, 6, 14),
    (23, 'Perdita',  '2022-04-23 20:25:44', 21849, 2, 13),
    (24, 'Perdita',  '2022-05-07 13:52:35', 38406, 4, 17),
    (25, 'Vincita',  '2022-05-10 23:24:20', 11332, 6, 24),
    (26, 'Perdita',  '2022-06-26 17:42:37', 12216, 3, 25),
    (27, 'Perdita',  '2022-06-20 14:45:59', 48778, 9, 1),
    (28, 'Ricarica', '2022-04-10 14:21:06', 2236, 9, 21),
    (29, 'Vincita',  '2022-06-09 10:58:14', 29097, 10, 13),
    (30, 'Ricarica', '2022-06-02 19:58:26', 30888, 9, 25),
    (31, 'Vincita',  '2022-06-04 12:42:26', 27687, 6, 30),
    (32, 'Perdita',  '2022-04-26 21:58:15', 16107, 5, 12),
    (33, 'Vincita',  '2022-05-07 17:04:15', 32007, 7, 2),
    (34, 'Perdita',  '2022-04-08 17:14:31', 34300, 4, 11),
    (35, 'Perdita',  '2022-06-28 21:47:13', 46445, 9, 10),
    (36, 'Ricarica', '2022-04-12 11:20:40', 31295, 2, 29),
    (37, 'Vincita',  '2022-05-30 17:24:42', 17883, 1, 24),
    (38, 'Ricarica', '2022-05-15 10:30:27', 19483, 2, 18),
    (39, 'Perdita',  '2022-07-06 19:10:21', 22444, 1, 14),
    (40, 'Perdita',  '2022-06-07 13:54:00', 6224, 10, 26);   






