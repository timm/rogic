%polymorphism operators
goal_expansion(<>(X,Y,Z),join(Y,X,Z)).
goal_expansion(<>(X,Y),  <>(X,Y,_)).
goal_expansion(<>(X),    <>(X,_,_)).

:- [accessor,base].

%%%%%%%%%%%%

swap(L,Out) :-
        bone(Head),
	headBody(Head,Clause),
        runiv(Clause,L,Out).

headBody(Head,(Head :- Body)) :-
	clause(Head,Body),
	(Body=true
         -> Out = Head
         ;  Out= (Head :- Body)).

headBody((:- X),(:- X)).

runiv(Term0, Swaps,Term) :-
        Term0 =..L0,
        once(maplist(runiv1(Swaps), L0, L)),
	Term =.. L.

runiv1(_,H,H)  :- var(H).
runiv1(Swaps,Old,New)  :-
	atomic(Old),
	member(Old/New,Swaps),!.
runiv1(_,H,H) :- atomic(H).
runiv1(Swaps,H0,H) :- runiv(H0,Swaps,H).

%%%%%%%%%%%%

oops(X) :- format('%E> ~w\n',[X]),fail.

items(X) :- forall(member(Y,X),
	            (print(Y),nl)).

clauses(X) :- forall(member(Y,X),
	            (portray_clause(Y))).

less1([],_,[]).
less1([One|Less],One,Less).
less1([H|Tail],One,[H|Rest]) :-
	less1(Tail,One,Rest).

myAppend(X0,Y0,Z) :-
	asList(X0,X),
	asList(Y0,Y),
	append(X,Y,Z).

asList(H, [H]) :- \+ is_list(H),!.
asList(H, H).

%%%%%%%%%%%%%%

t2l(T,[F|L])     :- functor(T,F,_), t2l(T,F,L,[]).
t2l(X,_,[X|L],L) :- functor(X,F,_), \+ connector(F),!.
t2l(T,F,In,Out)  :- functor(T,F,1),!,
	arg(1,T,X),t2l(X,F,In,Out).
t2l(T,F,In,Out) :- 
	functor(T,F,2),!,
	arg(1,T,X), t2l(X,F,In,Temp),
	arg(2,T,Y), t2l(Y,F,Temp,Out).
t2l(T,_,[L|Out],Out) :- t2l(T,L).

connector(X) :-
	current_op(_,What,X),
	member(What,[xfy,yfx]).

%%%%%%%%%%%%%%%%%%

oneLessN(1,[H|T],H,T) :- !.
oneLessN(N0,[H|T],X,[H|Rest]) :-
	N is N0 - 1,
	oneLessN(N,T,X,Rest).	

rone(L,X) :- rone(L,X,_).

rone([H],H,[]) :- !.
rone([H|T],X,Out) :-
	length([H|T],N),
	Pos is random(N) + 1,
	oneLessN(Pos,[H|T],One,Rest),
	(X=One, Out=Rest
	; Out=[One|Tail],
	  rone(Rest,X,Tail)).
