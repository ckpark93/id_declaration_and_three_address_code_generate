# id_declaration_and_three_address_code_generate

A Three address code generator with id_declartion.

use example : 

$lex example.lex

$yacc example.y

$gcc y.tab.c -ll -ly

$./a.out data

$cat output



data example : 

int a;

int b;

a = 23+4+6;

b = a + 1 + 8 / 2 * a;



output example :

t0 = 23 + 4

t1 = t0 + 6

a = t1

t2 = a + 1

t3 = 8 / 2

t4 = t3 * a

t5 = t2 + t4

b = t5
