@day(Day,Mn,_) :- 
	rin(Mn,[4,6,9,11]) 
        rand rnum(0,30,Day).
@day(Day,Mn,_) :- 
	rin(Mn,[1,3,5,7,8,10,12]) 
        rand rnum(0,31,Day).
% leap years need more work. one day.
@day(Day,2=month,Yr) :- 
	@year(Yr), 
	0 is Yr mod 4, 
	rnum(0,29,Day).
@day(Day,2,Yr) :- 
	@year(Yr), 
	N is Yr mod 4, 
	N > 0, 
	rnum(0,28,Day).
@hour(A) :- 
	rnum(0,23,A).
@minute(A) :- 
	rnum(0,59,A).
@second(X) :- 
	rnum(0,59,X).
@when(A=year,B=month,C=day,D=hour,E=minute,F=second) :- 
	@year(A),  % note that we are setting year first, before the rest.
                   % so sometimes we assume an ordering. so no thanks for auto-gen
	           % the body
        (@day(C,B,A) 
        rand @hour(D) 
        rand @minute(E)
	rand @second(F)
	).
@year(X) :- 
	X= 2000 
        ror X=2000
        ror rnum(1974,1999,X) 
        ror rnum(2001,2050,X).