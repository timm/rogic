% config: increased size should speed
% access time

:- [oidset].

wmeSize(50).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% you  should not need to look
% below here

%support code
portray(X) :-  wme0(X), functor(X,What,Size), print(What/Size).

term_expansion(makeWme,Out) :- 
	makeWme(Out).

makeWme(wme0(New)) :-
        wmeSize(Size),
	length(L0,Size),
	maplist(empty,L0,L),
	New =.. [wme|L].

empty([],[]).

swapPrim(swap(N,V0,V,W0,W)) :-
	wmeSize(Size),
	functor(W0,wme,Size),
	functor(W,wme,Size),
	W0 =.. [wme|L0],
	W  =.. [wme|L],
	between(1,Size,N),
	joinArgs(1,N,L0,V0,V,L).

joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :- 
	N0 < N1,
	N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).
	
push(T,W0,W) :- 
	arg(2,T,Hash),
	
	wmePrim(K,W,I,Old),
	lpush(K,V,Old,New),
	setarg(I,W,New).

pop(K=V,W,W) :-
	wmePrim(K,W,I,Old),
	lpop(K,V,Old,New),
	setarg(I,W,New).

peek(K=V,W,W) :-
	wmePrim(K,W,_,Old),
	lget(K,V,Old).
	
peeks(K=Vs,W,W) :-
	wmePrim(K,W,_,Old),
	lgets(K,Vs,Old).

wmePrim(Term,W,I) :-
	wmeSize(S),
	arg(1,Term,Id),
	hash_term(Id,H),
	I is (H mod S) +1.

%%%%%%%%%%%%%%%%%%%	
% this next line MUST follow the above
makeWme.

%%%%%%%%%%%%%%%%%%%

demoD1 :-
	wme0(W),
	maplist(demoD1(W),[aa,ba,csdas,dasds,er,fsf,gsdfs,hqwe,iqweq,jqeqw,kwer,luy,mqw,newqe,oqweqw,pqweq,qtretr,
				rht,sqwe,tku,uqweqw,vuyuy,werre,xcxv,yht,zkuku],_),
	print(W),nl.

demoD1(W,Z,Z) :-
	push(Z=1,W,_),
	push(Z=2,W,_),
	peeks(Z=As,W,W),
	print(w(As)),nl.

demoD2 :-
	wme0(W),
	push(a=0.5,W,_),
	demoD2a(a=W),
	alt(a,*,60,W,W),
	demoD2a(a=W),
	alt(a,^,2,W,W), 
	demoD2a(a=W).

demoD2a(A,W) :-
	peek(A=X,W,W),
	print(A=X),nl.

