/* inp2shp.c convert EPANET INP files to Shapefiles
  
  (c) 2002 DORSCH Consult 

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
  
  */

  /*
  parse nodes  - necessary?
  parse pipes - done
    fill with null shapes -done
  parse coordinates
    reserve node x y buffer
    order as index
  parse vertices
    get start, end vertices from node x y buffer
  build remaining pipes
    for all null shape pipes:
      get start, end vertices from node x y */

#include "epanet2.h"
#include "shapefil.h"
#include <stdlib.h>

#define MAXLINE 255
#define   SEPSTR    " \t\n\r"  /* Token separator characters */
#define   MAXTOKS   40       /* Max. items per line of input           */
#define UCHAR(x) (((x) >= 'a' && (x) <= 'z') ? ((x)&~32) : (x))

/* the following sections have to be parsed in addition
   to the toolkit parsing */
   
char *SectTxt[]         = {"[COORDINATES]", "[VERTICES]", "[END]",
  			   "[PIPES]",
                           NULL};
/* INP file */
FILE *InFile;

/* junction shapefile */
SHPHandle   hJunctionSHP;
DBFHandle   hJunctionDBF;

/* pipe shapefile */
SHPHandle hPipeSHP;
DBFHandle hPipeDBF;  

/* tank shapefile */
SHPHandle hTankSHP;
DBFHandle hTankDBF;

/* reservoir shapefile */
SHPHandle hReservoirSHP;
DBFHandle hReservoirDBF;

/* valve shapefile */
SHPHandle hValveSHP;
DBFHandle hValveDBF;

/* pump shapefile */
SHPHandle hPumpSHP;
DBFHandle hPumpDBF;

char   *Tok[MAXTOKS];

int num_junctions;
int num_pipes;
int num_tanks;
int num_reservoirs;
int num_pumps;
int num_valves;

char vertex_line_name[16];
int vertex_line_index;
int num_vertices;
double vertex_x[5000];
double vertex_y[5000];

double node_x[5000];
double node_y[5000];

int main( int argc, char ** argv ) {
 int i, nnodes;
 int error;
 char line[MAXLINE];
 char wline[MAXLINE];
 int Ntokens;
 char  *tok;                /* First token of line          */
 int newsect, sect, errcode;

 sect = -1;
 num_junctions = 0;
 num_pipes = 0;
 
 strcpy(vertex_line_name, "");
 num_vertices = 0;
  
  /* Open the file and  */
  error = ENopen(argv[1], "test.rpt", "");  
  if(error!=0) {
    printf("error opening '%s': %d\n", argv[1], error);
    ENclose();
    exit(error);
  }
  
 create_junction_shapefile("junctions.shp");
 create_pipe_shapefile("pipes.shp");
 create_tank_shapefile("tanks.shp");
 create_reservoir_shapefile("reservoirs.shp");
 create_pump_shapefile("pumps.shp");
 create_valve_shapefile("valves.shp");
  
   InFile = fopen(argv[1], "r");
   while (fgets(line, MAXLINE, InFile) != NULL)
   {
      strcpy(wline,line);
      Ntokens = gettokens(wline);
      printf("num tokens : %d\n", Ntokens);
      /* Skip blank lines and comments */
      if (Ntokens == 0) continue;
      if (*Tok[0] == ';') continue;

      /* Check if max. length exceeded */
         if (strlen(line) >= MAXLINE)
         {
            printf("line too long\n");
         }
      printf("token: %s\n",Tok[0]);
   /* Check if line begins with a new section heading */
      if (*Tok[0] == '[')
      {
	 if(sect == 1) write_pipe_shape();
	 sect = (-1);
         newsect = findmatch(Tok[0], SectTxt);
         if (newsect >= 0)
         {
	   printf("section: %d\n", newsect);
            sect = newsect;
            if (sect == 2) break;
            continue;
         }
         else continue;
      }

   /* Add to count of current component */
      switch(sect)
      {
            case 0: if(Ntokens == 3) write_node();   
	    break;
            case 1: if(Ntokens == 3) write_vertex();
	    break;
	    case 3: if(Ntokens > 3) write_null_pipe();
	    break;
      }
      /* if (errcode) break; */
   }
  
  write_remaining_pipe_shapes();
  write_pumps();
  
  DBFClose(hJunctionDBF);
  SHPClose(hJunctionSHP);
  
  SHPClose(hPipeSHP);
  DBFClose(hPipeDBF);
  
  SHPClose(hTankSHP);
  DBFClose(hTankDBF);
  
  SHPClose(hReservoirSHP);
  DBFClose(hReservoirDBF);
  
  SHPClose(hPumpSHP);
  DBFClose(hPumpDBF);
  
  SHPClose(hValveSHP);
  DBFClose(hValveDBF);
  
  ENclose(); 
}

