f = flags(cost,chances).
w = wme(path,flags).
t = thrash(type,order,nitems,canSkip,lives,nToDo,items).

oops --> t(lives,Old,New), New is Old - 1.
pop(One) -->
	t(order,l2r),
	t(items,[One|Items],Items),
	t(nitems,N0,N),
	{N is N0 - 1}.
pop(One) -->
	t(order,random),
	t(items,Items0,Items),
	t(nitems,N0,N),
	{N is N0 - 1,
	Pos is random(N0) + 1,
	oneLessN(Pos,Items0,One,Items)}.

%value(_Key) := [_].

a :- g or l or k,m,n and c and d and e.
