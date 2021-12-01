:- op(998,xfy,by). % for circuits in parrallel
:- op(997,xfy,to). % for circuits in series 

%blub(Id,Volts,Amps,Mode,Shine,N)
bulb(_,_Any, 0, blown, dark,   0).  
bulb(_,+,    +, ok,    light,  1).
bulb(_,-,    -, ok,    light,  1).
bulb(_,0,    0, ok,    dark,   0).

%switch(Id,Volts,Amps,Mode)
switch(_,0,     _Any,on).   
switch(_,_Any,  0,   off).

% battery(Id,Volts,Amps
battery(_,_,+).

sum(+,+,+).    sum(+,0,+). sum(+,-,_Any).
sum(0,+,+).    sum(0,0,0). sum(0,-,-).
sum(-,+,_Any). sum(-,0,-). sum(-,-,-).

access(Field=X,Term) :- change(Field,X,X,Term,Term).
access([], _).
access([H|T],  Term) :- access(H,Term), access(T,Term).
 


%changes([H0|T],Field,F0,F,H, [H|T]) :- change(Field,F0,F,H0,H).
%changes([H|T0],Field,F0,F1,H1,[H|T]) :- changes(T0,Field,F0,F1,H1,T).

term_expansion(define(Term),All) :-  
    defines(Term,All).
%term_expansion(circuit(N,C0),circuit(N,C,Parts)) :-  pre(C0,C,Parts).
    
oldNew(Term,change(Field,Old,New,C0,C1)) :-
    functor(Term,F,A),  Term =.. [F|Fields],
    functor(C0,  F,A),  C0   =.. [F|L0],
    functor(C1,  F,A),  C1   =.. [F|L1],
    oldNew1(Fields,Field,Old,New,L0,L1).

oldNew1([Field|_], Field,Old,New,[Old|T ],[New|T ]).
oldNew1([_|Fields],Field,Old,New,[H  |T1],[H  |T2]) :-
    oldNew1(Fields,Field,Old,New,T1,T2).
      
defines(Term,All) :- 
    bagof(One, Term^oldNew(Term,One), All). 
    
%exists(X) :- change(_,_,_,_,X).
            
define(bulb(id,volts,amps,mode,shine,n)).
define(switch(id,volts,amps,mode)).
define(battery(id,volts,amps)). 
define(wme(parts,goals)).

push(F,X,W0,W) :- change(F,[X|Rest],Rest,W0,W).

prep(In,Parts,Goals) :- 
    access([goals=Goals,parts=[]],Wme0),
    prep(In,_,_,Wme0,Wme),
    access([goals=[],parts=Parts],Wme).

prep(A,B,C,W0,W) :- once(prep1(A,B,C,W0,W)).
prep1([],    _,_) --> [].
prep1([X|Y] ,_,_) --> prep(X, _, _), prep(Y, _, _).
prep1(X to Y,V,A) --> prep(X,V1, A), prep(Y,V2, A), push(goals, sum(V1,V2,V)).
prep1(X by Y,V,A) --> prep(X,V ,A1), prep(Y,V ,A2), push(goals, sum(A1,A2,A)).
prep1(X=Y,_,_) -->   match(X,Y).
prep1(X+Y,_,_) -->  id2mode(X=M1), id2mode(Y=M2), push(goals, inf(+,M1,M2)).
prep1(X-Y,_,_) -->  id2mode(X=M1), id2mode(Y=M2), push(goals, inf(-,M1,M2)).
prep1(Id:Type, V,A) --> 
    {access([id=Id,volts=V,amps=A],X),
    functor(X,Type,_)},
    push(goals,X),
    partExists(X).
    
partExists(P, W,W) :- access(parts=Ps,W), member(P,Ps),!.
partExists(P) --> change(parts,P0,[P|P0]). 

match(Id1, Id2, W,W) :-
        access(parts=Ps0,W),
        select(P1,Ps0,Ps1),
        change(id, Id1, _, P1, P),
        select(P2,Ps1,_),
        change(id, Id2, _, P2, P).
        
id2mode(X,M) -->
    access(parts=Ps), 
    {member(P,Ps), access([id=X,mode=M],P)}.
    
inf(+,dark,off).  inf(+, light,on).
inf(-,dark,on).   inf(-,light,off).
 
show([H|T]) :- !,not(not((numbervars([H|T],0,_),forall(member(One,[H|T]),(print(One),nl))))).
show(X) :- not(not((numbervars(X,0,_),print(X),nl))). 

circuit(2 ,N,  sw1(N):switch to b1(N):bulb
       ).
       

circuit(1,N, bat(N):battery to sw1(N):switch to b1(N):bulb to
             (sw2(N):switch to b2(N):bulb
              by
              b3(N):bulb
              by
               sw3(N):switch
             ) to
             bat(N):battery
       ).
 
circuits :-
    circuit(1,a,A), 
    prep([A],P0,C0), lurch(L0),
    shines(P0,S),print(S),nl.
    
    /*print(C0),nl, kludge(constraints(P0),C0),!,
    
    between(1,1000,_),
    once(rand(P0)),once(rand(C0)),    
    shines(P0,S),
    write(S),flush_output(user).*/
    
threshold1(0.8).
threshold(L,T) :- threshold1(C),length(L,N), threshold(C,N,T).

threshold(C,N,T) :-
    T is 1 - (e^(log(1-C)/N)).

r(X,Y) :- once(r1(X,Y)).

r1((X0,Y0,Z0),r(*,[X|L])) :- r(X0,X),r((Y0,Z0),r(*,L)).
r1((X0;Y0;Z0),r(+,[X|L])) :- r(X0,X),r((Y0;Z0),r(+,L)).
r1((X0,Y0),   r(*,[X,Y])) :- r(X0,X),r(Y0,Y).
r1((X0;Y0),   r(+,[X,Y])) :- r(X0,X),r(Y0,Y).
r1(X,X).




%rone(!L,?H,?T)
rone(L,H,T) :- rone1(L,H,T),!.
rone(L,H,T) :- rone(L,H,T).

rone1([X],X,[]).
rone1([X,Y|Z],X,[Y|Z])       :- random(1000)/1000 > 0.5.
rone1([X,Y|Z],One, [X|Rest]) :- rone1([Y|Z],One,Rest).

:- retractall(standard(_)), forall(predicate_property(X,built_in),assert(standard(X))).

lurch(X) :- once(lurch0(X,Y)), lurch1(Y).

lurch0(true,       true).
lurch0([H|T],     or(L)) :- rs([H|T],L).
lurch0(and([]),    true).
lurch0(or([]),     true).
lurch0(and(X),   and(X)).
lurch0(or(X),     or(X)).
lurch0(r(+,L0),   or(L)) :- rs(L0,L).
lurch0(r(*,L0),  and(L)) :- rs(L0,L).
lurch0((X,Y),    and(L)) :- r((X,Y),r(_,L0)),rs(L0,L).
lurch0((X;Y),     or(L)) :- r((X;Y),r(_,L0)),rs(L0,L).
lurch0(X,       call(X)) :- standard(X).
lurch0(X,       next(X)).
    
lurch1(true).
lurch1(call(X)) :- X.
lurch1(or(L))   :- member(One,L), lurch(One).
lurch1(and(L))  :- select(One,L,Rest), lurch(One), lurch(and(Rest)).
lurch1(next(X)) :-
    bagof(X/Y,clause(X,Y),L0),
    rs(L0,L),
    member(X/Y,L),
    lurch(Y).
    
   



kludge(H,X) :-  c2l(X,C), portray_clause((H :- C)).
    
c2l([X,Y|Z],(X,Rest)) :- !, c2l([Y|Z],Rest).
c2l([X],X).

 

       
      
go1(Db,S) :-   circuit(1,C,Db), va(C,_,_),shines(Db,S).

/*go :-  go1(Db),
       forall((member(Part,Db),nl,access(F=V,Part)),
           format(' ~p: ~p',[F,V])). */
   
shine(Db,N)    :- member(bulb(_,_, _, _, _,  N),Db).
shines(Db,Sum) :- bagof(N,Db^shine(Db,N),All), total(All,Sum).

total([H|T],S) :- total(T,H,S).

total([],S,S).
total([H|T],X0,S) :- X is X0 + H, total(T,X,S).
 

nof(G,N) :- gensym(nof,X), flag(X,_,0), forall(G, flag(X,N,N+1)), flag(X,N,N).
/*


constraints :-
        disable(A, B),
        sum(C, D, E),
        sum(F, G, D),
        sum(H, I, G),
        sum(J, C, I),
        battery(bat(c), C, K),
        sum(L, M, K),
        sum(N, O, M),
        switch(sw3(c), J, O, P),
        bulb(b3(c), J, N, Q, R, S),
        sum(T, U, J),
        bulb(b2(c), U, L, V, W, X),
        switch(sw2(c), T, L, Y),
        bulb(b1(c), H, K, Z, A1, B1),
        switch(sw1(c), F, K, B),
        battery(bat(c), C, K),
        enable(C1, D1),
        sum(E1, F1, G1),
        sum(H1, I1, F1),
        sum(J1, K1, I1),
        sum(L1, E1, K1),
        battery(bat(b), E1, M1),
        sum(N1, O1, M1),
        sum(P1, Q1, O1),
        switch(sw3(b), L1, Q1, R1),
        bulb(b3(b), L1, P1, S1, T1, U1),
        sum(V1, W1, L1),
        bulb(b2(b), W1, N1, X1, Y1, Z1),
        switch(sw2(b), V1, N1, A2),
        bulb(b1(b), J1, M1, B2, C2, D2),
        switch(sw1(b), H1, M1, D1),
        battery(bat(b), E1, M1),
        sum(E2, F2, G2),
        sum(H2, I2, F2),
        sum(J2, K2, I2),
        sum(L2, E2, K2),
        battery(bat(a), E2, M2),
        sum(N2, O2, M2),
        sum(P2, Q2, O2),
        switch(sw3(a), L2, Q2, R2),
        bulb(b3(a), L2, P2, S2, T2, U2),
        sum(V2, W2, L2),
        bulb(b2(a), W2, N2, A, X2, Y2),
        switch(sw2(a), V2, N2, Z2),
        bulb(b1(a), J2, M2, C1, A3, B3),
        switch(sw1(a), H2, M2, C3),
        battery(bat(a), E2, M2).
        
battery(bat(a), A, B)
switch(sw1(a),  C, B, D)
bulb(b1(a),     E, B, F, G, H)
switch(sw2(a),  I, J, K)
bulb(b2(a),     L, J, M, N, O)
sum(I, L, P)
bulb(b3(a),     P, Q, R, S, T)
switch(sw3(a),  P, U, V)
sum(Q, U, W)
sum(J, W, B)
battery(bat(a), A, B)
sum(P, A, X)
sum(E, X, Y)
sum(C, Y, Z)
sum(A, Z, A1)

?- forall(go1(_,X),print(X)).
222222211111111112222222333333311111111112222222222222211111222
222211111222222211111111111111122222221111122222221111111111

X = _G158 

Yes
?- 
c(a, A) :-
        battery(bat(a), B, C),
        switch(sw1(a),  D, C, E),
        bulb(b1(a),     F, C, G, H, I),
        switch(sw2(a),  J, K, L),
        bulb(b2(a),     M, K, N, O, P),
        sum(J, M, Q),
        bulb(b3(a),     Q, R, S, T, U),
        switch(sw3(a),  Q, V, W),
        sum(R, V, X),
        sum(K, X, C),
        battery(bat(a), B, C),
        sum(Q, B, Y),
        sum(F, Y, Z),
        sum(D, Z, A1),
        sum(B, A1, B1).
        

battery(bat(a), A, B)
switch(sw1(a),  C, B, D)
bulb(b1(a),     E, B, F, G, H)
switch(sw2(a),  I, J, K)
bulb(b2(a),     L, J, M, N, O)
bulb(b3(a),     P, Q, R, S, T)
switch(sw3(a),  P, U, V)

 

change(id,   A,B,bulb(A,C,D,E,F,G),bulb(B,C,D,E,F,G)).
change(volts,A,B,bulb(C,A,D,E,F,G),bulb(C,B,D,E,F,G)).
change(amps, A,B,bulb(C,D,A,E,F,G),bulb(C,D,B,E,F,G)).
change(mode, A,B,bulb(C,D,E,A,F,G),bulb(C,D,E,B,F,G)).
change(shine,A,B,bulb(C,D,E,F,A,G),bulb(C,D,E,F,B,G)).
change(n,    A,B,bulb(C,D,E,F,G,A),bulb(C,D,E,F,G,B)).

change(id,   A,B,switch(A,C,D,E),switch(B,C,D,E)).
change(volts,A,B,switch(C,A,D,E),switch(C,B,D,E)).
change(amps, A,B,switch(C,D,A,E),switch(C,D,B,E)).
change(mode, A,B,switch(C,D,E,A),switch(C,D,E,B)).

change(id,   A,B,battery(A,C,D),battery(B,C,D)).
change(volts,A,B,battery(C,A,D),battery(C,B,D)).
change(amps, A,B,battery(C,D,A),battery(C,D,B)).

*/
    
    
