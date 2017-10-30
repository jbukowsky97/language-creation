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
int yyerror(char* s);
int inbounds(int x, int y);

void set_color_cmd(int r, int g, int b);
void rectangle_cmd(int x, int y, int w, int h);
void circle_cmd(int x, int y, int r);
void point_cmd(int x, int y);
void line_cmd(int x1, int x2, int y1, int y2);

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
%token <f> FLOAT

%%

program:
          statement_list end
          ;
end:
          END END_STATEMENT
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
            line_cmd($2, $3, $4, $5);
          }
          ;
point_command:
          POINT INT INT
          {
            point_cmd($2, $3);
          }
          ;
circle_command:
          CIRCLE INT INT INT
          {
            circle_cmd($2, $3, $4);
          }
          ;
rectangle_command:
          RECTANGLE INT INT INT INT
          {
            rectangle_cmd($2, $3, $4, $5);
          }
          ;
set_color_command:
          SET_COLOR INT INT INT
          {
            set_color_cmd($2, $3, $4);
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

/*******************************
 * error handling function
 *
 * @param s string to print to
 *           to the user
 *
 * @return int status of yyerror
 *******************************/
int yyerror(char * s)
{
  fprintf(stderr, "%s\n",s);
}

/*******************************
 * yywrap implementation from ibm
 *
 * @return int status of yywrap
 *******************************/
int yywrap()
{
  return(1);
}

/*******************************
 * takes a point (x, y) and
 * determines if the point
 * is within the screen's
 * bounds or not
 *
 * @param x x-coord of point
 * @param y y-coord of point
 *
 * @return int 1 if in bounds,
 *          0 if not in bounds
 *******************************/
int inbounds(int x, int y) {
  return (x >= 0 && x <= WIDTH && y >= 0 && y <= HEIGHT);
}

/*******************************
 * sets color of SDL2 to
 * color inputed if valid color
 *
 * @param r 0-255 red coloring
 * @param g 0-255 green coloring
 * @param b 0-255 blue coloring
 *******************************/
void set_color_cmd(int r, int g, int b) {
  if (r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255) {
    yyerror("color rgb value does not conform to 0 <= val <= 255");
  }else {
    set_color(r, g, b);
  }
}

/*******************************
 * draws rectangle if any point
 * of the rectangle will be in
 * bounds
 *
 * @param x x-coord of rectangle
 * @param y y-coord of rectangle
 * @param w width of rectangle
 * @param h height of rectangle
 *******************************/
void rectangle_cmd(int x, int y, int w, int h) {
  int inbounds1 = inbounds(x, y);
  int inbounds2 = inbounds(x + w, y);
  int inbounds3 = inbounds(x, y + h);
  int inbounds4 = inbounds(x + w, y + h);
  if (inbounds1 == 0 && inbounds2 == 0 && inbounds3 == 0 && inbounds4 == 0) {
    yyerror("rectangle out of bounds");
  }else {
    rectangle(x, y, w, h);
  }
}

/*******************************
 * draws circle if any point
 * of the circle will be in
 * bounds
 *
 * @param x x-coord of circle
 * @param y y-coord of circle
 * @param r radius of circle
 *******************************/
void circle_cmd(int x, int y, int r) {
  int inbounds1 = 0;
  for(float i=0; i<2 * 3.14; i+=.01){
    float u = x + r * cos(i);
    float v = y + r * sin(i);
    if (inbounds((int) u, (int) v) == 1) {
      inbounds1 = 1;
    }
  }
  if (inbounds1 == 0) {
    yyerror("circle out of bounds");
  }else {
    circle(x, y, r);
  }
}

/*******************************
 * draws point if it is
 * in bounds
 *
 * @param x x-coord of point
 * @param y y-coord of point
 *******************************/
void point_cmd(int x, int y) {
  int inbounds1 = inbounds(x, y);
  if (inbounds1 == 0) {
    yyerror("point out of bounds");
  }else {
    point(x, y);
  }
}

/*******************************
 * draws line if the starting
 * or ending point will be in
 * bounds
 *
 * @param x1 x-coord of point1
 * @param y1 y-coord of point1
 * @param x2 x-coord of point1
 * @param y2 y-coord of point1
 *******************************/
void line_cmd(int x1, int y1, int x2, int y2) {
  int inbounds1 = inbounds(x1, y1);
  int inbounds2 = inbounds(x2, y2);
  if (inbounds1 == 0 && inbounds2 == 0) {
    yyerror("line out of bounds");
  }else {
    line(x1, y1, x2, y2);
  }
}