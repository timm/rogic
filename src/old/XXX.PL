
    beat(lewis,tyson).
    beat(douglas,tyson).
    beat(rahman,lewis).
    beat(lewis,rahman).
    beat(tyson,golota).
    beat(ali,foreman).
    beat(ali,liston).
    beat(ali,frazier).

    whoP(lewis).
    whoP(tyson).
    whoP(douglas).
    whoP(rahman).
    %...

    wonOnce(Who) :- once(beat(Who,_)).
    wonNever(Who) :- \+ wonOnce(Who).
    lostOnce(Who) :- once(beat(_,Who)).
    lostNever(Who) :-  \+ lostOnce(Who).

    class(X,fighter)   :- whoP(X),wonOnce(X),  lostOnce(X).
    class(X,winner)    :- whoP(X),wonOnce(X),  lostNever(X).
    class(X,sportsman) :- whoP(X),wonNever(X), lostOnce(X).

    winner( Who,X) :- beat(Who,_) -> X=1 ; X = 0 .
    loser(  Who,X) :- beat(_,Who) -> X=1 ; X = 0 .

    status(Who,W,L) :- winner(Who,W), loser(Who,L).

    type(Who,Class) :- whoP(Who), status(Who,W,L), type1(W,L,Class).

    type1(1,1,fighter).
    type1(1,0,winner).
    type1(0,1,sportsman).
    type1(0,0,spectator).

      student_(name,      A0,A,student(A0,B,C,D,E),student(A,B,C,D,E)).
      student_(id,        B0,B,student(A,B0,C,D,E),student(A,B,C,D,E)).
      student_(dept,      C0,C,student(A,B,C0,D,E),student(A,B,C,D,E)).
      student_(cgpa,      D0,D,student(A,B,C,D0,E),student(A,B,C,D,E)).
      student_(attendance,E0,E,student(A,B,C,D,E0),student(A,B,C,D,E)).

      %access
      student_(A=B,C) :- student_(A,B,B,C,C).
     
      %update
      student_(A is B,C,D) :- student_(A,_,B,C,D).

      %updates
      student_([],S,S).
      student_([H|T],S0,S) :- student_(H,S0,S1), student_(T,S1,S).

      %add one
      student_(+X,B,C) :- student_(X,Old,New,B,C), New is Old + 1.

      % init
      student_(new(S)) :- 
		       student_([name is any(one)
                                ,id is any(where1)
                                ,dept is any(where2)
                                ,cgpa is 0
                                ,attendance is 0],_,S).

      rollCall(S0,S) :-  student_(+attendance,S0,S).

      demo(S) :- student_(new(S0)), rollCall(S0,S).

add(X,L0,L) :- append([X],L0,L).
del(X,L0,L) :- append(Pre,[X|Post],L0), append(Pre,Post,L).

%optimizer
optimize :- fail.

goal_expansion(b_(A,B,C),E) :-
	optimize,
	singleton(b_(A,B,C)),
	clause(b_(A,B,C),E).

goal_expansion(b_(A,B,C,D,E),true) :-
	optimize,
	singleton(b_(A,B,C,D,E)),
	b_(A,B,C,D,E).

term_expansion((+X --> Y),Out) :-
	expand_term((X --> Y),Temp),
	(optimize -> tidy(Temp,Out) ; Temp=Out).

singleton(X) :- 
    Sym='$singleton_',
    flag(Sym,_,0),
    \+ singleton1(Sym,X),
    flag(Sym,1,1).

singleton1(Sym,X) :- clause(X,_),flag(Sym,N,N+1),N > 1,!.

tidy(A,C) :-
    tidy1(A,B),
    (B = (Head :- true) -> C=Head ;  C=B).

tidy1(A,C) :- once(tidy2(A,C)).

