/**
 * inp2shp.c convert EPANET INP files to Shapefiles
 * 
 * (c) 2002, 2005 DORSCH Consult 
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 */
  
#include "epanet2.h"
#include "shapefil.h"
#include <stdlib.h>
#include <string.h>
#include "inp2shp.h"

/**
 * These sections have to be parsed in addition
 * to the parsing performed by the toolkit. 
 */
char *SectTxt[] = {"[COORDINATES]", "[VERTICES]", "[END]",
  	           "[PIPES]", NULL};
/**
 * INP file resource pointer. 
 */
FILE *InFile;

/**
 * Junction shapefile handle.
 */
SHPHandle   hJunctionSHP = NULL;
/**
 * Junction table handle.
 */
DBFHandle   hJunctionDBF = NULL;

/**
 * Pipe shapefile handle.
 */
SHPHandle hPipeSHP = NULL;
DBFHandle hPipeDBF = NULL;  

/* tank shapefile */
SHPHandle hTankSHP = NULL;
DBFHandle hTankDBF = NULL;

/* reservoir shapefile */
SHPHandle hReservoirSHP = NULL;
DBFHandle hReservoirDBF = NULL;

/* valve shapefile */
SHPHandle hValveSHP = NULL;
DBFHandle hValveDBF = NULL;

/* pump shapefile */
SHPHandle hPumpSHP = NULL;
DBFHandle hPumpDBF = NULL;

/**
 * Tokens in INP file 
 */
char *Tok[MAXTOKS];

/**
 * Number of junctions in the generated shapefile.
 * Counted while writing to the shapefile.
 */ 
int num_junctions = 0;
/**
 * Number of pipes in the generated shapefile.
 */
int num_pipes = 0;
int num_tanks = 0;
int num_reservoirs = 0;
int num_pumps = 0;
int num_valves = 0;

char vertex_line_name[16] = "";
int vertex_line_index = -1;
int num_vertices = -1;

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

/**
 * The name of the junction shapefile.
 */
char *junctions_name = "junctions.shp"; 
/**
 * The name of the pipes shapefile.
 */
char *pipes_name = "pipes.shp";
/**
 * The name of the tanks shapefile.
 */
char *tanks_name = "tanks.shp";
/**
 * The name of the reservoir shapefile.
 */
char *reservoirs_name = "reservoirs.shp";
/**
 * The name of the pump shapefile.
 */
char *pumps_name = "pumps.shp";
/**
 * The name of the valve shapefile.
 */
char *valves_name = "valves.shp";

/**
 * Convert an EPANET INP file to a series of shape files.
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
  int Ntokens;
  int newsect, sect;
  int i;

  sect = -1;
 
  strcpy(vertex_line_name, "");
  num_vertices = 0;
  
  /* parameter check */
  if(((argc != 3)&&(argc !=9))||((argc == 9)&&
    ((!str_is_shp(argv[3])||(!str_is_shp(argv[4])||
     (!str_is_shp(argv[5])||(!str_is_shp(argv[6])||
     (!str_is_shp(argv[7])||(!str_is_shp(argv[8])))))))))) {
    printf("inp2shp 0.2.0 (c) 2002, 2005 DORSCH Consult\n");
    printf("usage: inp2shp inpfile reportfile [junction_shapefile\
 pipe_shapefile pump_shapefile reservoir_shapefile tank_shapefile\
 valve_shapefile]\n");
    exit(1);
  }
 
  for(i=3; i<9; i++) {
    remove_shp(argv[i]);
  }
  initialize();
  
  /**
   * Open the files 
   */
  error = ENopen(argv[1], argv[2], "");
  if(error != 0) {
    fprintf(stderr, "FATAL ERROR: EPANET returned error %d when opening '%s'.\n", 
      error, argv[1]);
    ENclose();
    exit(error);
  }
  if(argc == 9) {
    junctions_name = argv[3];
    pipes_name = argv[4];
    pumps_name = argv[5];
    reservoirs_name = argv[6];
    tanks_name = argv[7];
    valves_name = argv[8];
  }
  create_junction_shapefile(junctions_name);
  create_pipe_shapefile(pipes_name);
  create_pump_shapefile(pumps_name);
  create_reservoir_shapefile(reservoirs_name);
  create_tank_shapefile(tanks_name);
  create_valve_shapefile(valves_name);
  InFile = fopen(argv[1], "rt");
 
  while(fgets(line, MAXLINE, InFile) != NULL) {
    strcpy(wline,line);
    Ntokens = gettokens(wline);
    /*printf("num tokens : %d\n", Ntokens);*/
    /* Skip blank lines and comments */
    if (Ntokens == 0) continue;
    if (*Tok[0] == ';') continue;

    /* Check if max. length exceeded */
    if(strlen(line) >= MAXLINE) {
      printf("WARNING: Line too long.\n");
    }
    /* Check if line begins with a new section heading */
    if(*Tok[0] == '[')
    {
       /* [VERTICES] */
       if((sect == 1)&&(num_vertices > 0)) write_pipe_shape();
       /* [COORDINATES] */
       if(sect == 0) handle_virtual_line_nodes();
       sect = (-1);
       newsect = findmatch(Tok[0], SectTxt);
       if (newsect >= 0)
       {
	  sect = newsect;
	  if (sect == 2) break;
	  continue;
       }
       else continue;
    }

    switch(sect)
    {
      	  /* [COORDINATES] */
	  case 0: if(Ntokens == 3) write_node();   
	  break;
	  /* [VERTICES] */
	  case 1: if(Ntokens == 3) write_vertex();
	  break;
	  /* [PIPES] */
	  case 3: 
	  if(Ntokens > 3) {
	    write_null_pipe();
	  } else {
	    fprintf(stderr, "WARNING: Less than 4 tokens for a pipe.");
	  }
	  break;
    }
  }
  
  write_remaining_pipe_shapes();
  write_virtual_lines();
  
  exit_inp2shp(0);
  return 0;
}

