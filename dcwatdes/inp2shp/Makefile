
LINKOPT	=	-L. -lepanet2vc -ggdb
CFLAGS	=	-march=pentium -mms-bitfields -ggdb -O2 -Wall

default:	all

all:	inp2shp

shpopen.o:	shpopen.c shapefil.h
	$(CC) $(CFLAGS) -c shpopen.c

dbfopen.o:	dbfopen.c shapefil.h
	$(CC) $(CFLAGS) -c dbfopen.c

inp2shp:	inp2shp.c shpopen.o dbfopen.o inp2shp.h
	$(CC) $(CFLAGS) inp2shp.c shpopen.o dbfopen.o $(LINKOPT) -o inp2shp

clean:
	rm -f *.o inp2shp

