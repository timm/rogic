%% basic test of the vulcan compiler
:- +[law/vulcan, eg/in16].

go1 :- output(X), listing(X), fail.
go1.


go :- watch(go1).


go2 :- 
	A=age,
	B=(t(1)>3),
	C=someone,
	D=aid,
	E=cost,
	F=(ff@t(f)>f,gg@t(g)>g,hh@t(h)>h),
	G=_,
	create(vdat,G),
	vdat0(add( (A@B:-{from(C), id(D), cost(E)}, F)), G, H),
	vdat0(first(First),H,I),
	print(first(First)),nl,
	print(I),nl,
        SG = subGoal(_,_,_,_),
	vdat0(SG,I),
	print(subgoal(SG)),nl,
	fail.

go2:- 
	A=age,
	B=(t(1)>3),
	C=someone,
	D=aid,
	E=cost,
	F=(ff@t(f)>f,gg@t(g)>g,hh@t(h)>h),
	G=_,
	create(vdat,G),
	vulcanises((A@B:-{from(C), id(D), cost(E)}, F), Out),
	member(One,Out),
	print(One),nl,
	fail.
go2.