/**
 * Initialize global variables.
 */
void initialize() {
  int i;
  /**
   * \todo This can be optimized
   */
  for(i=0; i<5000; i++) {
    vertex_x[i] = 0;
    vertex_y[i] = 0;
    node_x[i] = 0;
    node_y[i] = 0;
  }
  for(i=0; i<MAXTOKS; i++) {
    Tok[i] = NULL;
  }
}

/**
 * Exit the program with the given error code.
 * Closes open files if necessary.
 * @param error is the error code to be returned.
 */
void exit_inp2shp(int error) {
  if(hPipeSHP)
    SHPClose(hPipeSHP);
  if(hPipeDBF)
    DBFClose(hPipeDBF); 
  if(hJunctionDBF)
    DBFClose(hJunctionDBF);
  if(hJunctionSHP)
    SHPClose(hJunctionSHP);
  if(hTankSHP)
    SHPClose(hTankSHP);
  if(hTankDBF)
    DBFClose(hTankDBF);
  if(hReservoirSHP)
    SHPClose(hReservoirSHP);
  if(hReservoirDBF)
    DBFClose(hReservoirDBF);
  if(hPumpSHP)
    SHPClose(hPumpSHP);
  if(hPumpDBF)
    DBFClose(hPumpDBF);
  if(hValveSHP)
    SHPClose(hValveSHP);
  if(hValveDBF)
    DBFClose(hValveDBF);
  
  if(num_junctions == 0) remove_shp(junctions_name);
  if(num_pipes == 0) remove_shp(pipes_name);
  if(num_pumps == 0) remove_shp(pumps_name);
  if(num_tanks == 0) remove_shp(tanks_name);
  if(num_reservoirs == 0) remove_shp(reservoirs_name);
  if(num_valves == 0) remove_shp(valves_name);
  
  if(error == 0) {
    print_statistics();
  }
  
  ENclose(); 
  
  exit(error);
}

/**
 * Write those pipes which have no additional vertices and are no
 * virtual lines.
 */
void write_remaining_pipe_shapes() {
  int i;
  SHPObject *shape;
  double x[2], y[2];
  char *pipe_id;
  int pipe_index;
  int from_node, to_node;
  
  for(i=0; i<num_pipes; i++) {
    /**
     * \todo performance increase with SHPGetInfo 
     */
    shape = SHPReadObject(hPipeSHP, i);
    x[0] = 0;
    y[0] = 0;
    x[1] = 0;
    y[1] = 0;
    if(shape->nSHPType == SHPT_NULL) {
      SHPDestroyObject(shape);
      pipe_id = (char *) DBFReadStringAttribute(hPipeDBF, i, 0);
      ENgetlinkindex(pipe_id, &pipe_index);
      ENgetlinknodes(pipe_index, &from_node, &to_node);
      x[0] = node_x[from_node];
      y[0] = node_y[from_node];
      x[1] = node_x[to_node];
      y[1] = node_y[to_node];
      shape = SHPCreateSimpleObject( SHPT_ARC, 2, x, y, NULL );
      SHPWriteObject(hPipeSHP, i, shape);
      SHPDestroyObject(shape);
    } else {
      SHPDestroyObject(shape);
    }
 }
 return;
}

/**
 * Turn virtual lines (valves, pumps) into points. 
 */
