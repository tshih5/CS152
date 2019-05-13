%{
	#include "y.tab.h"
	int lineNum = 1, colNum = 0;
	//const char* reservedWords[] = {"function","beginparams","endparams","beginlocals","endlocals","beginbody","endbody","integer","array","of","if","then","endif","else","while","do","beginloop","endloop","continue","read","write","and","or","not","true","false","return"};	
	//const char* wordTokens[] = {"FUNCTION","BEGIN_PARAMS","END_PARAMS","BEGIN_LOCALS","END_LOCALS","BEGIN_BODY","END_BODY","INTEGER","ARRAY","OF","IF","THEN","ENDIF","ELSE","WHILE","DO","BEGINLOOP","ENDLOOP","CONTINUE","READ","WRITE","AND","OR","NOT","TRUE","FALSE","RETURN"};
	//const unsigned reservedSize = 27;
%}

NEWLINE 	\n
COMMENT 	##.*
WHITESPACE 	[ \t]
ARITHMETIC 	[\+\-*/%]
COMPARISON 	==|<|>|<=|>=|<>
DIGIT		[0-9]
LETTER		[a-zA-Z]
NUMBER		0|[1-9]{DIGIT}*
IDENTIFIER 	(_|{LETTER})+({LETTER}|{DIGIT}|_)*
SPECIALSYMBOLS 	;|:|,|\(|\)|\[|\]|:=
INVALIDIDENT 	({DIGIT})*({IDENTIFIER})_+|({DIGIT})+({IDENTIFIER})_*
UNIDENTIFIED 	.

%%
"function"              {colNum += yyleng; return FUNCTION;}
"beginparams"           {colNum += yyleng; return BEGIN_PARAMS;}
"endparams"             {colNum += yyleng; return END_PARAMS;}
"beginlocals"           {colNum += yyleng; return BEGIN_LOCALS;}
"endlocals"	        	{colNum += yyleng; return END_LOCALS;}
"integer"      	        {colNum += yyleng; return INTEGER;}
"array"					{colNum += yyleng; return ARRAY;}
"of"					{colNum += yyleng; return OF;}
"if"					{colNum += yyleng; return IF;}
"then"					{colNum += yyleng; return THEN;}
"endif"					{colNum += yyleng; return ENDIF;}
"else"					{colNum += yyleng; return ELSE;}
"while"					{colNum += yyleng; return WHILE;}
"do"					{colNum += yyleng; return DO;}
"beginbody"				{colNum += yyleng; return BEGIN_BODY;}
"endbody"				{colNum += yyleng; return END_BODY;}
"beginloop"				{colNum += yyleng; return BEGINLOOP;}
"endloop"				{colNum += yyleng; return ENDLOOP;}
"continue"				{colNum += yyleng; return CONTINUE;}
"read"					{colNum += yyleng; return READ;}
"write"					{colNum += yyleng; return WRITE;}
"and"					{colNum += yyleng; return AND;}
"or"					{colNum += yyleng; return OR;}
"not"					{colNum += yyleng; return NOT;}
"true"					{colNum += yyleng; return TRUE;}
"false"					{colNum += yyleng; return FALSE;}
"return"				{colNum += yyleng; return RETURN;}
{NEWLINE} {colNum = 0; lineNum++;}

{WHITESPACE}+ {colNum += yyleng;}

{NUMBER} {colNum += yyleng; /*printf("NUMBER %s\n", yytext);*/ yylval.int_val = atoi(yytext); return NUMBER;}

{COMMENT}{NEWLINE} {
	lineNum++;
	colNum = 0;
}

{ARITHMETIC} {
	colNum ++;
	if(!strcmp(yytext, "-")){
		return SUB;
	}else if(!strcmp(yytext, "+")){
		return ADD;
	}else if(!strcmp(yytext, "*")){
		return MULT;
	}else if(!strcmp(yytext, "/")){
		return DIV;
	}else if(!strcmp(yytext, "%")){
		return MOD;
	}else{
		printf("Invalid Arithmetic Operator\n");
		exit(1);
	}
}

{SPECIALSYMBOLS} {
	colNum += yyleng;
	if(!strcmp(yytext, ";")){
		return SEMICOLON;
	}else if(!strcmp(yytext, ":")){
		return COLON;
	}else if(!strcmp(yytext, ",")){
		return COMMA;
	}else if(!strcmp(yytext, "(")){
		return L_PAREN;
	}else if(!strcmp(yytext, ")")){
		return R_PAREN;
	}else if(!strcmp(yytext, "[")){
		return L_SQUARE_BRACKET;
	}else if(!strcmp(yytext, "]")){
		return R_SQUARE_BRACKET;
	}else if(!strcmp(yytext, ":=")){
		return ASSIGN;
	}else{
		printf("Invalid Arithmetic Operator\n");
		exit(1);
	}
}

{COMPARISON} {
	colNum += yyleng;
	if(!strcmp(yytext, "==")){
		return EQ;
	}else if(!strcmp(yytext, "<")){
		return LT;
	}else if(!strcmp(yytext, ">")){
		return GT;
	}else if(!strcmp(yytext, "<=")){
		return LTE;
	}else if(!strcmp(yytext, ">=")){
		return GTE;
	}else if(!strcmp(yytext, "<>")){
		return NEQ;
	}else{
		printf("Invalid Comparison Operator\n");
		exit(1);
	}
}

{IDENTIFIER} {
	colNum += yyleng;
	//printf("\n\nFROM MINI_L.LEX IDENT %s\n\n", yytext);
	yylval.ident = yytext;
	return IDENT;
}

{UNIDENTIFIED} {
	printf("Invalid Character %s on line %d, col %d\n", yytext, lineNum, colNum);
	exit(1);
}

{INVALIDIDENT} {
	printf("Invalid Identifier %s on line %d, col %d\n", yytext, lineNum, colNum);
	exit(1);
}



%%
/*
int main(int argc, char* argv[]){
	if(argc == 2){
		yyin = fopen(argv[1], "r");
		if (yyin == 0){
			printf("Error opening file! %s", argv[1]);
			exit(1);
		}
	}else{
		yyin = stdin;
	}
	yylex();
	return 0;
	
}*/

