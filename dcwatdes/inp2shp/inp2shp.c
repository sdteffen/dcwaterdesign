/*
  parse nodes  - necessary ?
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

char *SectTxt[]         = {"[COORDINATES]", "[VERTICES]", "[END]",
  			   "[PIPES]",
                           NULL};

FILE *InFile;
SHPHandle   hSHP;
DBFHandle   hDBF;

SHPHandle hPipeSHP;
DBFHandle hPipeDBF;  

char   *Tok[MAXTOKS];

int num_junctions;
int num_pipes;

char vertex_line_name[16];
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
  
  DBFClose(hDBF);
  SHPClose(hSHP);
  
  SHPClose(hPipeSHP);
  DBFClose(hPipeDBF);
  
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
   /* TODO: performance increae with SHPGetInfo */
   shape = SHPReadObject(hPipeSHP, i);
   x[0] = 0;
   y[0] = 0;
   x[1] = 0;
   y[1] = 0;
   if(shape->nSHPType == SHPT_NULL) {
     SHPDestroyObject(shape);
     printf("pipe shape null at %d\n",i);
     pipe_id = DBFReadStringAttribute(hPipeDBF, i, 0);
     printf("pipe id %s\n",pipe_id);
     ENgetlinkindex(pipe_id, &pipe_index);
     ENgetlinknodes(pipe_index, &from_node, &to_node);
     printf("node %d to  %d #### x %f y %f - x %f y %f\n",from_node, to_node,node_x[from_node], node_y[from_node],
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
  } 
  printf("leaving write_node()\n");
  return 0;
}

int write_vertex() {
  int index, linktype;
      
  if(strcmp(vertex_line_name, Tok[0])) {
    if(strcmp(vertex_line_name,"")) {
      ENgetlinkindex(Tok[0], &index);
      if(index == (int) NULL) {
	printf("[COORDINATES]: link '%s' was not found\n",Tok[0]);
	return 0;
      }
      
      ENgetlinktype(index, &linktype);
      
      /*switch(linktype) {
	case EN_PIPE: write_pipe(index);
	break;
      } */
    }
    num_vertices = 0;
    strcpy(vertex_line_name, Tok[0]);
  } else {
    num_vertices++;
  }
  vertex_x[num_vertices] = atof(Tok[1]);
  vertex_y[num_vertices] = atof(Tok[2]);
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
    SHPWriteObject(hSHP, -1, shape);
    SHPDestroyObject(shape);
    DBFWriteStringAttribute(hDBF, num_junctions, 0, string);
    num_junctions++;
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

int write_pipe(int index) {
    double x, y;
    char string[MAXLINE];
    SHPObject   *shape;
    int *panParts;
      
    ENgetlinkid(index, string);
    printf("linkid %s\n",string);
    DBFWriteStringAttribute(hPipeDBF, num_pipes, 0, string);
    shape = SHPCreateSimpleObject( SHPT_ARC, num_vertices, 
                             vertex_x, vertex_y, NULL );
    SHPWriteObject(hPipeSHP, num_pipes, shape);
    SHPDestroyObject(shape);
    num_pipes++;
}


int create_junction_shapefile(char *filename) {

  hSHP = SHPCreate(filename, SHPT_POINT);
  hDBF = DBFCreate(filename);
  if(hSHP == NULL || hDBF == NULL) {
    printf("unable to create '%s'\n", filename);
    exit(1);
  }
  DBFAddField(hDBF, "dc_id", FTString, 16, 0);
  DBFAddField(hDBF, "installati", FTString, 16, 0);
  DBFAddField(hDBF, "abandon_da", FTString, 16, 0);
  DBFAddField(hDBF, "dcsubtype", FTInteger, 16, 0);
  DBFAddField(hDBF, "bitcodezon", FTInteger, 20, 0);
  DBFAddField(hDBF, "elevation", FTDouble, 16, 3);
  DBFAddField(hDBF, "result_dem", FTDouble, 16, 8);
  DBFAddField(hDBF, "result_hea", FTDouble, 16, 8);
  DBFAddField(hDBF, "result_pre", FTDouble, 16, 8);
  DBFAddField(hDBF, "demand", FTDouble, 16, 8);
  DBFAddField(hDBF, "pattern", FTString, 16, 0);
  num_junctions = 0;
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
   c = strchr(s,';');
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


