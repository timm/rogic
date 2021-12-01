:- [graphs].

lottsaOutputs(_L).      % :- length(L,N), N > 3.
lottsaAssumptions(_L).  % :- length(L,N), N > 4, N < 9.
lottsaCover(_N).        % :- N > 60.

lottsa :-
	com('-re'),
	avt(AVT),
	xs(XS),length(XS,N),

	someIo(5,XX,I,O),
	between(1,3,R1a),
	between(1,3,R2a),
	R1 is R1a*4 - 4 +1,
	R2 is R2a*4 - 4 + 1,
	T1 is cputime,
	ht0N(23,O,I,R1,R2,P-_/_,_),
	T2 is cputime,
	T3 is (T2-T1)/(R1*R2),
	format('o,~w,~w,~w,~w,~w,~w~2f~n',[N,AVT,XX,R1,R2,P,T3]).

joinTheories(A,B,Links) :-
	contents(A,[*VA|RestA],CA), 
        contents(B,[*VB|RestB],CB),
	append(VA,VB,VNew),
	lprints([VNew],'*'),
	lprints(RestA,''), lprints(RestB,''),

	rMembers(10,CA,Lefts1), rMembers(10,CB,Rights1),
	aLinks(Lefts1,Rights1,Links1),

	rMembers(10,CB,Lefts2), rMembers(10,CA,Rights2),
	aLinks(Lefts2,Rights2,Links2),

	rMembers(3,CA,Lefts3), rMembers(6,CB,Rights3),
	aIfLinks(Lefts3,Rights3,Links3),

	rMembers(3,CB,Lefts4), rMembers(6,CA,Rights4),
	aIfLinks(Lefts4,Rights4,Links4),

	flatten([Links1,Links2,Links3,Links4],Links),
	
	lprints(Links,'*'),
	write('*done.'),nl,
	length(RestA,LRA),format('%la=~w~n',[LRA]),
        length(RestB,LRB),format('%la=~w~n',[LRB]),
        length(Links,LAll),format('%ll=~w~n',[LAll]).

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

term_expansion((:- m(X),Y),L) :- bagof(X,Y,L).

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

portray(i(_T@X,V,_L)) :- write(X=V).
portray(x(X,_T,V)) :- write(X=V).

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



