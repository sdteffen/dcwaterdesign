# Makefile for MinGW MSYS 1.0.10
LINKOPT	=      -L "c:\program files\shapelib" -lshapelib

CFLAGS	=      -I "c:\program files\shapelib" -O2

default:	all

all:	shpvoronoi shpdelaunay shptriangle

shpvoronoi:	shpvoronoi.c shpvoronoi.h
	gcc $(CFLAGS) shpvoronoi.c $(LINKOPT) -o shpvoronoi.exe

shpdelaunay:	shpdelaunay.c shpvoronoi.h
	gcc $(CFLAGS) shpdelaunay.c $(LINKOPT) -o shpdelaunay.exe

shptriangle:	shptriangle.c shpvoronoi.h
	gcc $(CFLAGS) shptriangle.c $(LINKOPT) -o shptriangle.exe
	
clean:
	rm *.obj shpvoronoi.exe shpdelaunay.exe shptriangle.exe

