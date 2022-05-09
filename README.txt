AMAN

To compile and run the program: 
bison -d cucu.y
flex cucu.l
gcc cucu.tab.c lex.yy.c -lfl -o cucu
./cucu Sample1.cu

NOTE: Used gcc for compiling

cucu.l: 
Prints all the neccessary encoutered tokens
in the "Lexer.txt "file.
ASSUMPTIONS: 
 - String will only accept space, numbers and alphabets (both uppercase and lowercase) 
   i.e. [a-zA-Z0-9 ]. Eg: "aman 1911"
 - Both single and multiline comments are allowed and the parser will skip it.
 - int and char * data types are considered

cucu.y:
It will take input from "Sample1.cu" or "Sample2.cu" file, 
  eg ./cucu Sample1.cu or ./cucu Sample2.cu

Output from the lexer (based on the tokens) will be printed in "Lexer.txt" file.
Output from the parser (based on the BNF grammar) will be printed in "Parser.txt" file.

BNF Grammar Explanation:
Program starts:
Here you can declare and initialise variables which will be called global variables.
You can declare functions, call functions and write entire functions.
 - Function declration can have 0 or more parameters which can be int or char *,
   and return type which can be int or char *
 - Function can be directly called or can be assigned to any variable when called;
   with 0 or more parameters, which can be a variable, integer or arithmatic expression
 - When defining an entire function, it can consist of:
    - local variables of data type: int or char *
    - initialisations of any variable
    - if else statement: if will contain single comparison expression in parenthesis,
        followed by if body containing anything mentioned in this section. 
        It can have an else statement after if (not neccessarily),
        else body containing anything mentioned in this section.
    - for statement: it will contain -
            a) initialisation
            b) comparison statement
            c) update expression
        a), b) and c) will be separated by semi colons.
        for body containing anything mentioned in this section.
    - while statement: it will contain a comparison expression followed by -
        while body containing anything mentioned in this section.
    NOTE: arithmatic expressions and function calls can be compared
      Comparison statements will use either of the mentioned statements:
      - ==, !=, >=, >, <=, <
      - true or false

    - return statement: it can return any variable, integer, string, arithmatic or comparison expression

NOTE:  Some statements are right recursive and print in reverse order but are easily understandable,
       if seen properly.
    - In case of IF-ELSE statements, first it will print if comparison expression, then if body, then
      else body, then it ends (order of printing in Pareser file).
    - In case of WHILE statements, first it will print if comparison expression, then while body.
    - In case of FOR statements, print order: for initialisation, comparison, for update,
      then the for body will be printed

ASSUMPTIONS:
 - If a syntax error has occurred, the program will stop and won't continue further.
 - At a time only one variable can be declared.
    eg - int a; (accepted)
         int a=1; (accepted)
         int a, b; (rejected) - not allowed
 - In if, for and while, the comparison statements used can have only one comparison expression.
 - We CANNOT use AND/OR/XOR i.e. bitwise in comparison or arithmatic expressions.
 - Only int and char * is supported data type for variables declration/initialisation.
 - There should not be any statement after return statement, if any, it will throw a syntax error. (assumption)


THANK YOU