void handle_virtual_line_nodes() {
   int i;
   int from_node, to_node;
   int num_lines;
   int linktype;
   
   ENgetcount(EN_LINKCOUNT, &num_lines);
   for(i=0; i<num_lines; i++) {
     ENgetlinktype(i+1, &linktype);
     switch(linktype) {
       case EN_PIPE:
	 case EN_CVPIPE:
       break;
       default: ENgetlinknodes(i+1, &from_node, &to_node);
         if((to_node >= MAXNUMNODES)||(from_node >= MAXNUMNODES)) {
	   fprintf(stderr, 
	     "FATAL ERROR: Maximum number (%d) of nodes exceeded.\n", 
	     MAXNUMNODES);
	   exit_inp2shp(1);  
         }
	 node_x[to_node] = node_x[from_node];
	 node_y[to_node] = node_y[from_node];
       break; 
     }   
   }
   return;
}

/**
 * Write pumps and valves
 */
int write_virtual_lines() {
  /**
   * \todo Remove superfluous nodes. 
   */
  int i;
  int num_lines;
  int linktype;
  
  ENgetcount(EN_LINKCOUNT, &num_lines);    
  for(i=0; i<num_lines; i++) {
    ENgetlinktype(i+1, &linktype);
    switch(linktype) {
      case EN_PIPE:
      case EN_CVPIPE:
      /**
       * \todo Create valve for EN_CVPIPE.
       */
      break;
      case EN_PUMP: write_pump(i+1);
      break;
      default: write_valve(i+1);
      break; 
    }   
  }
  return 0;
}

int write_pump(int index) {
  SHPObject *shape;
  double x, y;
  int from_node, to_node;
  char string[16];
  
  ENgetlinkid(index, string);
  ENgetlinknodes(index, &from_node, &to_node);
  x = node_x[from_node];
  y = node_y[from_node];
  shape = SHPCreateSimpleObject( SHPT_POINT, 1, &x, &y, NULL );
  SHPWriteObject(hPumpSHP, -1, shape);
  SHPDestroyObject(shape);
  DBFWriteStringAttribute(hPumpDBF, num_pumps, 0, string);
  num_pumps++;
  
  return 0;
}

/**
 * Write a valve record to the shapefile.
 * @param 
 */
int write_valve(int index) {
  SHPObject *shape;
  double x, y;
  int from_node, to_node;
  char string[16];
  
  ENgetlinkid(index, string);
  ENgetlinknodes(index, &from_node, &to_node);
  x = node_x[from_node];
  y = node_y[from_node];
  shape = SHPCreateSimpleObject( SHPT_POINT, 1, &x, &y, NULL );
  SHPWriteObject(hValveSHP, -1, shape);
  SHPDestroyObject(shape);
  DBFWriteStringAttribute(hValveDBF, num_valves, 0, string);
  num_valves++;
  return 1;
}

/**
 * Call the node writing functions for the current node.
 * Virtual line nodes are dropped.
 * @return 0 if there's an error. 1 if there's no error.
 * \todo Handle return values of called functions.
 */
int write_node() {
  int index;
  int nodetype;
  int linkindex = 1;
  int linktype;
  int fromnode;
  int tonode;
      
  ENgetnodeindex(Tok[0], &index);
#ifdef DEBUG
  fprintf(stderr, "write_node(): Node %d\n", index);
#endif  
  
  if(index == (int) NULL) {
    fprintf(stderr, 
      "ERROR: Node \"%s\" referenced in [COORDINATES] was not found.\n", Tok[0]);
    return 0;
  }
  if(index >= MAXNUMNODES) {
    fprintf(stderr, "FATAL ERROR: Maximum number (%d) of nodes exceeded.\n", 
      MAXNUMNODES);
    exit_inp2shp(1);  
  }
  node_x[index] = atof(Tok[1]);
  node_y[index] = atof(Tok[2]);

  /**
   * Drop nodes that are part of a virtual line.
   */
  do {
    ENgetlinktype(linkindex, &linktype);
    linkindex++;
    if((linktype != EN_PIPE)&&(linktype != -1)) {
      ENgetlinknodes(linkindex, &fromnode, &tonode);
      if((index == fromnode)||(index == tonode)) return 1;
    }
  } while(linktype != -1);
  
  ENgetnodetype(index, &nodetype);
  
  switch(nodetype) {
    case EN_JUNCTION: write_junction(index);
    break;
    case EN_TANK: write_tank(index);
    break;
    case EN_RESERVOIR: write_reservoir(index);
    break;
  } 
  return 1;
}

/**
 * 
 */
int write_vertex() {
  int linktype;
  int index;
      
  if(strcmp(vertex_line_name, Tok[0]) != 0) {
      ENgetlinkindex(Tok[0], &index);
      if(index == 0) {
	printf("[COORDINATES]: link '%s' was not found\n", Tok[0]);
	return 0;
      }
      if(strcmp(vertex_line_name, "") != 0) {
	ENgetlinktype(vertex_line_index, &linktype);
	switch(linktype) {
	  case EN_CVPIPE:
	  case EN_PIPE: write_pipe_shape();
	  break;
	} 
      }
    num_vertices = 1;
    vertex_line_index = index;
    strcpy(vertex_line_name, Tok[0]);
  } else {
    num_vertices++;
  }
  if(num_vertices >= MAXNUMNODES) {
    fprintf(stderr, "FATAL ERROR: Maximum number (%d) of vertices exceeded.\n", 
      MAXNUMNODES);
    exit_inp2shp(1);   
  }
  vertex_x[num_vertices] = atof(Tok[1]);
  vertex_y[num_vertices] = atof(Tok[2]);
  
  return 0;
}

