% need numeric compatiabiliy
% need BIG paths

:- dynamic range/2.

ensure(X) :- X,!.
ensure(X) :- assert(X).

g:-
	format('digraph G {rankdir=LR;~n',[]),
	format('subgraph cluster0 {~n',[]),
	format(' label="";~n 1 [label="start",shape=plaintext];~n}',[]),
	forall(classes,true),
	format(' subgraph cluster1 {~n',[]),
	format(' label=""; color=white;~n',[]),
	forall(nodes,true),
	forall(edges,true),
	format('}~n',[]),
	format('}~n',[]).
	
classes :-
	range(classt,Class),
	format('~a [style=filled,color=black,label="~w"];~n',[Class,Class]).

nodes :- 
	node(_,Me,_,AV,_),
	format('~a [shape=plaintext,label="~w"];~n',[Me,AV]).
	
edges :-  
	edges(1).

edges(Parent) :-
	node(_,Me,Parent,_,Class),
	Me \= Parent,
	format('~a -> ~a;~n',[Parent,Me]),
	(Class=t
	->	edges(Me)
	;       format('~a -> ~a;~n',[Me,Class])).

go :-
	time(go1).

go1   :- 


	write('generating graph...'),nl,

	dotFile(Dot),
	tell(Dot), g, told.
