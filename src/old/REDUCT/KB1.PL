:- [dd].

% Martin: source of source moved to last thing
% Martin:  date "wrapped" in a "when" term
+source(v1,when(2000,2,2,17,26,22),u0).

+aka(u0,"Baseline",v1).
+aka(r5,"R",v1).
+aka(r6,"R1",v1).
+aka(r7,"R2",v1).
+aka(f8,"F1",v1).
+aka(f9,"F2",v1).
+aka(p22,"PA",v1).
+aka(p23,"PB",v1).

+r(r5,Str5,Like5,Cost5,v1) :- 
	Str0=3,
	r(r6,Str6,Like6,Cost6,_),
	r(r7,Str7,Like7,Cost7,_),
	Str5 is Str0*Str6*Str7.
	

% Martin:  +r6(1,_,_,v1) became +r(r6,1,_,_,v1).
+r(r6,X,L,_,v1) :- Str0=1,impacts(+,r6,Im), X is Str0*L*min(Im,1).
+r(r7,X,L,_,v1) :- Str0=2,impacts(+,r7,Im), X is Str0*L*min(Im,1).

% Martin:  +f8(_,1,_,v1). became +f(f8,_,1,_,v1).
% oh, and this is tacky, but in my prolog integer 1 does
% not equal 1.0. so all the strengths=1 have to be strengths=1.9
+f(f8,1,0.9,_,v1).
%+f(f9,_,1.0,_,v1).

% Martin:  +p22(_,_,1,v1) became +p(p22,_,_,1,v1).
+p(p22,_,_,1,v1).
+p(p23,_,_,1,v1).

+impact(r6,0.1,v1) :- f(f8,_,_,_,_).
+impact(r6,0.2,v1) :- f(f9,_,_,_,_).
+impact(r7,0.3,v1) :- f(f8,_,_,_,_).
+impact(r7,0.4,v1) :- f(f9,_,_,_,_).

+impact(f8,0.6,v1) :- p(p22,_,_,_,_).
+impact(f9,0.7,v1) :- p(p22,_,_,_,_).
+impact(f9,0.5,v1) :- p(p23,_,_,_,_).
+impact(f8,0.4,v1) :- p(p23,_,_,_,_).

