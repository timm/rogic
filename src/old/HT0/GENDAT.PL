:- [graphs].

lottsaOutputs(_L).      % :- length(L,N), N > 3.
lottsaAssumptions(_L).  % :- length(L,N), N > 4, N < 9.
lottsaCover(_N).        % :- N > 60.

lottsa :-
	com('-re'),
%	avt(AVT),
	xs(XS),length(XS,N),

	someIo(5,XX,I,O),
	between(1,3,R1a),
	between(1,4,R2a),
	R1 is R1a*4 - 4 +1,
	R2 is R2a*4 - 4 + 1,
	T1 is cputime,
	flag(atime,_,0),
	ht0N(23,O,I,R1,R2,P-_/_,_),
	T2 is cputime,
	T3 is (T2-T1)/(R1*R2),
	flag(atime,A0,A0),
	A is A0/(R1*R2),
	format('                           o,n,~w,xx,~w,r1,~w,r2,~w,p,~w,t,~2f,a,~2f~n',[N,XX,R1,R2,P,T3,A]).

nkl :-
	protocola('out.nkl'),
	between(4,4,N0), N is 25*N0,
	member(K,[2,2.25,2.50,2.75,3,4,5,6,7]),
	between(1,10,X),
	get_time(Time),
	convert_time(Time,_,_,_,Hour,Minute,Second, _),
	format('k,~w:~w:~w,n,~w,k,~w,x,~w',[Hour,Minute,Second,N,K,X]),
	nkl(666,N,K,X),
	fail.
nkl :- noprotocol.

nkl(F,N,K,X) :-
	length(Vars,N),
	maplist(avar,Vars,Vars),
	L is round(X * N),
	L < 1000,
	format(',ll,~w~n',[L]),
	asString('tk~w~w.pl',[K,F],File),
	tell(File),
	write(':- dynamic defined/1.'),nl,
	forall(between(1,L,_),
               (k(K,Vars,Clause),
	        print(Clause), write('.'),nl)),
        write(':- m(hasParent(X)),hasParent0(X).'),
	nl,
	told,
	load_files([File],[silent(true)]),
	forall(lottsa,true).
	
avar(X,X) :- gensym(v,X).

k(2,All,(x(X1,T,V1) :- x(X2,T,V2))) :-
	rMembers(2,All,[X1,X2]),
	v(V1), v(V2).
k(3,All,(x(X1,T,V1) :- x(X2,T,V2), x(X3,T,V3))) :-
	rMembers(3,All,[X1,X2,X3]),
	v(V1), v(V2), v(V3).
k(4,All,(x(X1,T,V1) :- x(X2,T,V2), x(X3,T,V3),x(X4,T,V4))) :-
	rMembers(4,All,[X1,X2,X3,X4]),
	v(V1), v(V2), v(V3),v(V4).
k(5,All,(x(X1,T,V1) :- x(X2,T,V2), x(X3,T,V3),x(X4,T,V4),x(X5,T,V5))) :-
	rMembers(5,All,[X1,X2,X3,X4,X5]),
	v(V1), v(V2), v(V3),v(V4), v(V5).
k(6,All,(x(X1,T,V1) :- 
         x(X2,T,V2), x(X3,T,V3),x(X4,T,V4),
         x(X5,T,V5), x(X6,T,V6))) :-
	rMembers(6,All,[X1,X2,X3,X4,X5,X6]),
	v(V1), v(V2), v(V3),v(V4), v(V5), v(V6).
k(7,All,(x(X1,T,V1) :- 
         x(X2,T,V2), x(X3,T,V3),x(X4,T,V4),
         x(X5,T,V5), x(X6,T,V6),x(X7,T,V7))) :-
	rMembers(7,All,[X1,X2,X3,X4,X5,X6,X7]),
	v(V1), v(V2), v(V3),v(V4), v(V5), v(V6), v(V7).

v(1) :- 0 is random(2),!.
v(-1).

joinTheories(A,B,Links) :-
	contents(A,[*VA|RestA],CA), 
        contents(B,[*VB|RestB],CB),
	append(VA,VB,VNew),
	lprints([VNew],'*'),
	lprints(RestA,''), lprints(RestB,''),

	length(CA,CAL),length(CB,CBL),
	Magic is round((CAL+CBL) * 0.3),
	Magic1 is round(Magic/3),
	Magic2 is Magic1*2,
	%print(magic(Magic,Magic1,Magic2)), nl,

	rMembers(Magic,CA,Lefts1), rMembers(Magic,CB,Rights1),
	aLinks(Lefts1,Rights1,Links1),

	rMembers(Magic,CB,Lefts2), rMembers(Magic,CA,Rights2),
	aLinks(Lefts2,Rights2,Links2),

	rMembers(Magic1,CA,Lefts3), rMembers(Magic2,CB,Rights3),
	aIfLinks(Lefts3,Rights3,Links3),

	rMembers(Magic1,CB,Lefts4), rMembers(Magic2,CA,Rights4),
	aIfLinks(Lefts4,Rights4,Links4),

	flatten([Links1,Links2,Links3,Links4],Links),
	
	lprints(Links,'*'),
	write('*done.'),nl.

