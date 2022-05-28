f = open("editdata.txt","r")
fw = open("editdata1.txt","a")
lines = f.readlines()
#INSERT INTO Transazioni(IDTx,Tipo,TimestampTX,Importo,IDPostazione,IDCliente)

for line in lines:
    splitted = line.replace("'","").strip().split(",");

    #PERSONALE
    #tostamp = (splitted[0]+", "+"'"+cf+"'"+","+"'"+splitted[2].strip()+"'"+","+"'"+splitted[3].strip()+"'"+","+"'"+splitted[6].strip()+"'"+","+"'"+splitted[7].strip()+"'"+","+"'"+splitted[8].strip()+"'"+","+"'"+splitted[9].strip()+"'"+","+"'"+splitted[10].strip()+"'"+","+splitted[11].strip()+","+splitted[12].strip())
    #print(splitted[1])
    if "Ricarica" in line:
        fw.writeline(splitted[0]+",'"+splitted[1].strip()+"','"+splitted[2].strip()+"',"+splitted[3]+","+splitted[5]+'\n')
        #print(splitted[1])
        #fw.write(line)
    #if (splitted[1] != "Ricarica"):
        #fw.write(line)
        #print(line)
    #CLIENTI
    #tostamp = (splitted[0]+", "+"'"+cf+"'"+","+"'"+splitted[2].strip()+"'"+","+"'"+splitted[3].strip()+"'"+","+"'"+splitted[6].strip()+"'"+","+"'"+splitted[7].strip()+"'"+","+"'"+splitted[8].strip()+"'"+","+"'"+splitted[9].strip()+"'"+","+"'"+splitted[10].strip()+"'"+","+splitted[11].strip())
    #print(tostamp)