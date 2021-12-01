dot(F1,F2) :-
	tell(F1),
	dot1,
	told,
	tell(F2),
	dot2,
	told.
	
dot1 :-
	write('digraph G {'),nl,
	write('   randsep=0.3; rankdir=LR;'),nl,
	forall(edge1(A,B),(nl,forall(node([A,B]),nl))),
	write('}'),nl.

node(L) :-
	member(X,L),
	aka(X,Text,_),
	member(X/Shape,[p(_)/ellipse,f(_)/box,r(_)/triangle]),
	format('"~w" [label="~w",shape="~w"];',[X,Text,Shape]).

edge1(f(A),C) :- f(A,_,_,_,_,B), member(C,B), format('"~w" -> "f(~w)";',[C,A]).
edge1(p(A),C) :- p(A,_,_,_,_,B), member(C,B), format('"~w" -> "p(~w)";',[C,A]).
edge2(A,B) :- impact(A,B,C,_), format('"~w" -> "~w" [label="~w"];',[A,B,C]).
edge2(A,B) :- effect(B,A,C,_), format('"~w" -> "~w" [label="~w"];',[A,B,C]).
edge2s :-
		forall(edge2(A,B),(nl,forall(node([A,B]),nl))).

dot2 :-
	write('digraph G {'),nl,
	write('   randsep=0.3; rankdir=LR;'),nl,
	edges2,
	write('}'),nl.

key :-
	write('subgraph cluster1 {'),nl,
	write('label="key";'),nl,
    write('"requirements" [shape="triangle"];'),nl,	
    write('"faults" [shape="box"];'),nl,	
    write('"pacts" [shape="ellipse"];}'),nl.	

dotall(F) :-
	tell(F),
	dotall,
	told.

dotall :-
    write('digraph G {'),nl,
    write('   randsep=0.3; rankdir=LR;'),nl,
	key,
    write('subgraph cluster2 {'),nl,	
    forall(edge1(A,B),(nl,forall(node([A,B]),nl))),
	edge2s,
    write('}}'),nl.

