 % lib.pl
 
 - X :- load_files(X,[silent(true), if(changed)]).
 
 asList(X,X) :- is_list(X),!.
 asList(X,[X]).
 
 :- format_predicate('P',pp(_,_)).
 
 
 pp(default,X) :- !, pp(0,X).
 pp(_,(X :- true)) :- !, format('~p.\n',X).
 pp(_,(X :- Y   )) :- !, portray_clause((X :- Y)).
 pp(N,[H|T]      )  :- !, not(not((numbervars([H|T],N,_),
 	                     format('~p',[[H|T]])))).
 pp(N,X          ) :- not(not((numbervars(X,N,_),
 	                     format('~p',X)))).
 
 
 :- format_predicate('>',padChars(_,_)).
 
 padChars(default,A) :-
 	padChars(5,A).
 padChars(S,A) :-
 	writeThing(A,Thing,N),
 	Pad is S - N,
 	% standard trick to emulate
 	% for(i=1;i<=N;i++) { doThis }
 	forall(between(1,Pad,_),put(32)),
 	write(Thing).
 
 
 writeThing(X,S,L) :-
 	% sformat returns the string in
 	% the first arg
 	sformat(S,'~w',[X]), string_length(S,L).
