%%%%%%%%%%%%%
+ X :- load_files(X,[silent(true),if(changed)]).

%%%%%%%%%%%%%
ops(X) :- ops(X,999).

ops([]            ,_ ).
ops([A/O    |Rest],N0) :- atom(O),ops1([O],  A,N0,N), ops(Rest,N).
ops([A/[H|T]|Rest],N0) :-         ops1([H|T],A,N0,N), ops(Rest,N).

ops1([],_,N,N).
ops1([H|T],A,_, N) :-
	current_op(N0,A,H), !,
	%format(':- ~w.\n',[op(N0,A,H)]),
	N1 is N0 - 1,
	ops1(T,A,N1,N).
ops1([H|T],A,N0,N) :-
	%format(':- ~w.\n',[op(N0,A,H)]),
	op(N0,A,H), N1 is N0 - 1,
	ops1(T,A,N1,N).

%%%%%%%%%%%%%
huh(X,Y)   :- format('W> ~w : ~w\n',[X,Y]).
barph(X,Y) :- huh(X,Y), fail.

%%%%%%%%%%%%%
commandLine(Options) :-
	unix(argv(Argv)),
	append(_,[--|Options0],Argv),
	commandLine1(Options0,Options).

commandLine1(X,Y) :- commandLine2(X,Y),!.

commandLine2([],[]).
commandLine2([X0,Y|T],[X=Y|T1]) :-
	name(X0,[45|Rest]), !,
	name(X,Rest),
	commandLine1(T,T1).   
commandLine2([X0|T],[X|T1]) :-
	name(X0,[43|Rest]), !,
	name(X,Rest),
	commandLine1(T,T1).	   
commandLine2([X0,_|T],T1) :-
	huh('bad command',X0),
	commandLine1(T,T1).

%%%%%%%%%%%%%
reads(F,L) :- see(F), read(X), reads1(X,L), seen,!.

reads1(end_of_file,[]) :- !.
reads1(X,       [X|T]) :- read(Y), reads1(Y,T).

%%%%%%%%%%%%%
c2l((H,Y),[H|T]) :- !, c2l(Y,T).
c2l(X,[X]).