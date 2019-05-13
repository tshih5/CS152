/* CS 152 Project Phase 2 (language parser) */
/* Tom Shih */

%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char *s);
    extern int lineNum, colNum;
    FILE *yyin;
%}

%union{
  int		int_val;
  char* 	ident;
}

%error-verbose
%start  prog_start
%type 	<int_val> NUMBER
%type	<ident>	IDENT
%left 	NUMBER IDENT
%token  FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY
%token  INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO BEGINLOOP ENDLOOP CONTINUE
%token  READ WRITE TRUE FALSE RETURN 
%token  SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET
%left	AND OR NOT
%left   SUB ADD MULT DIV MOD
%left   EQ NEQ LT GT LTE GTE
%right ASSIGN

%%
prog_start:
    function_loop
    {printf("prog_start -> function loop\n");}
    ;

function_loop:
    /*empty*/ 
    {printf("function_loop -> epsilon\n");}
    | function function_loop
    {printf("function_loop -> function function_loop\n");}
    ;

function:
    FUNCTION IDENT SEMICOLON BEGIN_PARAMS declaration_loop END_PARAMS BEGIN_LOCALS declaration_loop END_LOCALS BEGIN_BODY statement_loop END_BODY
    {printf("function -> FUNCTION IDENT SEMICOLON BEGIN_PARAMS declaration_loop ENDPARAMS BEGIN_LOCALS declaration_loop END_LOCALS BEGIN_BODY statement_loop END_BODY\n");}
    ;

declaration_loop:
   /*empty*/ 
   {printf("declaration_loop -> epsilon\n");}
   | declaration  SEMICOLON declaration_loop
   {printf("declaration_loop -> declaration SEMICOLON declaration_loop\n");}
   ;

declaration:
    id_loop COLON INTEGER
    {printf("declaration -> id_loop COLON INTEGER\n");}
    |id_loop COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER 
    {printf("declaration -> id_loop COLON ARAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}
    ;

id_loop:
    IDENT 
    {printf("id_loop IDENT %s \n", $1);}
    | IDENT COMMA id_loop 
    {printf("id_loop -> IDENT %s COMMA id_loop\n", $1);}
    ;

statement_loop:
    /*empty*/ 
    {printf("statement_loop -> epsilon\n");}
    | statement SEMICOLON statement_loop 
    {printf("statement_loop -> statement SEMICOLON statement_loop\n");}
    ;

statement:
    var ASSIGN expression 
    {printf("statement -> var ASSIGN expression\n");}
    | IF bool_expr THEN statement_loop ENDIF 
    {printf("statement -> IF bool_epxr THEN statement_loop ENDIF\n");}
    | IF bool_expr THEN statement_loop ELSE statement_loop ENDIF 
    {printf("statement -> IF bool_expr THEN statement_loop ELSE statement_loop ENDIF\n");}
    | WHILE bool_expr BEGINLOOP statement_loop ENDLOOP 
    {printf("statement -> WHILE bool_expr BEGINLOOP statement_loop ENDLOOP\n");}
    | DO BEGINLOOP statement_loop ENDLOOP WHILE bool_expr
    {printf("statement -> DO BEGINLOOP statement_loop ENDLOOP WHILE bool_expr\n");}
    | READ var var_loop 
    {printf("statement -> READ var var_loop\n");}
    | WRITE var var_loop
    {printf("statement -> WRITE var var_loop\n");}
    | CONTINUE
    {printf("statement -> CONTINUE\n");}
    | RETURN expression
    {printf("statement -> RETURN expression");}
    ;

var_loop:
    /*empty*/
    {printf("var_loop -> epsilon\n");}
    | COMMA var var_loop
    {printf("var_loop -> COMMA var var_loop\n");}
    ;

bool_expr:
    relation_and_expr
    {printf("bool_expr -> relation_and_expr\n");}
    | bool_expr OR relation_and_expr
    {printf("bool_expr -> bool_epxr OR relation_and_expr\n");}
    ;

relation_and_expr:
    relation_expr_base
    {printf("relation_and_expr -> relation_expr_base\n");}
    | relation_and_expr AND relation_expr_base
    {printf("relation_and_expr -> relation_and_expr AND relation_expr_base\n");}
    ;

relation_expr_base:
    relation_expr
    {printf("relation_expr_base -> relation_expr\n");}
    | NOT relation_expr
    {printf("realation_expr_base -> NOT relation_expr\n");}
    ;

relation_expr:
    expression comp expression
    {printf("relation_expr -> expression comp expression\n");}
    | TRUE
    {printf("relation_expr -> TRUE\n");}
    | FALSE
    {printf("relation_expr -> FALSE\n");}
    | L_PAREN bool_expr R_PAREN
    {printf("relation_expr -> LPAREN bool_expr R_PAREN\n");}
    ;

comp:
    EQ
    {printf("comp -> EQ\n");}
    | NEQ
    {printf("comp -> NEQ\n");}
    | LT
    {printf("comp -> LT\n");}
    | GT
    {printf("comp -> GT\n");}
    | LTE
    {printf("comp -> LTE\n");}
    | GTE
    {printf("comp -> GTE\n");}
    ;

expression:
    multiplicative_expr multiplicative_expr_loop
    {printf("expression -> multiplicative_epxr multiplicative_expr_loop\n");}
    ;

multiplicative_expr_loop:
    /*empty*/
    {printf("multiplicative_expr_loop -> epsilon\n");}
    | ADD term multiplicative_expr_loop
    {printf("multiplicative_expr_loop -> ADD term multiplicative_expr_loop\n");}
    | SUB term multiplicative_expr_loop
    {printf("multiplicative_expr_loop -> SUB term multiplicative_expr_loop\n");}
    ;

multiplicative_expr:
    term term_loop
    {printf("multiplicative_expr -> term term_loop\n");}
    ;

term_loop:
    /*empty*/
    {printf("term_loop -> epsilon\n");}
    | MULT term term_loop
    {printf("term_loop -> MULT term term_loop\n");}
    | DIV term term_loop
    {printf("term_loop -> DIV term term_loop\n");}
    | MOD term term_loop
    {printf("term_loop -> MOD term term_loop\n");}
    ;
term:
    term2
    {printf("term -> term2\n");}
    | SUB term2
    {printf("term -> SUB term2\n");}
    | IDENT L_PAREN R_PAREN
    {printf("term -> IDENT %s L_PAREN R_PAREN\n", $1);}
    | IDENT L_PAREN expression expression_loop R_PAREN
    {printf("term -> IDENT %s L_PAREN expression expression_loop R_PAREN\n", $1);}
    ;
term2:
    var
    {printf("term2 -> var\n");}
    | NUMBER
    {printf("term2 -> NUMBER\n");}
    | L_PAREN expression R_PAREN
    {printf("term2 -> L_PAREN expression R_PAREN\n");}
    ;
expression_loop:
    /*empty*/
    {printf("expression_loop -> epsilon\n");}
    | COMMA expression expression_loop
    {printf("expression_loop -> COMMA expression expression_loop\n");}
    ;

var:
    IDENT
    {printf("var -> IDENT %s\n", $1);}
    | IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET
    {printf("var -> IDENT %s L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n", $1);}
    ;

%%
int yyparse();

int main(int argc, char** argv){
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if(yyin == NULL){
            printf("Error opening file: %s\n", argv[0]);
        }
    }else{
        yyin = stdin;
    }
    yyparse();
    return 0;
}

void yyerror(const char *s)
{
  extern char* yytext;
  printf("At symbol: %s \nError: Line %d, col %d: Error Message: %s\n", yytext, lineNum, colNum, s);
}