/**
 * Write a junction shape and the related DBF records.
 * @return 1 if no error occurs, 0 if there was an error.
 * \todo Use return shapelib return values and handle errors.
 */
int write_junction(int index) {
  double x, y;
  char string[MAXLINE];
  SHPObject   *shape;
  float f;
  int returnvalue;
   
  x = atof(Tok[1]);
  y = atof(Tok[2]);
  
  ENgetnodeid(index, string);

  shape = SHPCreateSimpleObject( SHPT_POINT, 1, 
			   &x, &y, NULL );
  returnvalue = SHPWriteObject(hJunctionSHP, -1, shape);
#ifdef DEBUG
  fprintf(stderr, "SHPWriteObject() returned %d\n", returnvalue);
#endif
  SHPDestroyObject(shape);
  returnvalue = DBFWriteStringAttribute(hJunctionDBF, num_junctions, 0, string);
#ifdef DEBUG
  fprintf(stderr, "DBFWriteStringAttribute(%d, 0, \"%s\") returned %d\n", 
    num_junctions, string, returnvalue);
#endif  
  ENgetnodevalue(index, EN_ELEVATION, &f);
  returnvalue = DBFWriteDoubleAttribute(hJunctionDBF, num_junctions, 5, 
    (double) f);
#ifdef DEBUG
  fprintf(stderr, "DBFWriteDoubleAttribute(%d, 5, %f) returned %d\n", 
    num_junctions, f, returnvalue);
#endif  
  ENgetnodevalue(index, EN_BASEDEMAND, &f);
  returnvalue = DBFWriteDoubleAttribute(hJunctionDBF, num_junctions, 9, (double) f);
#ifdef DEBUG
  fprintf(stderr, "DBFWriteDoubleAttribute(%d, 9, %f) returned %d\n", 
    num_junctions, f, returnvalue);
#endif  
  ENgetnodevalue(index, EN_PATTERN, &f);
  ENgetpatternid((int)f, string);
  returnvalue = DBFWriteStringAttribute(hJunctionDBF, num_junctions, 10, string);
#ifdef DEBUG
  fprintf(stderr, "DBFWriteStringAttribute(%d, 10, \"%s\") returned %d\n", 
    num_junctions, string, returnvalue);
#endif  
  
  num_junctions++;
  return 0;
}

/**
 * Write a tank shape and the related DBF records.
 * @return 1 if no error occurs, 0 if there was an error.
 * \todo Use return shapelib return values and handle errors.
 */
int write_tank(int index) {
  double x, y;
  char string[MAXLINE];
  SHPObject   *shape;
  float f;
   
  x = atof(Tok[1]);
  y = atof(Tok[2]);
    
  ENgetnodeid(index, string);
  
  shape = SHPCreateSimpleObject( SHPT_POINT, 1, 
                             &x, &y, NULL );
  SHPWriteObject(hTankSHP, -1, shape);
  SHPDestroyObject(shape);
  DBFWriteStringAttribute(hTankDBF, num_tanks, 0, string);
  ENgetnodevalue(index, EN_ELEVATION, &f);
  DBFWriteDoubleAttribute(hTankDBF, num_tanks, 5, (double) f);
  DBFAddField(hTankDBF, "result_dem", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "result_hea", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "result_pre", FTDouble, 16, 8);
  ENgetnodevalue(index, EN_TANKLEVEL, &f);
  DBFWriteDoubleAttribute(hTankDBF, num_tanks, 9, (double)f);
  ENgetnodevalue(index, EN_PATTERN, &f);
 /* DBFAddField(hTankDBF, "minimumlev", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "maximumlev", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "diameter", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "minimumvol", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "volumecurv", FTString, 16, 0);*/
  num_tanks++;
  return 0;
}

int write_reservoir(int index) {
  double x, y;
  char string[MAXLINE];
  SHPObject   *shape;
     
  x = atof(Tok[1]);
  y = atof(Tok[2]);
    
  ENgetnodeid(index, string);
  
  shape = SHPCreateSimpleObject( SHPT_POINT, 1, 
                             &x, &y, NULL );
  SHPWriteObject(hReservoirSHP, -1, shape);
  SHPDestroyObject(shape);
  DBFWriteStringAttribute(hReservoirDBF, num_reservoirs, 0, string);
  num_reservoirs++;
  return 0;
}

