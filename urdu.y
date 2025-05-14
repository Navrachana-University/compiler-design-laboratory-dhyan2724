%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;  // Declare yyin as an external variable provided by Flex

// Symbol table implementation
#define MAX_SYMBOLS 100
typedef struct {
    char *name;
    int value;
} Symbol;

Symbol symbols[MAX_SYMBOLS];
int symbol_count = 0;

// TAC generation variables
int temp_count = 1;  // Counter for temporary variables (t1, t2, ...)
int label_count = 1; // Counter for labels (L1, L2, ...)

int get_symbol_value(char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            return symbols[i].value;
        }
    }
    fprintf(stderr, "Warning: Undefined variable %s\n", name);
    return 0;
}

void set_symbol(char *name, int value) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            symbols[i].value = value;
            return;
        }
    }
    if (symbol_count < MAX_SYMBOLS) {
        symbols[symbol_count].name = strdup(name);
        symbols[symbol_count].value = value;
        symbol_count++;
    } else {
        fprintf(stderr, "Error: Symbol table full\n");
    }
}

// Generate a new temporary variable name
char* new_temp() {
    char *temp = malloc(10);
    snprintf(temp, 10, "t%d", temp_count++);
    return temp;
}

// Generate a new label name
char* new_label() {
    char *label = malloc(10);
    snprintf(label, 10, "L%d", label_count++);
    return label;
}

void yyerror(const char *s);
int yylex(void);
%}

%union {
    int num;
    char* str;
    int bool_val;
}

%token <num> NUMBER
%token <str> STRING
%token <str> ID
%token VAR IF THEN ELSE END PRINT EQ ASSIGN SEMI

%type <bool_val> expr
%type <str> stmt

%left EQ
%left ASSIGN

%%

program:
    statements
    ;

statements:
    statements stmt
    | stmt
    ;

stmt:
    VAR ID ASSIGN NUMBER SEMI {
        set_symbol($2, $4); // Update symbol table
        printf("%s = %d\n", $2, $4); // Emit TAC: x = 8
        $$ = "Variable assignment";
    }
    | IF expr THEN stmt END {
        char *label_end = new_label();
        printf("if t%d goto %s\n", temp_count-1, label_end); // Use last temp from expr
        printf("%s:\n", label_end); // End of IF block
        free(label_end);
        $$ = "If statement";
    }
    | IF expr THEN stmt ELSE stmt END {
        char *label_then = new_label();
        char *label_else = new_label();
        char *label_end = new_label();
        printf("if t%d goto %s\n", temp_count-1, label_then); // Use last temp from expr
        printf("goto %s\n", label_else); // Jump to ELSE
        printf("%s:\n", label_then); // THEN block label
        // THEN block TAC is already emitted by stmt
        printf("goto %s\n", label_end); // Skip ELSE block
        printf("%s:\n", label_else); // ELSE block label
        // ELSE block TAC is already emitted by stmt
        printf("%s:\n", label_end); // End of IF-ELSE
        free(label_then);
        free(label_else);
        free(label_end);
        $$ = "If-Else statement";
    }
    | PRINT STRING SEMI {
        printf("print \"%s\"\n", $2); // Emit TAC: print "string"
        $$ = "Print statement";
    }
    ;

expr:
    NUMBER EQ NUMBER {
        char *temp = new_temp();
        printf("%s = %d == %d\n", temp, $1, $3); // Emit TAC: t1 = 5 == 5
        $$ = ($1 == $3); // Evaluate for parser logic
        free(temp);
    }
    | ID EQ NUMBER {
        char *temp = new_temp();
        int val = get_symbol_value($1);
        printf("%s = %s == %d\n", temp, $1, $3); // Emit TAC: t1 = x == 5
        $$ = (val == $3); // Evaluate for parser logic
        // Temp is reused in IF stmt rules
    }
    ;

%%

int main(void) {
    FILE *input = fopen("code.urdu", "r");
    if (!input) {
        fprintf(stderr, "Error: Could not open code.urdu\n");
        return 1;
    }
    yyin = input;  // Set Flex to read from file
    printf("Three-address code:\n");
    yyparse();
    fclose(input);
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}