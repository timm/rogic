:- write('%hope you ran "moonc jjnums" first'),nl.
:- [lib/io,law/moon].

%:- spock(jjnums).

%go  :- watch(go1).

go :- 	[eg/th/jjnums/theory],
	generateDefs,
	generateNumberLines,
	forall(akas(A),ensure(A)),
	listing(*).

problems(All) :- bagof(One,oops(One),All).
oops(oops(X)=t) :- v(_,oops(X),=,t,_,_).

roots(All) :- setof(One,root(One),All).
root(Attr=V) :-  v(X,Attr,=,V,_,_), e(_,X,_,_),\+ e(_,_,X,_).

%XXX all wrong!!