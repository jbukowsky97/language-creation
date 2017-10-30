%{
/*
 * Sample Lex/Flex file.
 * from a wonderful tutorial from
 * IBM's Knowledge Center
 * https://www.ibm.com/support/knowledgecenter/en/ssw_aix_61/com.ibm.aix.genprogc/ie_prog_4lex_yacc.htm
 *
 */

#include <stdio.h>
#include "zoomjoystrong.h"
#include "zoomjoystrong.tab.h"

int yyerror(char* s);

%}

%%
end             { return END; }
;               { return END_STATEMENT; }
point           { return POINT; }
line            { return LINE; }
circle          { return CIRCLE; }
rectangle       { return RECTANGLE; }
set_color       { return SET_COLOR; }
-?[0-9]+        {
                  yylval.i = atoi(yytext);
                  return INT;
                }
[0-9]*\.[0-9]+  {
                  yylval.f = atof(yytext);
                  return FLOAT;
                }
[ \t\n\r]       ;
.               {
                  yyerror("invalid token");
                  finish();
                  return(5);
                }
%%