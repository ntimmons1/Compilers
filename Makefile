###
# This Makefile can be used to make a parser for the cimple language
# (parser.class) and to make a program (P6.class) that tests the parser and
# the unparse methods in ast.java.
#
# make clean removes all generated files.
#
# P6 makefile
#
###
JC = javac
CP = ../deps_src/java-cup-11b.jar:../deps_src/java-cup-11b-runtime.jar:../deps_src:.
FLAGS = -cp $(CP)

P6.class: P6.java parser.class Yylex.class ASTnode.class
	$(JC) $(FLAGS) -g P6.java

parser.class: parser.java ASTnode.class Yylex.class ErrMsg.class
	$(JC) $(FLAGS) parser.java

parser.java: cimple.cup
	java $(FLAGS) java_cup.Main < cimple.cup

Yylex.class: cimple.jlex.java sym.class ErrMsg.class
	$(JC) $(FLAGS) cimple.jlex.java

ASTnode.class: ast.java Type.java
	$(JC) $(FLAGS) -g ast.java

cimple.jlex.java: cimple.jlex sym.class
	java $(FLAGS) JLex.Main cimple.jlex

sym.class: sym.java
	$(JC) $(FLAGS) -g sym.java

sym.java: cimple.cup
	$(JC) $(FLAGS) java_cup.Main < cimple.cup

ErrMsg.class: ErrMsg.java
	$(JC) $(FLAGS) ErrMsg.java

Sym.class: Sym.java Type.java ast.java
	$(JC) $(FLAGS) -g Sym.java

SymTable.class: SymTable.java Sym.java DuplicateSymException.java EmptySymTableException.java
	$(JC) $(FLAGS) -g SymTable.java

Type.class: Type.java
	$(JC) $(FLAGS) -g Type.java

DuplicateSymException.class: DuplicateSymException.java
	$(JC) $(FLAGS) -g DuplicateSymException.java

EmptySymTableException.class: EmptySymTableException.java
	$(JC) $(FLAGS) -g EmptySymTableException.java

###
# test
###
test:
	java $(FLAGS) P6 test1.in test1.out spim1.s
	java $(FLAGS) P6 test2.in test2.out spim2.s
	java $(FLAGS) P6 test3.in test3.out spim3.s
	java $(FLAGS) P6 test4.in test4.out spim4.s
	java $(FLAGS) P6 test5.in test5.out spim5.s
	#java $(FLAGS) P6 test6.in test6.out spim6.s


###
# clean
###
clean:
	rm -f *~ *.class parser.java cimple.jlex.java sym.java typeErrors.out test.out *.s *.out
