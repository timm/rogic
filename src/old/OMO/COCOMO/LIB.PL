%%% Meta %<
demand(X) :- X.
demand(X) :- \+ X, barph(failed(X)).

mybagof(X,Y,Z) :- bagof(X,Y,Z),!.
mybagof(_,_,[]).
%>
%%% Transforms %<
c2l((X,Y),[X|Z]) :- !,c2l(Y,Z).
c2l(X,[X]).

d2l((X;Y),[X|Z]) :- !,d2l(Y,Z).
d2l(X,[X]).
%>
%%% I/O %<
chars(F) :- see(F), get_byte(X), ignore(chars1(X)), seen.
    
chars1(-1) :- !.
chars1(X)  :- put(X), get_byte(Y), chars1(Y).

sneak(X) :- load_files(X,[silent(true),if(changed)]).

spit(N1,N2,X) :- (0 is N1 mod N2 -> spit(X) ; true).
spit(X) :- ?verbose,!,write(user,X),flush_output(user).
spit(_).

barph(X) :- format('%W> ~p\n',X),fail.
%>
%%% Maths %<
sum([H|T],X) :- sum(T,H,X).
sum([],X,X).
sum([H|T],Temp,X) :- Y is H + Temp, sum(T,Y,X).

average(N,G,Sum/L) :-
	bagof(N,G,All), sum(All,Sum), length(All,L).
%>
%%% Pretty print a list of terms.  %<
portrays(L) :- portrays(L,_,_).

portrays([],_,_).
portrays([H|T],F0,A0) :-
	functor(H,F,A),
	(F0=F,A0=A
        -> portray_clause(H),
           portrays(T,F0,A0)
         ; nl,portray_clause(H),
           portrays(T,F,A)).
%>
%%% Random types
%% Random strings %<
rsym(X)  :- nonvar(X),!.
rsym(X)  :- gensym(g,X).

rsym(_,X)  :- nonvar(X),!.
rsym(A,X)  :- gensym(A,X).
%>
%% Random number within a range %<
rin(M,N,_,X) :- nonvar(X),!, number(X),M =< X, X =< N.
rin(M,N,O,X) :- Steps is integer((N-M)/O),
	        between(1,Steps,_),
		Y is random(Steps+1),
		X is min(M + Y*O,N).
%>
%% Random value of a list %<
rin(M,N,X) :- nonvar(X),!, number(X),M =< X, X =< N.
rin(M,N,X) :- Steps is integer(N-M),
	      between(1,Steps,_),
	      Y is random(Steps+1),
	      X is min(M + Y,N).

rin(X,L) :- number(X),!, member(Y,L), X =:= Y.
rin(X,L) :- nonvar(X),!, member(X,L).
rin(X,L) :- length(L,N), rmember1(L,N,X).

rmember1([H],_,H)   :- !.
rmember1([H|T],N,X) :- Pos is random(N) + 1,
                       less1(Pos,[H|T],Y,L),
                       (X=Y
                       ; N1 is N - 1,
                         rmember1(L,N1,X)).

less1(1,[H|T],H,T) :- !.
less1(N0,[H|T0],X,[H|T]) :- N is N0 - 1, less1(N,T0,X,T).
%>
%%% Fast, named, assertions
/* Define  some named fields. */ %<
multis(Stuff,All) :-
	bagof(One,Stuff^multi(Stuff,One),All).

multi((Heads :- Tail),(Head :- Tail)) :-
	d2l(Heads,List),
	member(Head,List).
%>
/* Poke some values into the named fields. */ %<
fields(Fields,Functor,Term) :- fields1(Fields,Functor,Term),!.
fields(_,_,[]).

fields1([],_,_).
fields1([Field|Fields],Functor,Term) :-
	fields2(Field,Functor,Term),
	fields1(Fields,Functor,Term).

fields2(Field,Functor,Term) :-
	clause(Field,(Term,_)),
	functor(Term,Functor,_),!.
fields2(Field,Functor,_) :-
	barph(badField(Functor is [Field])).
%>
%%% Lookup Tables 
/* Generate them */ %<
lookUpTable(X,Out) :-
	bagof(Y,X^list2Relation1(X,Y),Out).

list2Relation1(Table=Cols+Rows, lookUp1(Table,R,C,X)):-
	nth1(Pos,Cols,C),
	member([R|Cells],Rows),
	nth1(Pos,Cells,X),
	nonvar(X).
%>
/* Use them: */ %<
lookUp(T,X,Y,Out) :-
	lookUp1(T,R,C,Out), gt(X,R), gt(Y,C), !.

gt(Value,X to Y) :- !,X =< Value, Value =< Y.
gt(Value,Value).
%>
%%% Configuration Control %<
set(X=Y) :-
	retractall(option(X,_)),
	assert(option(X,Y)).

[] := []    :- !.
[H0|T0] := [H|T] :- !, H0 := H, T0 := T.
X := Y      :-  option(X,Z),!, Y=Z.
X := _      :- !, barph(missingOption(X)).
?X          :- atomic(X), X := 1.

commandLine :-
	current_prolog_flag(argv, Argv),
	append(_, [--|Args], Argv), !,
	concat_atom(Args, ' ', SingleArg),
	term_to_atom(Term, SingleArg),
	c2l(Term,List),
	forall(member(One,List), set(One)).
commandLine.
%>
%%% Demo support code
/*
Catches the output from some predicate X
and saves it a file X.spy. The command:

{\scriptsize
\begin{verbatim}
\SRC{X.spy}{Caption}
\end{verbatim}}
\noindent
includes the generated file into the {\LaTeX} document.

The code `demos/1` deletes any old output and runs some goal twice: once
to trap it to a file and once to show the results on the screen. */ %<
demos(G) :-
	sformat(Out,'~w.spy',G),
	(exists_file(Out) -> delete_file(Out) ; true),
	tell(Out),
	format('% output from '':- demos(~w).''\n\n',G),
        T1 is cputime,
	ignore(forall(G,true)),
	T2 is (cputime - T1),
	format('\n% runtime = ~w sec(s)\n',[T2]),
        told,
	format('% output from '':- demos(~w).''\n',G),  
        ignore(forall(G,true)),
	format('\n% runtime = ~w sec(s)',[T2]).
%>
%%% License %<
hello :-  % \MARK{hello}
	[program,version,copyright,motto,copywho]:=[N,V,Y,M,C],
	format('~s version ~s\n Copyright (C) ~s by ~s\n',
	       [N,V,Y,C]),
	format(' "~s"\n\n~s ~s ',[M,N,V]),
	chars('nowarranty.txt'). % see \tion{nowar}
   
warranty :-
	[program,copyright,copywho]:=[P, Y,C],
	format('~s by ~s\n Copyright (C) ~s\n\n',[P,C,Y]),
	chars('warranty.txt'),nl. % see \tion{war}

conditions :-
	chars('conditions.txt'),nl. % see \tion{cond}
%>