int write_remaining_pipe_shapes() {
  int i;
  SHPObject *shape;
  int *panParts;
  double x[2], y[2];
  char *pipe_id;
  int pipe_index;
  int from_node, to_node;
      
 for(i=0; i<num_pipes; i++) {
   /* TODO: performance increase with SHPGetInfo */
   shape = SHPReadObject(hPipeSHP, i);
   x[0] = 0;
   y[0] = 0;
   x[1] = 0;
   y[1] = 0;
   if(shape->nSHPType == SHPT_NULL) {
     SHPDestroyObject(shape);
     printf("pipe shape null at %d\n",i);
     pipe_id = (char *) DBFReadStringAttribute(hPipeDBF, i, 0);
     printf("pipe id %s\n",pipe_id);
     ENgetlinkindex(pipe_id, &pipe_index);
     ENgetlinknodes(pipe_index, &from_node, &to_node);
     printf("node %d to  %d #### x %f y %f - x %f y %f\n",from_node, 
     	    to_node, node_x[from_node], node_y[from_node],
     node_x[to_node], node_y[to_node]);
     x[0] = node_x[from_node];
     y[0] = node_y[from_node];
     x[1] = node_x[to_node];
     y[1] = node_y[to_node];
     shape = SHPCreateSimpleObject( SHPT_ARC, 2, 
			   x, y, NULL );
    SHPWriteObject(hPipeSHP, i, shape);
    SHPDestroyObject(shape);
   } else {
     SHPDestroyObject(shape);
   }
 }
}

int write_pumps() {
  /* TODO: improve performance with some kind of cache */
  /* TODO: remove superfluous nodes */
  /* TODO: implement this */
  int i;
  SHPObject *shape;
  int *panParts;
  double x[2], y[2];
  char *pipe_id;
  int pipe_index;
  int from_node, to_node;
      
 for(i=0; i<num_pipes; i++) {
   /* TODO: performance increase with SHPGetInfo */
   shape = SHPReadObject(hPipeSHP, i);
   x[0] = 0;
   y[0] = 0;
   x[1] = 0;
   y[1] = 0;
   if(shape->nSHPType == SHPT_NULL) {
     SHPDestroyObject(shape);
     printf("pipe shape null at %d\n",i);
     pipe_id = (char *) DBFReadStringAttribute(hPipeDBF, i, 0);
     printf("pipe id %s\n",pipe_id);
     ENgetlinkindex(pipe_id, &pipe_index);
     ENgetlinknodes(pipe_index, &from_node, &to_node);
     printf("node %d to  %d #### x %f y %f - x %f y %f\n",from_node, 
     	    to_node, node_x[from_node], node_y[from_node],
     node_x[to_node], node_y[to_node]);
     x[0] = node_x[from_node];
     y[0] = node_y[from_node];
     x[1] = node_x[to_node];
     y[1] = node_y[to_node];
     shape = SHPCreateSimpleObject( SHPT_ARC, 2, 
			   x, y, NULL );
    SHPWriteObject(hPipeSHP, i, shape);
    SHPDestroyObject(shape);
   } else {
     SHPDestroyObject(shape);
   }
 }
}

int write_node() {
  int index, nodetype;
      
  ENgetnodeindex(Tok[0], &index);
  
  if(index == (int) NULL) {
    printf("[COORDINATES]: node '%s' was not found\n",Tok[0]);
    return 0;
  }
  
  node_x[index] = atof(Tok[1]);
  node_y[index] = atof(Tok[2]);
  
  ENgetnodetype(index, &nodetype);
  
  switch(nodetype) {
    case EN_JUNCTION: write_junction(index);
    break;
    case EN_TANK: write_tank(index);
    break;
    case EN_RESERVOIR: write_reservoir(index);
    break;
  } 
  return 0;
}

