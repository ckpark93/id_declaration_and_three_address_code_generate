/* regexp definitions */
digit [0-9]
alpha [A-Za-z]
identifier {alpha}({alpha}|{digit})*
number {digit}+(\.{digit}+)?(E[+\-]?{digit}+)?
%%
{number} {
	  return NUMBER;
}

"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"int" {return INT;}
"float" {return FLOAT;}
";" {return SE;}
"\n" {return EOL;}
{identifier} {return ID;}
"=" {return ASSIGN;}
%%

