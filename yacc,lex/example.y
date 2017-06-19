%{
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
int err_no=0, fl=0, i = 0, j = 0, type[100];
char symbol[100][100], temp[100];
int tempnum = 0;
int out;

char tempstring[200];
char st[100][10];
int top = 0;

%}
%token ID NUMBER SE INT FLOAT EOL
%right ASSIGN
%left ADD SUB
%left MUL DIV
%left UMINUS
%%
start : L
	  | start L
	  ;

L : decl
  | expr
  | EOL
  ;
decl : INT ID{tcopy(); printf("int declare\n");insert(0);} E
	 | FLOAT ID{tcopy(); printf("float declare\n"); insert(1);} E
	 ;
stmt : stmt ADD{push();} term{codegen();}
	 | stmt SUB{push();} term{codegen();}
	 | term 
	 ;
term : term MUL{push();} factor{codegen();}
	 | term DIV{push();} factor{codegen();}
	 | factor
	 ;
factor : '('stmt')'
	   | SUB{push();}factor{codegen_umin();} %prec UMINUS
	   | ID{IDpush();}
	   | NUMBER{push();}
	   ;
expr : ID{IDpush();} ASSIGN{push();} stmt{codegen_assign();} E
	 ;
E : SE
  ;
%%
#include "lex.yy.c"
void tcopy(){
	strcpy(temp,yytext);
}

int getsym(char* search){
	for(j = 0;j<i;j++){
		if(strcmp(search,symbol[j])==0){
			return 1;
		}
	}
	return 0;
}
void writefile(){
	write(out, tempstring, strlen(tempstring));
	memset(tempstring, 0, 200);
}

void IDpush(){
if(getsym(yytext)){
	strcpy(st[++top],yytext);
	printf("id pushed! : %s\n",yytext);
}
else{
	printf("ERROR! Unknown Symbol %s\n",yytext);
	exit(1);
}
}
void push(){
strcpy(st[++top],yytext);
}

void codegen(){
	sprintf(tempstring,"t%d = %s %s %s\n",tempnum,st[top-2],st[top-1],st[top]);
	writefile();
	top-=2;
	sprintf(tempstring,"t%d",tempnum);
	strcpy(st[top],tempstring);
	tempnum++;
}
void codegen_umin(){
	sprintf(tempstring,"t%d = -%s\n",tempnum,st[top]);
	writefile();
	top--;
	sprintf(tempstring,"t%d",tempnum);
	strcpy(st[top],tempstring);
	tempnum++;
}
void codegen_assign(){
	sprintf(tempstring,"%s = %s\n", st[top-2], st[top]);
	top-=2;
	writefile();
}
	
int yyerror(char const* str){
	extern char * yytext;
	fprintf(stderr ,"parser error near %s\n", yytext);
	return 0;
}
void insert(int input){
	fl = 0;
	for(j = 0;j<i;j++){
		if(strcmp(temp,symbol[j])==0){
			if(type[i]==input){
				printf("ERROR! %s is already declared\n",temp);
				exit(1);
				}
			else{
				printf("ERROR! Multiple Declaration of Varible\n");
				err_no=1;
				exit(1);
			}
			fl = 1;
		}
	}
	if(fl == 0){
		printf("%s is inserted\n",temp);
		type[i]=input;
		strcpy(symbol[i],temp);
		i++;
	}
}

int main(int argc, char **argv){
	extern int yyparse(void);
	extern FILE *yyin;
		
	yyin = fopen(argv[1],"r+");
	if(yyin == NULL)
	printf("file error\n");
	out = open("output",O_CREAT | O_RDWR | O_TRUNC , 00777);

	
	while(yyparse()){
		fprintf(stderr,"Error! at parsing\n");
		exit(1);
	}
}
