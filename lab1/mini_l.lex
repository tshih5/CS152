%{
	int lineNum = 1, colNum = 0;
	const char* reservedWords[] = {"function","beginparams","endparams","beginlocals","endlocals","beginbody","endbody","integer","array","of","if","then","endif","else","while","do","beginloop","endloop","continue","read","write","and","or","not","true","false","return"};	
	const char* wordTokens[] = {"FUNCTION","BEGIN_PARAMS","END_PARAMS","BEGIN_LOCALS","END_LOCALS","BEGIN_BODY","END_BODY","INTEGER","ARRAY","OF","IF","THEN","ENDIF","ELSE","WHILE","DO","BEGINLOOP","ENDLOOP","CONTINUE","READ","WRITE","AND","OR","NOT","TRUE","FALSE","RETURN"};
	const unsigned reservedSize = 27;
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

{NEWLINE} {colNum = 0; lineNum++;}

{WHITESPACE}+ {colNum += yyleng;}

{NUMBER} {colNum += yyleng; printf("NUMBER %s\n", yytext);}

{COMMENT}{NEWLINE} {
	lineNum++;
	colNum = 0;
}

{ARITHMETIC} {
	colNum ++;
	if(!strcmp(yytext, "-")){
		printf("SUB\n");
	}else if(!strcmp(yytext, "+")){
		printf("ADD\n");
	}else if(!strcmp(yytext, "*")){
		printf("MULT\n");
	}else if(!strcmp(yytext, "/")){
		printf("DIV\n");
	}else if(!strcmp(yytext, "%")){
		printf("MOD\n");
	}else{
		printf("Invalid Arithmetic Operator\n");
		exit(1);
	}
}

{SPECIALSYMBOLS} {
	colNum += yyleng;
	if(!strcmp(yytext, ";")){
		printf("SEMICOLON\n");
	}else if(!strcmp(yytext, ":")){
		printf("COLON\n");
	}else if(!strcmp(yytext, ",")){
		printf("COMMA\n");
	}else if(!strcmp(yytext, "(")){
		printf("L_PAREN\n");
	}else if(!strcmp(yytext, ")")){
		printf("R_PAREN\n");
	}else if(!strcmp(yytext, "[")){
		printf("L_SQUARE_BRACKET\n");
	}else if(!strcmp(yytext, "]")){
		printf("R_SQUARE_BRACKET\n");
	}else if(!strcmp(yytext, ":=")){
		printf("ASSIGN\n");
	}else{
		printf("Invalid Arithmetic Operator\n");
		exit(1);
	}
}

{COMPARISON} {
	colNum += yyleng;
	if(!strcmp(yytext, "==")){
		printf("EQ\n");
	}else if(!strcmp(yytext, "<")){
		printf("LT\n");
	}else if(!strcmp(yytext, ">")){
		printf("GT\n");
	}else if(!strcmp(yytext, "<=")){
		printf("LTE\n");
	}else if(!strcmp(yytext, ">=")){
		printf("GTE\n");
	}else if(!strcmp(yytext, "<>")){
		printf("NEQ\n");
	}else{
		printf("Invalid Comparison Operator\n");
		exit(1);
	}
}

{IDENTIFIER} {
	colNum += yyleng;
	unsigned i;
	int reserved = 0;
	for(i = 0; i < 27; ++i){
		if(!strcmp(yytext,reservedWords[i])){
			printf("%s\n", wordTokens[i]);
			reserved = 1;
		}
	}
	if(reserved == 0){
		printf("IDENT %s\n", yytext);
	}
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
	
}
