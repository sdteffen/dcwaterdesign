/**
 * shpdelaunay.c Create Delaunay triangulation shapefiles using qdelauney
 * 
 * (c) 2005 Steffen Macke 
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */
  
#include "shapefil.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "shpvoronoi.h"

/**
 * Text file resource pointer. 
 */
FILE *hTextFile = NULL;

/**
 * Point shapefile handle.
 */
SHPHandle   hPointSHP = NULL;
/**
 * Point table handle.
 */
DBFHandle   hPointDBF = NULL;

/**
 * Voronoi shapefile handle
 */
SHPHandle hVoronoiSHP = NULL;

/**
 * Voronoi table handle
 */
DBFHandle hVoronoiDBF = NULL;

int num_pipes = 0;
int num_tanks = 0;
int num_reservoirs = 0;
int num_pumps = 0;
int num_valves = 0;

char vertex_line_name[16] = "";
int vertex_line_index = -1;
int num_vertices = -1;

double dBuffer = 1000.0;

/** 
 * Caching the vertices of a line while
 * parsing the vertices section
 * \todo Dynamically allocate according to model size.
 */
double vertex_x[MAXNUMNODES];
double vertex_y[MAXNUMNODES];

/**
 * Cache of the node vertices.
 * \todo Dynamically allocate according to model size.
 */
double node_x[MAXNUMNODES];
double node_y[MAXNUMNODES];

double polygon_x[MAXNUMNODES];
double polygon_y[MAXNUMNODES];

/**
 * Create Delauney triangulation shapefiles using qdelauney.
 * @param argc is the number of arguments provided from the command line 
 * (including the command name).
 * @param argv is an array of strings that contains the argc arguments.
 * @return An error code if something goes wrong or 0 if there was no error
 * during the conversion process.
 * \todo Allow generation of empty report file.
 */