/**
 * Find the from ID for a given pipe.
 * Drop virtual line IDs.
 * @param linkindex is the index of the link in question.
 * @param nodeid is a pointer to a string that should be filled with the from
 * node id.
 * @return 1 if everything is ok, 0 in case there's an error.
 * \todo Handle return values.
 */
int find_from_node(int nodeindex, char *nodeid) {
  int i = 1;
  int from_node;
  int to_node;
  int link_type;
  int returnvalue;

  ENgetnodeid(nodeindex, nodeid);
  
  do {
    returnvalue = ENgetlinknodes(i, &from_node, &to_node);
    if(to_node == nodeindex) {
      ENgetlinktype(i, &link_type);
      if(link_type == -1) {
	fprintf(stderr, 
	  "ERROR: Unknown link type in find_from_node(%d, \"%s\")\n",
	  nodeindex, nodeid);
	return 0;
      }
      if(link_type != EN_PIPE) {
	ENgetnodeid(from_node, nodeid);
	return 1;
      }
    }
    i++;
  } while(returnvalue != 204);
  return 1;
}
/**
 * Write a NULL shape for all pipes.
 * \todo Handle return values.
 */
int write_null_pipe() {
  SHPObject   *shape;
  int index;
  double x[2], y[2];
  float d;
  int to_node, from_node;
  char string[16];
  int type;
  
#ifdef DEBUG    
  fprintf(stderr, "write_null_pipe()\n");
#endif  
  ENgetlinkindex(Tok[0], &index);
  DBFWriteStringAttribute(hPipeDBF, num_pipes, 0, Tok[0]);
  ENgetlinkvalue(index, EN_DIAMETER, &d);
  DBFWriteIntegerAttribute(hPipeDBF, num_pipes, 5, (int)d);
  ENgetlinknodes(index, &from_node, &to_node);
  find_from_node(from_node, string);
  DBFWriteStringAttribute(hPipeDBF, num_pipes, 6, string);
  ENgetnodeid(to_node, string);
  DBFWriteStringAttribute(hPipeDBF, num_pipes, 7, string);
  ENgetlinkvalue(index, EN_ROUGHNESS, &d);
  DBFWriteDoubleAttribute(hPipeDBF, num_pipes, 8, (double)d);
  ENgetlinkvalue(index, EN_MINORLOSS, &d);
  DBFWriteDoubleAttribute(hPipeDBF, num_pipes, 9, (double)d);
  ENgetlinktype(index, &type);
  if(type == EN_CVPIPE) {
    DBFWriteStringAttribute(hPipeDBF, num_pipes, 10, "CV");
  } else {
    ENgetlinkvalue(index, EN_INITSTATUS, &d);
    if(d == 1) {
      DBFWriteStringAttribute(hPipeDBF, num_pipes, 10, "OPEN");
    } else {
      DBFWriteStringAttribute(hPipeDBF, num_pipes, 10, "CLOSED");
    }
  }
  x[0] = 0;
  y[0] = 0;
  x[1] = 1;
  y[1] = 1;
  shape = SHPCreateSimpleObject( SHPT_NULL, 2, x, y, NULL );
  SHPWriteObject(hPipeSHP, -1, shape);
  SHPDestroyObject(shape);
  num_pipes++;
  return 0;
}

/**
 * Write out pipe shapes where additional vertices are available.
 * @return 1 if no error was encountered. 0 if an error was encountered.
 * \todo Drop virtual lines. 
 */
int write_pipe_shape() {
  char *string;
  SHPObject   *shape;
  int to_node, from_node;
  int index = vertex_line_index;
  
  ENgetlinknodes(index, &from_node, &to_node);
#ifdef DEBUG  
  fprintf(stderr, "write_pipe_shape(%d, %d)\n", to_node, from_node);
#endif  
  vertex_x[0] = node_x[from_node];
  vertex_y[0] = node_y[from_node];
  vertex_x[num_vertices+1] = node_x[to_node];
  vertex_y[num_vertices+1] = node_y[to_node];
  /**
   * Find pipe record in Shapefile.
   */
  do {
    string = (char *) DBFReadStringAttribute(hPipeDBF, index, 0);
    index--;
  } while(((string == NULL )||(strcmp(string, vertex_line_name)!=0))&&(index > 0));
  if(index != 0) {
    shape = SHPCreateSimpleObject( SHPT_ARC, num_vertices+2, 
			     vertex_x, vertex_y, NULL );
    SHPWriteObject(hPipeSHP, index+1, shape);
    SHPDestroyObject(shape);
  } else {
    fprintf(stderr, 
      "ERROR: write_pipe_shape(): Could not find pipe record \"%s\".", string);
  }
  
  return 1;
}

/**
 * Create a point shapefile with the necessary field structure.
 */