int write_vertex() {
  int linktype;
      
  if(strcmp(vertex_line_name, Tok[0]) != 0) {
      ENgetlinkindex(Tok[0], &vertex_line_index);
      if(vertex_line_index == 0) {
	printf("[COORDINATES]: link '%s' was not found\n",Tok[0]);
	return 0;
      }
      if(strcmp(vertex_line_name, "")!=0) {
	ENgetlinktype(vertex_line_index, &linktype);
	switch(linktype) {
	  case EN_PIPE: write_pipe_shape();
	  break;
	} 
      }
    num_vertices = 1;
    strcpy(vertex_line_name, Tok[0]);
  } else {
    num_vertices++;
  }
  vertex_x[num_vertices] = atof(Tok[1]);
  vertex_y[num_vertices] = atof(Tok[2]);
  printf("write_vertex() vertex_line_index: %d line name '%s'\n",vertex_line_index, vertex_line_name);
  return 0;
}

int write_junction(int index) {
    double x, y;
    char string[MAXLINE];
    SHPObject   *shape;
    int *panParts;
     
   x = atof(Tok[1]);
   y = atof(Tok[2]);
   printf("x %f y %f\n",x,y);
    
    ENgetnodeid(index, string);
    printf("nodeid %s\n",string);
  
    shape = SHPCreateSimpleObject( SHPT_POINT, 1, 
                             &x, &y, NULL );
    SHPWriteObject(hJunctionSHP, -1, shape);
    SHPDestroyObject(shape);
    DBFWriteStringAttribute(hJunctionDBF, num_junctions, 0, string);
    num_junctions++;
}

int write_tank(int index) {
    double x, y;
    char string[MAXLINE];
    SHPObject   *shape;
    int *panParts;
     
   x = atof(Tok[1]);
   y = atof(Tok[2]);
    
    ENgetnodeid(index, string);
  
    shape = SHPCreateSimpleObject( SHPT_POINT, 1, 
                             &x, &y, NULL );
    SHPWriteObject(hTankSHP, -1, shape);
    SHPDestroyObject(shape);
    DBFWriteStringAttribute(hTankDBF, num_tanks, 0, string);
    num_tanks++;
}

int write_reservoir(int index) {
    double x, y;
    char string[MAXLINE];
    SHPObject   *shape;
    int *panParts;
     
   x = atof(Tok[1]);
   y = atof(Tok[2]);
    
   ENgetnodeid(index, string);
  
   shape = SHPCreateSimpleObject( SHPT_POINT, 1, 
                             &x, &y, NULL );
   SHPWriteObject(hReservoirSHP, -1, shape);
   SHPDestroyObject(shape);
   DBFWriteStringAttribute(hReservoirDBF, num_reservoirs, 0, string);
   num_reservoirs++;
}

int write_null_pipe() {
    SHPObject   *shape;
    int *panParts;
    int index;
    double x[2], y[2];
    
    ENgetlinkindex(Tok[0], &index);
    printf("linkid %s\n", Tok[0]);
    DBFWriteStringAttribute(hPipeDBF, num_pipes, 0, Tok[0]);
    x[0] = 0;
    y[0] = 0;
    x[1] = 1;
    y[1] = 1;
    shape = SHPCreateSimpleObject( SHPT_NULL, 2, 
                             x, y, NULL );
    SHPWriteObject(hPipeSHP, -1, shape);
    SHPDestroyObject(shape);
    num_pipes++;
}

int write_pipe_shape() {
    double x, y;
    char *string;
    SHPObject   *shape;
    int *panParts;
    int to_node, from_node;
    int index = vertex_line_index;
    
    ENgetlinknodes(index, &from_node, &to_node);
    vertex_x[0] = node_x[from_node];
    vertex_y[0] = node_y[from_node];
    vertex_x[num_vertices+1] = node_x[to_node];
    vertex_y[num_vertices+1] = node_y[to_node];
    
    do {
      string = (char *) DBFReadStringAttribute(hPipeDBF, index, 0);
      index--;
    } while((strcmp(string, vertex_line_name)!=0)&&(index > 0));
    if(index != 0) {
      printf("write_pipe_shape(): linkid '%s' line_index %d\n",
      string, vertex_line_index);
      printf("num_vertices %d\n", num_vertices);
      
      shape = SHPCreateSimpleObject( SHPT_ARC, num_vertices+2, 
			       vertex_x, vertex_y, NULL );
      SHPWriteObject(hPipeSHP, index+1, shape);
      SHPDestroyObject(shape);
    }
}


