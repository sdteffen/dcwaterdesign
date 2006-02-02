/**
 * shptriangle.c Create shapefiles by Delaunay triangulation using triangle
 * 
 * Copyright (c) 2005,2006 Steffen Macke 
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
 * Cache of the node vertices.
 * \todo Dynamically allocate according to model size.
 */
double node_x[MAXNUMNODES];
double node_y[MAXNUMNODES];
double node_z[MAXNUMNODES];

double polygon_x[MAXNUMNODES];
double polygon_y[MAXNUMNODES];
double polygon_z[MAXNUMNODES];

/**
 * Create Delaunay shape files using Triangle.
 * @param argc is the number of arguments provided from the command line 
 * (including the command name).
 * @param argv is an array of strings that contains the argc arguments.
 * @return An error code if something goes wrong or 0 if there was no error
 * during the conversion process.
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
  char boolWriteShape;
  int nShapes = 0;
  double padfMinBound[4];
  double padfMaxBound[4];
  int nDcidIndex = -1;
  char *pDCID;
  /**
   * Vectors to calculate plane parameters
   */
  double vector0[3];
  double vector1[3];
  /**
   * Plane parameters
   */
  double a,b,c,d;
  /**
   * Slope of the plane
   */
  double slope;
  /**
   * Elevation field (if provided)
   */
  int nElevationField = -1; 
 
  strcpy(vertex_line_name, "");
  num_vertices = 0;
  
  /* parameter check */
  if((((argc != 3)||
    ((!str_is_shp(argv[1])||(!str_is_shp(argv[2]))))))&&((argc != 4)||
    ((!str_is_shp(argv[1])||(!str_is_shp(argv[2])))))) {
    printf("shptriangle 0.1.0 (c) 2005,2006 Steffen Macke\n");
    printf("usage: shptriangle input_shapefile delaunay_shapefile [elevationfield]\n");
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
  if(4 == argc) {
    nElevationField = DBFGetFieldIndex(hPointDBF, argv[3]);
    if(-1 == nElevationField) {
      printf("WARNING: Could not find elevation field '%s'.\n", argv[3]);
    }
  }
  if(nEntities > MAXNUMNODES) {
    printf("FATAL ERROR: Too many nodes. Please recompile.\n");
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
  fprintf(hTextFile, "%d 2 0 0\n", nEntities);
  for(i=0; i<nEntities;i++) {
    psCShape = SHPReadObject(hPointSHP, i);
    fprintf(hTextFile, "%d %f %f\n", i+1, psCShape->dfXMin, psCShape->dfYMin);
    node_x[i] = psCShape->dfXMin;
    node_y[i] = psCShape->dfYMin;
    if(nElevationField > -1) {
      node_z[i] = DBFReadDoubleAttribute(hPointDBF, i, nElevationField);
    } else {
      node_z[i] = 0.0;
    }
  }
 
  fclose(hTextFile);
  SHPClose(hPointSHP);
  DBFClose(hPointDBF);
  system("triangle.exe -I shptriangle");
  
  hTextFile = fopen("shptriangle.ele", "rt");
  if(hTextFile == NULL) {
    printf("FATAL ERROR: Cannot open input file:%s\n", "shptriangle.ele");
    exit(1);
  }
  if(fgets(line, MAXLINE, hTextFile) == NULL) {
    printf("FATAL ERROR: Reading first line of shptriangle.ele\n");
    fclose(hTextFile);
    exit(1);
  }
  nPolygons = atoi(line);
  textpointer = strchr(line, ' ');
  num_vertices = atoi(textpointer);
  if(num_vertices != 3) {
    printf("FATAL ERROR: Wrong node count in first line of shptriangle.ele\n");
    fclose(hTextFile);
    exit(1);
  }
  //printf("%s\n", line);
  
  if(num_vertices > MAXNUMNODES) {
    printf("FATAL ERROR: Too many nodes, please recompile: %d\n", num_vertices);
    fclose(hTextFile);
    exit(1);
  }
  //printf("%d nodes\n", num_vertices);
  //printf("%d polygons\n", nPolygons);
  
  hVoronoiSHP = SHPCreate(argv[2], SHPT_POLYGONZ);
  hVoronoiDBF = DBFCreate(argv[2]);
  hPointDBF = DBFOpen(argv[1], "rb");
  if(hVoronoiSHP == NULL || hVoronoiDBF == NULL || hPointDBF == NULL) {
    fprintf(stderr, "FATAL ERROR: Unable to create file '%s'.\n", 
      argv[2]);
    fclose(hTextFile);  
    exit(1);
  }
  DBFAddField(hVoronoiDBF, "dc_id", FTString, 16, 0);
  DBFAddField(hVoronoiDBF, "slope", FTDouble, 16, 8);
  for(i=0; i < nPolygons; i++) {
    //printf("Polygon %d\n", i);
    if(fgets(line, MAXLINE, hTextFile) == NULL) {
      printf("FATAL ERROR: shptriangle.ele does not contain enough polygons.\n");
      SHPClose(hVoronoiSHP);
      DBFClose(hVoronoiDBF);
      DBFClose(hPointDBF);
      fclose(hTextFile);
      exit(1);
    }
    nNodes = 0;
    textpointer = line;
    textpointer = strchr(strpbrk(line, "1234567890"), ' ');
    boolWriteShape = 1;
    for(j=0; j < num_vertices; j++) {
      textpointer = strpbrk(strchr(textpointer+1, ' '), "1234567890");
      nNodes++;
      nNodeRef = atoi(textpointer);
      if((nNodeRef < 0)||(nNodeRef > nEntities)) {
        printf("FATAL ERROR: shptriangle.ele contains illegal node reference.\n");
        SHPClose(hVoronoiSHP);
        DBFClose(hVoronoiDBF);
	DBFClose(hPointDBF);
        fclose(hTextFile);
        exit(1);
      }
      //printf("Node reference %d\n", nNodeRef);
      polygon_x[nNodes-1] = node_x[nNodeRef-1];
      polygon_y[nNodes-1] = node_y[nNodeRef-1];
      polygon_z[nNodes-1] = node_z[nNodeRef-1];
    }
    if(boolWriteShape == 1) {
      nNodes++;
      polygon_x[nNodes-1] = polygon_x[0];
      polygon_y[nNodes-1] = polygon_y[0];
      polygon_z[nNodes-1] = polygon_z[0];
      //printf("Polygon %d with %d nodes\n", i, nNodes);
      psCShape = SHPCreateSimpleObject( SHPT_POLYGONZ, nNodes, polygon_x, 
        polygon_y, polygon_z );
      SHPWriteObject(hVoronoiSHP, -1, psCShape);
      SHPDestroyObject(psCShape);
      DBFWriteStringAttribute(hVoronoiDBF, nShapes, 0, "");
      /**
       * Calculate slope.
       * Plane equation 0 = a*x + b*y + c*z + d
       * Sea level plane 0 = 0*x + 0*y + 1*z - 0 
       */
      vector0[0] = polygon_x[1] - polygon_x[0];
      vector0[1] = polygon_y[1] - polygon_y[0];
      vector0[2] = polygon_z[1] - polygon_z[0];
      
      vector1[0] = polygon_x[2] - polygon_x[0];
      vector1[1] = polygon_y[2] - polygon_y[0];
      vector1[2] = polygon_z[2] - polygon_z[0];

      /**
       * Use cross product to find plane equation. 
       */
      a = vector0[1] * vector1[2] - vector0[2] * vector1[1];
      b = -(vector0[0] * vector1[2] - vector0[2] * vector1[0]);
      c = vector0[0] * vector1[1] - vector0[1] * vector1[0];
      d = -(a * polygon_x[0] + b * polygon_y[0] + c * polygon_z[0]);
      /**
       * Calculate dihedral angle between sea level plane and triangle plane
       */
      slope = acos(c/(sqrt(a*a+b*b+c*c)))/3.141592654*180;
      DBFWriteDoubleAttribute(hVoronoiDBF, nShapes, 1, slope);
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