tidy2(A,             A) :- var(A). 
tidy2((A,B),    (A,TB)) :- var(A), tidy1(B,TB).
tidy2((A,B),    (TA,B)) :- var(B), tidy1(A,TA).
tidy2(((A,B),C),     R) :- tidy1((A,B,C), R).
tidy2((true,A),      R) :- tidy1(A,R).
tidy2((A,true),      R) :- tidy1(A,R).
tidy2((A;true),      R) :- tidy1(A,R).
tidy2((true;A),      R) :- tidy1(A,R).
tidy2((A;B),   (TA;TB)) :- tidy1(A,TA), tidy1(B,TB).
tidy2((A->B), (TA->TB)) :- tidy1(A,TA), tidy1(B,TB).
tidy2(not(A),  not(TA)) :- tidy1(A,TA).
tidy2((A :- B), R) :-
    tidy1(B,TB),(TB=true-> R=A; R=(A:-TB)).
tidy2((A,B),  R) :-
    tidy1(A,TA), tidy1(B,TB),(TB=true -> R=TA; R=(TA,TB)).
tidy2(A,A).





b_(contents,A0,A, b(A0,B,C,D), b(A,B,C,D)).
b_(maxU,    B0,B, b(A,B0,C,D), b(A,B,C,D)).
b_(maxSize, C0,C, b(A,B,C0,D), b(A,B,C,D)).
b_(size,    D0,D, b(A,B,C,D0), b(A,B,C,D)).

koset_add([], El, [El]). 
koset_add([H=X|T], El=Y, Add) :-
	compare(Order, H, El),
	kaddel(Order, H, X,T, El, Y,Add).

kaddel(<, H, X,T,  El, Y,[H=X     |Add]) :- koset_add(T, El=Y, Add).
kaddel(=, H, _,T, _El, Y,[H=Y     |T]). 
kaddel(>, H, X,T,  El, Y,[El=Y,H=X|T]).


%>

%>
%Other accessors to handle common tasks.
%<
%For example- set a field;
%<
+b_(X is Y) --> b_(X,_,Y).
%>
%or access a fieldl
%<
+b_(X=Y)    --> b_(X,Y,Y).
%>
%or test if we are full;
%<

+b_(full)    --> b_(maxSize=M),b_(size=M).%contents=C),{length(C,M)}.

+b_(+X) --> b_(X,Old,New),{New is Old +1}.
						%>
%or initialize a new memory:
%<
+b_(init(Max))-->
	b_(size is 0),
	b_(contents is []),
	b_(maxU is -9999999),
	b_(maxSize is Max).
%>
%or find the minumum value seen so far;
%<
+b_(min(Key=Value))-->
	b_(contents=[Key=Value|_]).
%>
%or returns all the values;
%<
+b_(values(L)) --> b_(contents=L0), {maplist(arg(2),L0,L)}.
%>
%<
%or run some command without changing the memory;
%<
+b_(Com,X) :- b_(Com,X,X).
%>
%<
badd(U=X) --> b_(full) ,!, badd(full,U=X).
badd(U=X) --> badd(space,U=X),b_(+size).
%>
%If we are full, then after adding something, we delete the smallest item
%(which will be the head of the list):
%<
badd(full,U=X)  -->
	badd(space,U=X),
	b_(contents,[_|T],T).
%>
%If we try to add a new key=value pair to a full working memory, and
%it is less that the minimum value, we should just ignore it.
%Actually, this just happends automatically: the new minimum value will
%always be the left-most item and this is deleted after insertion by
%the above clause.
%
%If we have the space, then add in the new item and
%then update our knowledge of the maximum key seen so far.
%<
badd(space,U=X) -->
	b_(contents,Old,New),
	{koset_add(Old,U=X,New)},
	b_(maxU,Max0,Max),
	{Max is max(Max0,U)}.
%>
%<
badds(N,L,B) :- b_(init(N),_,B0),badds1(L,B0,B).
badds1([],B,B).
badds1([H|T]) --> badd(H), badds1(T).
%>
%Example predicate:
%<
egb:-
	forall(egb(B),(print(B),nl)).

egb(B) :- L = [10=a,20=b,17=d,3=f,9=h,4=l,3=ky], badds(3,L,B).

egb(B) :-
	keyValues(10000,X),
	badds(50,X,B).

keyValues(N,L) :- bagof(R,N^keyValue(N,R),L).

keyValue(N,Key=Value) :-
	between(1,26,Value),
	between(1,N,_),
	Key is random(1000000).



