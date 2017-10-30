# language-creation
CIS 343 language creation using flex and bison files
## Requirements
linux

SDL2
## Compile
`bison -d zoomjoystrong.y`

`flex zoomjoystrong.lex`

`gcc -o zjs zoomjoystrong.c lex.yy.c zoomjoystrong.tab.c -lSDL2 -lm`
## Example Run
./zjs < sample.zjs