int main( int argc, char **argv ) {
  int error;
  char line[MAXLINE];
  char wline[MAXLINE];
  char *textpointer = NULL, *prev_textpointer = NULL;
  int nPolygons;
  int nShapeType, nEntities, nVertices, nParts, *panParts, i, j, iPart;
  int nNodes, nNodeRef;
  SHPObject *psCShape;
  int byRing = 1;
  int nPolygonPoints;
  char boolWriteShape;
  int nShapes = 0;
  double padfMinBound[4];
  double padfMaxBound[4];
  char *pDCID;
 
  strcpy(vertex_line_name, "");
  num_vertices = 0;
  
  /* parameter check */
  if(((argc != 3)||
    ((!str_is_shp(argv[1])||(!str_is_shp(argv[2])))))) {
    printf("shpdelaunay 0.0.1 (c) 2005 Steffen Macke\n");
    printf("usage: shpdelaunay input_shapefile delauney_shapefile\n");
    exit(1);
  }
  remove_shp(argv[2]);
  
  hPointSHP = SHPOpen(argv[1], "rb" );
  hPointDBF = DBFOpen(argv[1], "rb");
  if(hPointSHP == NULL || hPointDBF == NULL ) {
    printf("FATAL ERROR: Unable to open input file:%s\n", argv[1] );
    exit(1);
  }
  SHPGetInfo(hPointSHP, &nEntities, &nShapeType, padfMinBound, padfMaxBound);
  if(nShapeType != SHPT_POINT) {
    printf("FATAL ERROR: Input is not a point shapefile:%s\n", argv[1]);
    SHPClose(hPointSHP);
    DBFClose(hPointDBF);
    exit(1);
  }
  /**
   * \todo Dynamic filename
   */
  hTextFile = fopen("shptriangle.node", "wt");
  if(hTextFile == NULL) {
    printf("FATAL ERROR: Cannot open output file:%s\n", "shptriangle.node");
    SHPClose(hPointSHP);
    DBFClose(hPointDBF);
    exit(1);
  }
  fprintf(hTextFile, "2\n%d\n", nEntities);
  for(i=0; i<nEntities;i++) {
    psCShape = SHPReadObject(hPointSHP, i);
    fprintf(hTextFile, "%f %f\n", psCShape->dfXMin, psCShape->dfYMin);
    node_x[i] = psCShape->dfXMin;
    node_y[i] = psCShape->dfYMin;
  }
  num_vertices = nEntities;
  fclose(hTextFile);
  SHPClose(hPointSHP);
  DBFClose(hPointDBF);
  system("qdelaunay.exe Qt i < shptriangle.node > shptriangle.off");
  hTextFile = fopen("shptriangle.off", "rt");
  if(hTextFile == NULL) {
    printf("FATAL ERROR: Cannot open input file:%s\n", "shptriangle.off");
    exit(1);
  }
  if(fgets(line, MAXLINE, hTextFile) == NULL) {
    printf("FATAL ERROR reading first line of shptriangle.off\n");
    fclose(hTextFile);
    exit(1);
  }
  nPolygons = atoi(line);
  printf("%d polygons\n", nPolygons);

  hVoronoiSHP = SHPCreate(argv[2], SHPT_POLYGON);
  hVoronoiDBF = DBFCreate(argv[2]);
  hPointDBF = DBFOpen(argv[1], "rb");
  if(hVoronoiSHP == NULL || hVoronoiDBF == NULL || hPointDBF == NULL) {
    fprintf(stderr, "FATAL ERROR: Unable to create file '%s'.\n", 
      argv[2]);
    fclose(hTextFile);  
    exit(1);
  }
  DBFAddField(hVoronoiDBF, "dc_id", FTString, 16, 0);
  for(i=0; i < nPolygons; i++) {
    //printf("Polygon %d\n", i);
    if(fgets(line, MAXLINE, hTextFile) == NULL) {
      printf("FATAL ERROR: shptriangle.off does not contain enough polygons.\n");
      SHPClose(hVoronoiSHP);
      DBFClose(hVoronoiDBF);
      DBFClose(hPointDBF);
      fclose(hTextFile);
      exit(1);
    }
    nNodes = 0;
    nPolygonPoints = 3;
    textpointer = line;
    boolWriteShape = 1;
    for(j=0; j < nPolygonPoints; j++) {
      nNodes++;
      nNodeRef = atoi(textpointer);
      textpointer = strchr(textpointer+1, ' ');
      if((nNodeRef < 0)||(nNodeRef > num_vertices)) {
        printf("FATAL ERROR: shptriangle.off contains illegal node reference '%d'.\n", nNodeRef);
        SHPClose(hVoronoiSHP);
        DBFClose(hVoronoiDBF);
	DBFClose(hPointDBF);
        fclose(hTextFile);
        exit(1);
      }
      //printf("Node reference %d\n", nNodeRef);
      polygon_x[nNodes-1] = node_x[nNodeRef];
      polygon_y[nNodes-1] = node_y[nNodeRef];
    }
    if(boolWriteShape == 1) {
      nNodes++;
      polygon_x[nNodes-1] = polygon_x[0];
      polygon_y[nNodes-1] = polygon_y[0];
      //printf("Polygon %d with %d nodes\n", i, nNodes);
      psCShape = SHPCreateSimpleObject( SHPT_POLYGON, nNodes, polygon_x, polygon_y, NULL );
      SHPWriteObject(hVoronoiSHP, -1, psCShape);
      SHPDestroyObject(psCShape);
      DBFWriteStringAttribute(hVoronoiDBF, nShapes, 0, "");
      nShapes++;
    }
 }
 SHPClose(hVoronoiSHP);
 DBFClose(hVoronoiDBF);
 DBFClose(hPointDBF);
 fclose(hTextFile);
}  

/**
 * Determine whether a string is a shapefile name or not.
 * @param str is String that needs to be tested.
 * @return 1 if the string ends with "*.shp", otherwise 0 is returned.
 */
int str_is_shp(char *str) {
  int len;
  
  len = strlen(str);
  if(strncasecmp(&str[len-4], ".shp", 4) == 0) {
    return 1;
  } else {
    return 0;
  }
}

/**
 * Remove the three files that make up a shapefile.
 * @param shapefilename is a string containing the name of the shapefile.
 * @return Nothing.
 */
void remove_shp(char *shapefilename) {
  char filename[255];
  int len;
  int returnvalue;
  
  returnvalue = remove(shapefilename);
#ifdef DEBUG
  fprintf(stderr, "remove(\"%s\") returned %d.\n", shapefilename, returnvalue);
#endif  
  len = strlen(shapefilename);
  if(len < 255) { 
    strncpy(filename, shapefilename, len-3);
    strncpy(&filename[len-3], "dbf", 4);
    returnvalue = remove(filename);
#ifdef DEBUG
  fprintf(stderr, "remove(\"%s\") returned %d.\n", filename, returnvalue);
#endif  
    strncpy(&filename[len-3], "shx", 4);
    returnvalue = remove(filename);
#ifdef DEBUG
  fprintf(stderr, "remove(\"%s\") returned %d.\n", filename, returnvalue);
#endif      
  }
}

