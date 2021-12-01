emp=[name 
    ,demerits=22
    ,rank
    ,kids=[2,3,6]
    ,work=[eat,sleep,drink]
    ].
 
emp*birthdays(X) = Y-->
	Y is X + 1.

emp+demo(R,W,Older) -->
	o kids was Younger now Older
	o birthdays(Younger,Older)
	o sort(work)
	o work << relax so W
	o rank is 5
	o name := tim
	o +rank
	o rank ^ 3 
	o rank  * 10 so R
	o show.
	   
demoDefs(out(R1,W,X,B)) :-
	 o([new(emp),demo(R1,W,B)],X).
	 
	   
	 
birthday(X,Y) :- Y is 1 + X.