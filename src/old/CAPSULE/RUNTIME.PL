portray(X) :- 
	clause(show(X),_),
        show(X).

iss(F is V, In) :-  
	touch(In,F,_,V,_).
iss(F is V,In,Out) :-
	touch(In,F,_,V,Out).
iss([],Out,Out).
iss([F is V|Rest],In,Out) :-
	touch(In,F,_,V,Temp),
	iss(Rest,Temp,Out).


