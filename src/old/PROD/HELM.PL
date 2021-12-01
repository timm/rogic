%%%% Optimization

helm(B,Repeats,Epsilon,
	
helm(B,N,Ep,Beam,Rx) :-
	b_(init(B),_,Low0),
	b_(init(B),_,High0),
	b_(init(Beam),_,Cand0),
	tell(xx),
	helms(N,Low0,Low,High0,High),told,
	counts(Low,-,LC),
	counts(High,+,HC),
	append(LC,HC,All),
	dist(All,HCD),
	backbones(HCD,0,Sum,Cand0,Cand1),
	b_(contents=Cand2,Cand1,Cand1),
	maplist(arg(2),Cand2,Cand).
	
helms(0,L, L,H, H).
helms(N,L0,L,H0,H) :-
	N>0,
	spit(N,10,-N),
	N1 is N - 1,
	once(lurchOver(estimate(A,_,_),[s(ruse)=n, s(rely)=vl,
	                                 s(site)=xh, s(cplx)=vl, s(acap)=vh],How)),
	print(A),nl,
	NegA is -1*A,
	badd(A=How,H0,H1),
	badd(NegA=How,L0,L1),
	helms(N1,L1,L,H1,H).

counts(B,Sym,Ws) :- b_(contents=C,B,B),bagof(AB,C^Sym^counts1(C,Sym,AB),Ws).

counts1(W,Sym,x(A,B,Sym)) :-
	member(_=w(_,L),W),
	member(A=B,   L).
	
backbones([],R,R,B,B).
backbones([x(A,B,-)=F1,x(A,B,+)=F2|T1],R0,R) --> !,
	{R  is F1/F2,
	 R1 is R0 + R},
	badd(R=(A=B)),
	backbones(T1,R1,R).
backbones([_|T]) -->  backbones(T).
	
x(L,Key=Values) :-
	member(Key=_,L),
	whatevered(Blank,Key,_,Value),
	bagof(Value,Blank^Blank,Values).
