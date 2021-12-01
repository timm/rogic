onesTwos(Combo,X,Y,One,Two) :- 
	my_findall(X,Y,All), !,
	maplist(arg(1),All,Ones),
	maplist(arg(2),All,Twos),
	combo(Combo,Ones,One),
	unions(Twos,[],Two).

combo(+,All,I) :- sum(All,I).
combo(*,All,I) :- prod(All,I).

who(_).
touch(X,X,X).

r(X,Y) :- r(X,Y,[],_).

r(top,S) -->
	{Id  =r,
	 Type=requirement,
	 L   =1,
	 Who =w1,
	 Comb=(+)},
        {who(Who)},
	 new(Type-Id),
	{likely(L)},
	 {S1=1},
%	r1(S1),
%	r2(S2),
	 touch(Path0),
	 onesTwos(Comb,S0-Path1,f(Id,S0,Path0,Path1),SF),
	 {sum([S1],Sum),
          print(r(top) is (Sum*SF)),nl,
	  S is S1-(Sum*SF)}.

f(X,Y) :- f(X,Y,[],_).

members([],_).
members([A=B/C|T],X) :- once((member(A=B,X); A=C)), members(T,X).

xpand(Spec,(Head :- who(Who)
	            ,new(Type-Id)
	            ,likely(L)
	            ,S1=0.9
	            ,onesTwos(Combo,S0-P1,Filter,Fvalue,Pout)
	            ,sum([S1],Sum)
                    ,S is (Sum*Fvalue)
                    )) :-
	members([id=Id/1,type=Type/f,l=L/1,who=Who/me,
                 combo=Combo/(*),controller=Con/f],Spec),
	Head   =.. [Type,Id,S,Pin,Pout],
	Filter =.. [Con,Id,S0,Pin,P1].


f(r,S) -->
	{Id  =f1,
	 Type=faultMode,
	 L   =1,
	 Who =w1,
	 Comb=(*)},
	{who(Who)},
	 new(Type-Id),
	{likely(L)},
	 {S1=0.9},
	 touch(Path0),
	 onesTwos(Comb,S0-Path1,p(Id,S0,Path0,Path1),PF),
	 {print(sum(S1)),
	  sum([S1],Sum),
          print(f(r) is (Sum*PF)),nl,
	  S is (Sum*PF)}.
	
p(X,Y) :- p(X,Y,[],_).
p(f1,S) -->
	{Id  =pa,
	 Type=p,
	 L   =1,
	 Who =w1},
	{who(Who)},
	 new(Type-Id),
	{likely(L)},
	 {S1=0.2,
	 S is S1}.


p(f1,S) -->
	{Id  =pb,
	 Type=pact,
	 L   =1,
	 Who =w1},
	{who(Who)},
	 new(Type-Id),
	{likely(L)},
	{S1=0.7,
	S is S1}.

prod(X,Y) :- prod(X,1,Y).
prod([],X,X).
prod([H|T],In,Out) :-
	Temp is In * H,
	prod(T,Temp,Out).

sum(X,Y) :- sum(X,0,Y).
sum([],X,X).
sum([H|T],In,Out) :- 
	Temp is H + In, 
	sum(T,Temp,Out).

my_findall(X,Y,Z) :- findall(X,Y,Z),!.
my_findall(_,_,[]).

new(A,In,_s) :- member(A,In),!,fail.
new(A,In,[A|In]).

unions([],X,X).
unions([H|T],In,Out) :-
	union(H,In,Temp),
	unions(T,Temp,Out).

:- arithmetic_function(rand).
:- arithmetic_function(sum/1).
:- arithmetic_function(prod/1).

rand(X) :- X is random(10000)/10000.

likely(X) :- Y is rand, Y < X.
