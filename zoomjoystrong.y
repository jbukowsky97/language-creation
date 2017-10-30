%{
/*
 * Sample Yacc/Bison file
 * From a wonderful tutorial in
 * IBM's knowledge base.
 * https://www.ibm.com/support/knowledgecenter/en/ssw_aix_61/com.ibm.aix.genprogc/ie_prog_4lex_yacc.htm
 */

#include <stdio.h>
#include "zoomjoystrong.h"

int yylex();
int yyerror();
int inbounds(int x, int y);

%}

%start program

%union { int i; float f; }


%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token <i> INT
%token FLOAT

/* %left '|'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%left UMINUS  supplies precedence for unary minus */

%%                   /* beginning of rules section */

program:
          statement_list end
          {
          }
          ;
end:
          END END_STATEMENT {
            
          }
          ;
statement_list:
          statement statement_list
          |
          statement
          ;
statement:
          command END_STATEMENT
          ;
command:
          line_command
          |
          point_command
          |
          circle_command
          |
          rectangle_command
          |
          set_color_command
          ;
line_command:
          LINE INT INT INT INT
          {
            int inbounds1 = inbounds($2, $3);
            int inbounds2 = inbounds($4, $5);
            if (inbounds1 == 0 && inbounds2 == 0) {
              yyerror("line out of bounds");
            }else {
              line($2, $3, $4, $5);
            }
          }
          ;
point_command:
          POINT INT INT
          {
            int inbounds1 = inbounds($2, $3);
            if (inbounds1 == 0) {
              yyerror("point out of bounds");
            }else {
              point($2, $3);
            }
          }
          ;
circle_command:
          CIRCLE INT INT INT
          {
            int inbounds1 = 0;
            for(float i=0; i<2 * 3.14; i+=.01){
              float u = $2 + $4 * cos(i);
              float v = $3 + $4 * sin(i);
              if (inbounds((int) u, (int) v) == 1) {
                inbounds1 = 1;
              }
            }
            if (inbounds1 == 0) {
              yyerror("circle out of bounds");
            }else {
              circle($2, $3, $4);
            }
          }
          ;
rectangle_command:
          RECTANGLE INT INT INT INT
          {
            int inbounds1 = inbounds($2, $3);
            int inbounds2 = inbounds($2 + $4, $3);
            int inbounds3 = inbounds($2, $3 + $5);
            int inbounds4 = inbounds($2 + $4, $3 + $5);
            if (inbounds1 == 0 && inbounds2 == 0 && inbounds3 == 0 && inbounds4 == 0) {
              yyerror("rectangle out of bounds");
            }else {
              rectangle($2, $3, $4, $5);
            }
          }
          ;
set_color_command:
          SET_COLOR INT INT INT
          {
            if ($2 < 0 || $2 > 255 || $3 < 0 || $3 > 255 || $4 < 0 || $4 > 255) {
              yyerror("color rgb value does not conform to 0 <= val <= 255");
            }else {
              set_color($2, $3, $4);
            }
          }
          ;
%%
int main(int argc, char** argv)
{
  setup();
  int result = yyparse();
  if (result != 0) {
    return(result);
  }
  finish();
  return(0);
}

int yyerror(char * s)
{
  fprintf(stderr, "%s\n",s);
}

int yywrap()
{
  return(1);
}

int inbounds(int x, int y) {
  return (x >= 0 && x <= WIDTH && y >= 0 && y <= HEIGHT);
}