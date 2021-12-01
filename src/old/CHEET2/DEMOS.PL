emp=object+employee(age,name,shoeSize).

demo(0) :-
	listing(emp),
	listing(goal_expansion).

demo(1) :-
	makeAccessors(
	    emp=object+employee(age,height),
	    X),
	clauses(X).



demo(2) :-
	w(init,_,W0),
	demo2(W0,W),
	print(W),nl,
	write(W),nl.

demo2 -->
	wmePut(as(1)),
	wmePut(as(4)).


  
