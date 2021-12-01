yesno :-
	yesno('Yes?').

yesno(Prompt) :-
	write(Prompt), write(' [yn]:'),
	get_single_char(Char),
	name(String,[Char]),
	(String = y | String = 'Y').

pause :- pause('').
pause(String) :-
	write(String),nl,
	write('Press any key to continue...'),
	get_single_char(_).


oops(X)      :- current_output(S), oops(S,X).
oops(S,X)    :- barph(S,X,'Error: ').

strange(X)   :- current_output(S), strange(S,X).
strange(S,X) :- barph(S,X,'Warning: ').

barph(S,X,Prelude) :-
	listp(X), !, my_nl(NL),
	printl(X,S,fail,0,Prelude,' ',NL).
barph(S,X,Prelude) :- barph(S,[X],Prelude).

% ----------------------------------------------------------
	
my_nl('
').

clear :- line(L),write(L),nl,fail.
clear.

addln(S0,S) :- 
	name(S0,L),
	my_nl(NewLine), 
	name(NewLine,After),
	append(L,After,Temp),
	name(S,Temp).

% ----------------------------------------------------------
% convenient ways to print a list

print_clauses(L) :-
	current_output(S),
	print_clauses(S,L).

print_clauses(Stream,L) :-
	my_nl(NL),
	printl(L,Stream,fail,1,NL,'. ','. ').

print_words(L) :-
	current_output(S),
	print_words(S,L).
print_words(Stream,L) :-
	my_nl(NL),
	printl(L,Stream,fail,1,'',' ',NL).

nprintl(L) :- 
	current_output(S),
	nprintl(S,L).

nprintl(Stream,L) :- 
	my_nl(NL),
	printl(L,Stream,true,1,NL,NL,NL).

printl(L) :- 
	current_output(S),
	printl(S,L).
printl(Stream, L) :- 
	my_nl(NL),
	printl(L,Stream,fail,1,NL,NL,NL).

pnprintl(L,Prompt) :-
	current_output(S),
	pnprintl(S,L,Prompt).
pnprintl(Stream,L,Prompt0) :-
	my_nl(NL),
	addln(Prompt0,Prompt),
	printl(L,Stream,true,1,Prompt,NL,NL).

%-----------------------------------------------
% low-level list printer
printl([],_,_,_,_,_,_).
printl(L,Stream,PrintN,N,Before,Between,After) :-
	write(Stream,Before),
	printl1(L,PrintN,N,Stream,Between),
	write(Stream,After).

printl1([X],PrintN,N,Stream,_) :-  
	printl2(X,PrintN,N,Stream).
printl1([X,Y|T],PrintN,N0,Stream,Between) :- 
	printl2(X,PrintN,N0,Stream),
	write(Stream,Between),
	N is N0 + 1,
	printl1([Y|T],PrintN, N, Stream,Between).

printl2(Item,PrintN,N,Stream) :-
	once(printl_number(PrintN,N,Stream)),
	once(printl_item(Item,Stream)).

printl_number(PrintN,_,_) :- \+ PrintN.
printl_number(_,N,Stream) :- N < 10,
	write(Stream,'   '), write(Stream,N), write(Stream,'. ').
printl_number(_,N,Stream) :- N < 100,
	write(Stream,'  '), write(Stream,N), write(Stream,'. ').
printl_number(_,N,Stream) :- N < 1000, 
	write(Stream,' '), write(Stream,N), write(Stream,'. ').
printl_number(_,N,Stream) :- 
	write(Stream,''), write(Stream,N), write(Stream,'. '). 

printl_item(Var,Stream) :-
	var(Var),!,
	print(Stream,Var).

printl_item({b-Item},Stream) :-
	write(Stream,'['),
	printl_item(Item,Stream),
	write(Stream,']').
printl_item({n-N},Stream) :-  
	new_lines(N,Stream).
printl_item({t-N},Stream) :- 
	tab(Stream,N).
printl_item({n},Stream) :-  
	new_lines(1,Stream).
printl_item({t},Stream) :- 
	tab(Stream,1).
printl_item(X,Stream) :-
	print(Stream,X).

new_lines(N) :- 
	current_output(S),
	new_lines(N,S).
new_lines(0,_).  
new_lines(N0,Stream) :- 
	N0 > 0, 
	nl(Stream),
	N is N0 - 1, 
	new_lines(N,Stream).

%----------------------------------------------------------------
:- dynamic tPrint/0.

tPrintOn :- ensure(tPrint).
tPrintOff :- retractall(tPrint).

t(X) :- tPrint, !,print(t(X)),nl.
t(_).
t1 :- t(1).
t2 :- t(2).
t3 :- t(3).
t4 :- t(4).
t5 :- t(5).
t6 :- t(6).
t7 :- t(7).
t8 :- t(8).
t9 :- t(9).
t10 :- t(10).

t11 :- t(11).
t12 :- t(12).
t13 :- t(13).
t14 :- t(14).
t15 :- t(15).

t21 :- t(21).
t22 :- t(22).
t23 :- t(23).
t24 :- t(24).
t25 :- t(25).
t26 :- t(26).
t27 :- t(27).
t28 :- t(28).
t29 :- t(29).
t30 :- t(30).

t31 :- t(31).
t32 :- t(32).
t33 :- t(33).
t34 :- t(34).
t35 :- t(35).
t36 :- t(36).
t37 :- t(37).
t38 :- t(38).
t39 :- t(39).
t40 :- t(40).