int create_junction_shapefile() {
  hJunctionSHP = SHPCreate(junctions_name, SHPT_POINT);
  hJunctionDBF = DBFCreate(junctions_name);
  if(hJunctionSHP == NULL || hJunctionDBF == NULL) {
    fprintf(stderr, "FATAL ERROR: Unable to create file '%s'.\n", 
      junctions_name);
    exit_inp2shp(1);
  }
  DBFAddField(hJunctionDBF, "dc_id", FTString, 16, 0);
  DBFAddField(hJunctionDBF, "installati", FTString, 16, 0);
  DBFAddField(hJunctionDBF, "abandon_da", FTString, 16, 0);
  DBFAddField(hJunctionDBF, "dcsubtype", FTInteger, 16, 0);
  DBFAddField(hJunctionDBF, "bitcodezon", FTInteger, 20, 0);
  DBFAddField(hJunctionDBF, "elevation", FTDouble, 16, 3);
  DBFAddField(hJunctionDBF, "result_dem", FTDouble, 16, 8);
  DBFAddField(hJunctionDBF, "result_hea", FTDouble, 16, 8);
  DBFAddField(hJunctionDBF, "result_pre", FTDouble, 16, 8);
  DBFAddField(hJunctionDBF, "demand", FTDouble, 16, 8);
  DBFAddField(hJunctionDBF, "pattern", FTString, 16, 0);
  num_junctions = 0;
  return 0;
}

/**
 * Create a point shapefile with the necessary field structure.
 */
int create_tank_shapefile(char *filename) {
  hTankSHP = SHPCreate(filename, SHPT_POINT);
  hTankDBF = DBFCreate(filename);
  if(hTankSHP == NULL || hTankDBF == NULL) {
    fprintf(stderr, "FATAL ERROR: Unable to create file '%s'.\n", filename);
    exit_inp2shp(1);
  }
  DBFAddField(hTankDBF, "dc_id", FTString, 16, 0);
  DBFAddField(hTankDBF, "installati", FTString, 16, 0);
  DBFAddField(hTankDBF, "abandon_da", FTString, 16, 0);
  DBFAddField(hTankDBF, "dcsubtype", FTInteger, 16, 0);
  DBFAddField(hTankDBF, "bitcodezon", FTInteger, 20, 0);
  DBFAddField(hTankDBF, "elevation", FTDouble, 16, 3);
  DBFAddField(hTankDBF, "result_dem", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "result_hea", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "result_pre", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "initiallev", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "minimumlev", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "maximumlev", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "diameter", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "minimumvol", FTDouble, 16, 8);
  DBFAddField(hTankDBF, "volumecurv", FTString, 16, 0);
  num_tanks = 0;
  return 0;
}

/**
 * Create a point shapefile with the necessary field structure.
 */
int create_reservoir_shapefile(char *filename) {
  hReservoirSHP = SHPCreate(filename, SHPT_POINT);
  hReservoirDBF = DBFCreate(filename);
  if(hReservoirSHP == NULL || hReservoirDBF == NULL) {
    /* TODO: close other shapefiles */
    fprintf(stderr, "FATAL ERROR: Unable to create file '%s'.\n", filename);
    exit_inp2shp(1);
  }
  DBFAddField(hReservoirDBF, "dc_id", FTString, 16, 0);
  DBFAddField(hReservoirDBF, "installati", FTString, 16, 0);
  DBFAddField(hReservoirDBF, "abandon_da", FTString, 16, 0);
  DBFAddField(hReservoirDBF, "dcsubtype", FTInteger, 16, 0);
  DBFAddField(hReservoirDBF, "bitcodezon", FTInteger, 20, 0);
  DBFAddField(hReservoirDBF, "elevation", FTDouble, 16, 3);
  DBFAddField(hReservoirDBF, "result_dem", FTDouble, 16, 8);
  DBFAddField(hReservoirDBF, "result_hea", FTDouble, 16, 8);
  DBFAddField(hReservoirDBF, "result_pre", FTDouble, 16, 8);
  DBFAddField(hReservoirDBF, "head", FTDouble, 16, 8);
  DBFAddField(hReservoirDBF, "pattern", FTString, 16, 0);
  num_reservoirs = 0;
  return 0;
}

/**
 * Create a point shapefile with the necessary field structure.
 */
