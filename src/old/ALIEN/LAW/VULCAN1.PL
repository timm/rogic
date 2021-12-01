:- +[types/e,types/v,lib/meta, lib/io].

optimise(In) :-
	+[In],
	reads(In,All),
	forall((member(X,All)
               ; optimise1(X)
               )
              ,format('~p.~n',[X])).

optimise1(X) :- makeFroms(X) ; makeTos(X).

verticies(All) :- 
	bagof(Vid,V^a(v,Vid,V),All).

makeTos(tos(Here,Theres)) :-
	verticies(All),
	member(Here,All),
	my_bagof(There,Here^join(e,There,from(Here)),Theres).

makeFroms(froms(Here,Theres)) :-
	verticies(All),
	member(Here,All),
	my_bagof(There,Here^join(e,There,to(Here)),Theres).