int create_junction_shapefile(char *filename) {

  hJunctionSHP = SHPCreate(filename, SHPT_POINT);
  hJunctionDBF = DBFCreate(filename);
  if(hJunctionSHP == NULL || hJunctionDBF == NULL) {
    printf("unable to create '%s'\n", filename);
    exit(1);
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
}

int create_tank_shapefile(char *filename) {

  hTankSHP = SHPCreate(filename, SHPT_POINT);
  hTankDBF = DBFCreate(filename);
  if(hTankSHP == NULL || hTankDBF == NULL) {
    printf("unable to create '%s'\n", filename);
    exit(1);
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
}

int create_reservoir_shapefile(char *filename) {

  hReservoirSHP = SHPCreate(filename, SHPT_POINT);
  hReservoirDBF = DBFCreate(filename);
  if(hReservoirSHP == NULL || hReservoirDBF == NULL) {
    /* TODO: close other shapefiles */
    printf("unable to create '%s'\n", filename);
    exit(1);
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
}

int create_pump_shapefile(char *filename) {

  hPumpSHP = SHPCreate(filename, SHPT_POINT);
  hPumpDBF = DBFCreate(filename);
  if(hPumpSHP == NULL || hPumpDBF == NULL) {
    printf("unable to create '%s'\n", filename);
    exit(1);
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
}

int create_valve_shapefile(char *filename) {

  hValveSHP = SHPCreate(filename, SHPT_POINT);
  hValveDBF = DBFCreate(filename);
  if(hValveSHP == NULL || hValveDBF == NULL) {
    printf("unable to create '%s'\n", filename);
    exit(1);
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
}

int create_pipe_shapefile(char *filename) {

  hPipeSHP = SHPCreate(filename, SHPT_ARC);
  hPipeDBF = DBFCreate(filename);
  if(hPipeSHP == NULL || hPipeDBF == NULL) {
    printf("unable to create '%s'\n", filename);
    exit(1);
  }
  DBFAddField(hPipeDBF, "dc_id", FTString, 16, 0);
  DBFAddField(hPipeDBF, "installati", FTString, 16, 0);
  DBFAddField(hPipeDBF, "abandon_da", FTString, 16, 0);
  DBFAddField(hPipeDBF, "dcsubtype", FTInteger, 16, 0);
  DBFAddField(hPipeDBF, "bitcodezon", FTInteger, 20, 0);
  DBFAddField(hPipeDBF, "diameter", FTInteger, 16, 0);
  num_pipes = 0;
}

int  findmatch(char *line, char *keyword[])
/*
**--------------------------------------------------------------
**  Input:   *line      = line from input file
**           *keyword[] = list of NULL terminated keywords
**  Output:  returns index of matching keyword or
**           -1 if no match found
**  Purpose: determines which keyword appears on input line
**--------------------------------------------------------------
*/
{
   int i = 0;
   while (keyword[i] != NULL)
   {
      if (match(line,keyword[i])) return(i);
      i++;
   }
   return(-1);
}                        /* end of findmatch */



int  match(char *str, char *substr)
/*
**--------------------------------------------------------------
**  Input:   *str    = string being searched
**           *substr = substring being searched for
**  Output:  returns 1 if substr found in str, 0 if not
**  Purpose: sees if substr matches any part of str
**
**      (Not case sensitive)
**--------------------------------------------------------------
*/
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

int  gettokens(char *s)
/*
**--------------------------------------------------------------
**  Input:   *s = string to be tokenized
**  Output:  returns number of tokens in s
**  Purpose: scans string for tokens, saving pointers to them
**           in module global variable Tok[]
**
** Tokens can be separated by the characters listed in SEPSTR
** (spaces, tabs, newline, carriage return) which is defined
** in TYPES.H. Text between quotes is treated as a single token.
**--------------------------------------------------------------
*/
{
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


