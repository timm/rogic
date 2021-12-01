%% simple test of maths

:- [law/earth].

*1 if a>5 and b > 9 and k < 12 then a > 15.
*2 if a<11 and b< 100 and k < 20 then a is 15.
*3 if k<11 or k> 100 then k=10. 

go:-watch(go1).

go1:-  listing(*),
	listing(used),
	generateNumberLines,
	listing(numberLine),
	akas(All),
	forall(member(One,All),(print(One),nl)).