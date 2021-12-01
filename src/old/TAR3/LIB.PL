foreach(X,L,Y) :- forall(member(X,L),Y).

l(L) :- foreach(X,L,(print(X),nl)).

sum([H|T],S) :- sum(T,H,S).

sum([],S,S).
sum([H|T],S0,S) :- S1 is S0+H, sum(T,S1,S).

unique(L0,L) :- unique(L0,[],L).

unique([],_,[]).
unique([H|T], L0, L) :- member(H,L0),!,unique(T,L0,L).
unique([H|T], L0, [H|L]) :- unique(T,[H|L0],L).

dist(L0,L) :- dist(L0,_,_,L).

dist(L0,Min,Max,L) :-
	msort(L0,[Min|L1]),
	dist([Min|L1],[],Min,Max,L).

dist([],X,Max,Max,X).
dist([H|T],[H-N0|Rest],_,Max,Out) :- !,
	N is N0 + 1,
	dist(T,[H-N|Rest],H,Max,Out).
dist([H|T],In,Min,Max,Out) :-
	dist(T,[H-1|In],Min,Max,Out).

spit(N1,N2,X) :-
	(0 is N1 mod N2 -> spit(X) ; true).

spit(X) :- `verbose,!,write(user,X),flush_output(user).
spit(_).

chars(F) :- see(F), get_byte(X), ignore(chars1(X)), seen.
    
chars1(-1) :- !.
chars1(X)  :- put(X), get_byte(Y), chars1(Y).

c2l((X,Y),[X|Z]) :- !,c2l(Y,Z).
c2l(X,[X]).



`[]=[]    :- !.
`[H0|T0] = [H|T] :- !, `H0=H, `T0=T.
`X=Y      :-  option(X,Z),!, Y=Z.
`X=_      :-  !, format('%W> ~p\n',missingOption(X)),fail.
`X        :- atomic(X), `X=1.

assignOption(X=Y) :- retractall(option(X,_)), assert(option(X,Y)).

+X :- load_files(X,[silent(true)]).

commandLine :-
        current_prolog_flag(argv, Argv),
        append(_, [--|Args], Argv), !,
	concat_atom(Args, ' ', SingleArg),
	term_to_atom(Term, SingleArg),
	c2l(Term,List),
	checklist(assignOption,List).
commandLine.

