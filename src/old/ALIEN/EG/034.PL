:- write('%hope you ran "moonc qc1" first'),nl.
:- [law/earth, eg/th/jjnums/vulcan, eg/th/jjnuums/vulcan1].

go  :- watch(go1).

go1 :- 	problems(All), print(All),nl,
	roots(R), print(R),nl.
	
	

problems(All) :- bagof(One,oops(One),All).
oops(oops(X)=t) :- v(_,oops(X),=,t,_,_).

roots(All) :- setof(One,root(One),All).
root(Attr=V) :-  v(X,Attr,=,V,_,_), e(_,X,_,_),\+ e(_,_,X,_).

%XXX all wrong!!