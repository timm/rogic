
%dat(K,C,S).
dat(eg1,0.4,0.2,2).
dat(eg2,0.4,0.2,6).
dat(eg3,0.3,0.2,6).
dat(eg4,0.3,0.25,6).
dat(actual,0.5698,0.2111,4.4336).

n(N) :- between(10 ,35  ,X), N is X/100.
e(N,K,C,S,E) :- E is ceiling(K/((N^2)*((1-abs(C-N))^S))).
 
doall :- 	
	dat(What,K,C,S),
	string_concat('dat/',What,File0),
	string_to_atom(File0,File),
	print(File), nl,
	tell(File),
	do1(K,C,S),
	told,
	fail.
doall.

do1(K,C,S) :-
	n(N), 
	e(N,K,C,S,E), 
	write(N), 
	write(' '), 
	write(E), 
	nl,
	fail.
do1(_,_,_).