int create_pump_shapefile(char *filename) {
  hPumpSHP = SHPCreate(filename, SHPT_POINT);
  hPumpDBF = DBFCreate(filename);
  if(hPumpSHP == NULL || hPumpDBF == NULL) {
    fprintf(stderr, "FATAL ERROR: Unable to create file '%s'.\n", filename);
    exit_inp2shp(1);
  }
  DBFAddField(hPumpDBF, "dc_id", FTString, 16, 0);
  DBFAddField(hPumpDBF, "installati", FTString, 16, 0);
  DBFAddField(hPumpDBF, "abandon_da", FTString, 16, 0);
  DBFAddField(hPumpDBF, "dcsubtype", FTInteger, 16, 0);
  DBFAddField(hPumpDBF, "bitcodezon", FTInteger, 20, 0);
  DBFAddField(hPumpDBF, "elevation", FTDouble, 16, 3);
  DBFAddField(hPumpDBF, "result_dem", FTDouble, 16, 8);
  DBFAddField(hPumpDBF, "result_hea", FTDouble, 16, 8);
  DBFAddField(hPumpDBF, "result_pre", FTDouble, 16, 8);
  DBFAddField(hPumpDBF, "result_flo", FTDouble, 16, 8);
  DBFAddField(hPumpDBF, "result_vel", FTDouble, 16, 8);
  /* DBFAddField(hPumpDBF, "result_hea", FTDouble, 16, 8); */
  DBFAddField(hPumpDBF, "properties", FTString, 200, 0);
  DBFAddField(hPumpDBF, "power_kw", FTInteger, 16,0);
  num_pumps = 0;
  return 0;
}

/**
 * Create a point shapefile with the necessary field structure.
 */
int create_valve_shapefile(char *filename) {
  hValveSHP = SHPCreate(filename, SHPT_POINT);
  hValveDBF = DBFCreate(filename);
  if(hValveSHP == NULL || hValveDBF == NULL) {
    fprintf(stderr, "FATAL ERROR: Unable to create file '%s'.\n", filename);
    exit_inp2shp(1);
  }
  DBFAddField(hValveDBF, "dc_id", FTString, 16, 0);
  DBFAddField(hValveDBF, "installati", FTString, 16, 0);
  DBFAddField(hValveDBF, "abandon_da", FTString, 16, 0);
  DBFAddField(hValveDBF, "dcsubtype", FTInteger, 16, 0);
  DBFAddField(hValveDBF, "bitcodezon", FTInteger, 20, 0);
  DBFAddField(hValveDBF, "elevation", FTDouble, 16, 3);
  DBFAddField(hValveDBF, "result_dem", FTDouble, 16, 8);
  DBFAddField(hValveDBF, "result_hea", FTDouble, 16, 8);
  DBFAddField(hValveDBF, "result_pre", FTDouble, 16, 8);
  DBFAddField(hValveDBF, "result_flo", FTDouble, 16, 8);
  DBFAddField(hValveDBF, "result_vel", FTDouble, 16, 8);
  /* DBFAddField(hValveDBF, "result_hea", FTDouble, 16, 8); */
  DBFAddField(hValveDBF, "diameter", FTInteger, 20, 0);
  DBFAddField(hValveDBF, "type", FTString, 16,0);
  DBFAddField(hValveDBF, "setting", FTString, 16, 0);
  DBFAddField(hValveDBF, "minorloss", FTDouble, 16, 8);
  num_valves = 0;
  return 0;
}

/**
 * Create a polyline shapefile with the necessary field structure. 
 */
int create_pipe_shapefile(char *filename) {
  hPipeSHP = SHPCreate(filename, SHPT_ARC);
  hPipeDBF = DBFCreate(filename);
  if(hPipeSHP == NULL || hPipeDBF == NULL) {
    fprintf(stderr, "FATAL ERROR: Unable to create file '%s'.\n", filename);
    exit_inp2shp(1);
  }
  DBFAddField(hPipeDBF, "dc_id", FTString, 16, 0);
  DBFAddField(hPipeDBF, "installati", FTString, 16, 0);
  DBFAddField(hPipeDBF, "abandon_da", FTString, 16, 0);
  DBFAddField(hPipeDBF, "dcsubtype", FTInteger, 16, 0);
  DBFAddField(hPipeDBF, "bitcodezon", FTInteger, 20, 0);
  DBFAddField(hPipeDBF, "diameter", FTInteger, 16, 0);
  DBFAddField(hPipeDBF, "node1", FTString, 16, 0);
  DBFAddField(hPipeDBF, "node2", FTString, 16, 0);
  DBFAddField(hPipeDBF, "roughness", FTDouble, 16, 8);
  DBFAddField(hPipeDBF, "minorloss", FTDouble, 16, 8);
  DBFAddField(hPipeDBF, "status", FTString, 128, 0);
  DBFAddField(hPipeDBF, "result_flow", FTDouble, 16, 8);
  DBFAddField(hPipeDBF, "result_velo", FTDouble, 16, 8);
  DBFAddField(hPipeDBF, "result_hea", FTDouble, 16, 8);
  num_pipes = 0;
  return 0;
}

/**
 * Determines which keyword appears on input line.
 * @param line is a pointer to a string; line from input file.
 * @param keyword is a pointer to a string array of  terminated keywords
 * @return Index of matching keyword or -1 if no match found.
 */
int  findmatch(char *line, char *keyword[]) {
   int i = 0;
   while (keyword[i] != NULL)
   {
      if (match(line,keyword[i])) return(i);
      i++;
   }
   return(-1);
}                        /* end of findmatch */


