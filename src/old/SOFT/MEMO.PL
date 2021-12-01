/*

=head1 Memos 

Actually, memoing with inconsistency checking. 

=head1 Header

=head2 Flags */
 
 :- dynamic       assumption/4. 
 :- dynamic       io/4.
 :- discontiguous io/4.
 :- multifile     io/4.  
 :- index(assumption(1.1,1,0)). /*

=head1 Body

=head2 Assume */

 reset :- retractall(assumption(_,_,_,_)).
 
 assume(X,_)   :- io(X,H,In,Out), assumption(H,In,Old,_),!,Out=Old.
 assume(X,How) :- io(X,H,In,Out),bassert(assumption(H,In,Out,How)).

 bassert(X) :- assert(X).
 bassert(X) :- retract(X),fail.

 memo(Goal,Results) :-
    \+ bad(Results), % problem of unbound assumptins
    Goal,
    ok(Results,byRule).

 old_(size,_,A,old(A,B,C,D,E
 old(L,Size,Agreements,Conflicts) :-
    old(L,Size,Agreemen
 old([],M,M).
 old([H|T],

 bad(L) :- 
    member(In=Out,L),
    hash_term(In,H
    nonvar(Out),
    assumption(In,Old,_),
    Out \= Old. 

 ok([],_).
 ok([In=Out|T],How) :- assume(In=Out,How),ok(T,How). 

 io(X=Y,H,X,Y) :- hash_term(X,H).