%	format('%la=~w~n',[LRA]),
 %       
	%format('%la=~w~n',[LRB]),
        %length(Links,LAll),format('%ll=~w~n',[LAll]).

ifP(*if _).
ruleP(*if _).
ruleP(*X) :- link(X,_,_,_,_,_).


lprints(L,B) :- 
	member(X,L),
	write(B),
	write(X),
	write('.'),
	nl, 
	fail.
lprints(_,_).

reads(F,L) :-
	see(F), read(X),reads1(X,L),seen.

reads1(end_of_file,[]) :- !.
reads1(*done,[]) :- !.
reads1(*_=_,Rest) :- read(Y), reads1(Y,Rest).
reads1(X,[X|Rest]) :- read(Y), reads1(Y,Rest).

contents(F,X,Out) :- 
	reads(F,X), 
	maplist(contents1,X,Y),
	flatten(Y,Z), 
	sort(Z,Out).

rdash(_-X,X).

contents1(*if no X then Y,[X|Rest]) :- !, contents1(Y,Rest).
contents1(*if X then Y,[X|Rest]) :-!, contents1(Y,Rest).
contents1(*X,[A,B]) :- link(X,_,A,_,B,_),!.
contents1(_,[]).

odds(X) :-
	gs(G), xs(XS),
	maplist(lengthKids,G,Ls),
	av(Ls,N1),
	length(XS,N2),
	X is N1/N2.

%newLink(L) :- 
%	xs(XS), length(XS,L), rMembers(2,XS,[A,B]).
	
aIfLinks([],[],[]).
aIfLinks([H0|T0],[H1,H2|T1],[if H0 then L|Rest]) :-
	(1 is random(2)
	-> Control = H0
        ;  Control = (no H0)),
	aLink(H1,H2,L),
	aIfLinks(T0,T1,Rest).

aLinks([],[],[]).
aLinks([H0|T0],[H1|T1],[L|Rest]) :-
	aLink(H0,H1,L),
	aLinks(T0,T1,Rest).

aLink(A,B,Out) :-
	aFact(link(_  ,_,A,_,B,_),
              link(Out,_,_,_,_,_)).
	

aFact(X, B) :-
	findall(X,  clause(X, true),L0),
        rlswap(L0, L),
        member(B, L).


lengthKids(_A-B,N) :- length(B,N).


coversHows([],X0,X,Y0,Y) :- 
	flatten(X0,X1),sort(X1,X), 
	flatten(Y0,Y1),sort(Y1,Y).
coversHows([Covered/How|Rest],Cov0,Cov,Hows0,Hows) :-
	coversHows(Rest,[Covered|Cov0],Cov,
                        [How|Hows0],Hows).



flipper([],[]).
flipper(i(_T@X,-1,_L),X=1).
flipper(i(_T@X,1,_L), X= -1).
flipper(i(_T@X,V,_L), X=V).
flipper([H0|T0],[H|T]) :- flipper(H0,H), flipper(T0,T).

worlds(X) :-
	once((roots(Roots),
              lottsaResults(A0,_Causes,Cover0,_Missed,_P1),
	      maplist(isX,Cover,Cover0),
	      length(Cover,N1),
	      N1 > 0
             )),
	rMembers(2,A0,A1),
        flipper(A1,A), 
	ht0OneA(23,A,Cover,Roots,P2-_A2/C2,_),
	      P2 > 0,
	      print(n1(N1)),
	      coversHows(C2,[],Cover1,[],_),
	      %maplist(isX,Cover2,Cover1),
	      %print(cover1(Cover2)),
	      length(Cover1,N2),
	      print(n2(N2)),
	      X is N2.

%portray(i(_T@X,V,_L)) :- write(X=V).
%portray(x(X,_T,V)) :- write(X=V).

diffWorlds(Repeats,A2-U1,A3-U2) :-
	
	xs(XS),
	      roots(Roots),
	      subtract(XS,Roots,NonRoots0),
	      sublist(isChange,NonRoots0,NonRoots),
              between(1,Repeats,_),
	      N is 5+ random(10),
	      rMembers(N,NonRoots,Goals1),
	      rMembers(N,NonRoots,Goals2),
	      
	      ht0OneA(1,[],Goals1,Roots,_-A1/C1,_),
	      \+ A1=[],
	      maplist(pacGrab,C1,Cover1),
	      %Cover1=[_,_|_],
	rMembers(2,A1,A2),
	flipper(A2,A3),
	ht0OneA(2,A3,Goals2,Roots,_-A4/C2,_),
	\+A4=[],
	maplist(pacGrab,C2,Cover2),
	%Cover2=[_,_|_],
	subtract(Cover1,Cover2,U1),\+ U1=[],
	subtract(Cover2,Cover1,U2),\+ U2=[].

pacGrab(C/_,C).



