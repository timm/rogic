threseholds(Rel,Avoid) :-
	columns(Cols),
	between(1,Cols,Col),
	bagof(T, Rel^Avoid^Col^thresehold(Rel,Avoid,Col,T),
	         Ts).
	

thresehold(Rel,Avoid,Col,T) :-
	`steps= Steps0,
	cols(Rel,Avoid,Col,All),
	msort(All,Sort),
	length(Sort,L),
	Steps is min(Steps0,L),
	N is floor(L/Steps),
	bins(N,Sort,Bins),
	member(T,Bins).

bins(N,All,B) :-
	bins1(N,All,B0),
	unique(B0,B).

bins1(N,All,[H|Ls]) :-
	length([H|T],N),
	append([H|T],Rest,All),!,
	bins1(N,Rest,Ls).
bins1(_,[H|_],[H]).
bins1(_,[],[]).

cols(Rel,Avoid,Pos,Ns) :-
	goodColumn(Rel,Name,Pos),
	bagof(N,Name^Rel^Avoid^
                   col(Rel,Avoid,Pos,N),
	      Ns).

col(Rel,Avoid,Pos,N) :-	
	one(Rel,One),
	f(id=Id,One),
	bucket(Rel,Id,Bucket),
	not(Bucket=Avoid),
	arg(Pos,One,N).

