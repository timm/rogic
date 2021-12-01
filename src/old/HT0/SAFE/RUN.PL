

run :-
	unix(argv(Args)),
	append(_,[-r,N|_],Args),
	tname(N,T),
	load_files([T],[silent(true)]).

tname(X,Y) :- X < 10,!,asString('t00~p',[X],Y).
tname(X,Y) :- X < 100,!,asString('t0~p',[X],Y).
tname(X,Y) :- X < 1000,!,asString('t~p',[X],Y).


asString(Spec,Args,String) :-
	sformat(String0,Spec,Args),
	string_to_atom(String0,String).