/**
 * Sees if substr matches any part of str. Not case sensitive.
 * @param str Pointer to the string being searched.
 * @param substr Pointer to the substring being searched for.
 * @return 1 if substr found in str, 0 if not.
 */
int  match(char *str, char *substr)

{
   int i,j;

/*** Updated 9/7/00 ***/
/* Fail if substring is empty */
   if (!substr[0]) return(0);

/* Skip leading blanks of str. */
   for (i=0; str[i]; i++)
     if (str[i] != ' ') break;

/* Check if substr matches remainder of str. */
   for (i=i,j=0; substr[j]; i++,j++)
      if (!str[i] || UCHAR(str[i]) != UCHAR(substr[j]))
         return(0);
   return(1);
}                        /* end of match */

/** 
 * Scans string for tokens, saving pointers to them in module global variable 
 * Tok[].
 * Tokens can be separated by the characters listed in SEPSTR
 * (spaces, tabs, newline, carriage return) which is defined
 * in TYPES.H. Text between quotes is treated as a single token.
 *  @param s Pointer to string to be tokenized.
 *  @return Number of tokens in s.
 */
int  gettokens(char *s) {
   int  len, m, n;
   char *c;

/* Begin with no tokens */
   for (n=0; n<MAXTOKS; n++) Tok[n] = NULL;
   n = 0;

/* Truncate s at start of comment */
   c = (char *) strchr(s,';');
   if (c) *c = '\0';
   len = strlen(s);

/* Scan s for tokens until nothing left */
   while (len > 0 && n < MAXTOKS)
   {
       m = strcspn(s,SEPSTR);          /* Find token length */
       len -= m+1;                     /* Update length of s */
       if (m == 0) s++;                /* No token found */
       else
       {
          if (*s == '"')               /* Token begins with quote */
          {
             s++;                      /* Start token after quote */
             m = strcspn(s,"\"\n\r");  /* Find end quote (or EOL) */
          }                            
          s[m] = '\0';                 /* Null-terminate the token */
          Tok[n] = s;                  /* Save pointer to token */
          n++;                         /* Update token count */
          s += m+1;                    /* Begin next token */
       }
   }
   return(n);
}                        /* End of gettokens */

/**
 * Print statistics about the generated shapefiles.
 * \todo Check WARNING about dropped junctions and pipes.
 * @return Nothing.
 */
void print_statistics() {
  /**
   * Total number of junctions as reported by the EPANET toolkit.
   */
  int total_junctions = 0;
  int total_pipes = 0;
  int total_tanks = 0;
  int total_reservoirs = 0;
  int total_pumps = 0;
  int total_valves = 0;
  int total_virtual_lines = 0;
  int type;
  int i = 1;
  
  do {
    ENgetnodetype(i, &type);
    i++;
    switch(type) {
      case EN_JUNCTION: total_junctions++;
      break;
      case EN_RESERVOIR: total_reservoirs++;
      break;
      case EN_TANK: total_tanks++;
      break;
    }
  } while(type != -1);
  i = 1;
  do {
    ENgetlinktype(i, &type);
    i++;
    switch(type) {
      case EN_PIPE: total_pipes++; 
      break;
      case EN_PUMP: total_pipes += 2;
        total_pumps++;
      break;
      case EN_CVPIPE:
      case EN_PRV:
      case EN_PSV:
      case EN_PBV:
      case EN_FCV:
      case EN_TCV:
      case EN_GPV: total_pipes += 2;
        total_valves++;
      break;
    }
  } while(type != -1);
  total_virtual_lines = total_pumps + total_valves;
  if(num_junctions > 0)
    printf("Wrote %d junctions to \"%s\".\n", num_junctions, junctions_name);
  if(num_junctions + (2 * total_virtual_lines) < total_junctions) {
    fprintf(stderr, "WARNING: Dropped %d junctions without coordinates.\n", 
      total_junctions - (num_junctions+(2*total_virtual_lines))); 
  }
  if(num_pipes > 0) 
    printf("Wrote %d pipes to \"%s\".\n", num_pipes, pipes_name);
  if(num_pipes + (2 * total_virtual_lines) < total_pipes) {
    fprintf(stderr, "WARNING: Dropped %d pipes without coordinates.\n",
      total_pipes - (num_pipes+(2*total_virtual_lines)));
  }
  if(num_reservoirs > 0)
    printf("Wrote %d reservoirs to \"%s\".\n", num_reservoirs, reservoirs_name);
  if(num_tanks > 0)
    printf("Wrote %d tanks to \"%s\".\n", num_tanks, tanks_name);
  if(num_pumps > 0)
    printf("Wrote %d pumps to \"%s\".\n", num_pumps, pumps_name);
  if(num_valves > 0)
    printf("Wrote %d valves to \"%s\".\n", num_valves, valves_name);
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
   
