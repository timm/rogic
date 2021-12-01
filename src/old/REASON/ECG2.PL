/*

=head1 Extended clause grammers (version 2)

Speed up the manipulation of  named fields within DCGs.

=head1 Header

=head2 Loads */

 :- [names]. /*

=head2 Flags */

 :- X = (xpand/1,eval/1,eval1/1,freeze/1,wrap/1),
	multifile(X),discontiguous(X),dynamic(X). /*

=head1 Body . 

=head2 Tidy */

 tidy(A,C) :- tidy1(A,B), (B = (Head :- true) -> C=Head ;  C=B).

 tidy1(A,C) :- once(tidy2(A,C)).

 tidy2(A,         A) :- var(A).
 tidy2(true,   true).
 tidy2(not(A),    R) :- tidy1(A,TA),(TA=true-> R=fail; R=not(TA)).
 tidy2(\+(A),     R) :- tidy1(A,TA),(TA=true-> R=fail; R= \+(TA)).
 tidy2((A :- B),  R) :- tidy1(B,TB),(TB=true-> R=A; R=(A:-TB)).
 tidy2((A;B),     R) :- tidy1(A,TA), tidy1(B,TB),(TB=true -> R=TA; R=(TA;TB)).
 tidy2((A,B),     R) :- tidy1(A,TA), tidy1(B,TB),(TB=true -> R=TA; R=(TA,TB)).
 tidy2((A->B),    R) :- tidy1(A,TA), tidy(B,TB), (TA=true-> R=TB; R=(TA->TB)).
 tidy2(((A,B),C), R) :- tidy1((A,B,C), R).

 tidy2(forall(A0,B0), forall(A,B)) :- tidy1(A0,A),tidy(B0,B).
 tidy2(once(A0),          once(A)) :- tidy1(A0,A).
 tidy2(findall(X,Y0,Z), findallof(X,Y,Z)) :- tidy(Y0,Y).

 tidy2(A,A). /*

=head2 Things we can run at load time

Always: */

  eval(X =.. [H|T])  :- var(X), is_list([H|T]). /*
  
If there is only 1 way to do so (none known at this time). */

 %eval1(X).
  /*


=head2 Things we expand at load time

None known at this time. */

 %expand(X).
 /*

=head2 Things we should wrap */

 wrap(X) :- predicate_property(X,built_in). /*

=head2 Things we should not mess with */

 freeze(X) :- predicate_property(X,Y), member(Y,[foriegn,built_in]). /*

=head2 C<X/3>: the worker for the expansion */

 x((X0 --> in C,Y0),Out) :- add2(X0,X,W0,W), x1(Y0,Y,C,W0,W),tidy((X :- Y),Out).

 x1(In,Out,Cxt,W0,W) :- once(x2(In,Out,Cxt,W0,W)).

 x2(X,  X,    _,W,   W) :- var(X).
 x2((X0,Y0),(X,Y),C,W0,W) :- x1(X0,X,C,W0,W1),x1(Y0,Y,C,W1,W).
 x2((X0;Y0),(X,W=W1;Y,W=W2),C,W0,W) :- x1(X0,X,C,W0,W1),x1(Y0,Y,C,W0,W2).
 x2(X0, (B4,X,After),C,W0, W) :-	wrap(X),
	wrapper(X0,B40,[],After0,[],X),
        l2w(B40,B41),       x1(B41,     B4,C,W0,W1),
	l2w(After0,After1), x1(After1,After,C,W1,W).
 x2(X0, X,    C,W0,  W) :- onlyClause(X0,X1),in(C,W0,W1),x1(X1,X,C,W1,W).
 x2(X0, X,    C,W0,  W) :- onlyClause(at(X0,W0,W1),X1),in(C,W0,W),x1(X1,X,C,W1,W).
 x2(X0, X,    C,W0,  W) :- xpand(X0), clause(X0,X1),x1(X1,X,C,W0,W).
 x2({X},X,    _,W,   W).
 x2(X, true,  _,W,   W) :- eval1(X),onlyClause(X,Y),Y.
 x2(X,  true, _,W,   W) :- eval(X),X.
 x2(X,  X,     _,W,  W). /*

=head2 Utils */

 onlyClause(X,Y) :- one(clause(X,_)), clause(X,Y). /*

C<one/1> is true if there is only one solution to some goal. */

 one(X)    :- F='$_', flag(F,_,0), \+ many(F,X),flag(F,1,1). /*

C<Many/2> is true if more than one solution to some goal exists.
As a side-effect, if it succeeds it sets some flag C<F> to 2. */

 many(F,X) :-  X, flag(F,N,N+1),N > 1,!. /*

=head1 Footer

=head2 Start-ups */

 term_expansion((X --> in Y and Z),Out) :- ecgExpand, x((X --> in Y,Z),Out).

 ecgExpand.

/*
todo

66 ?- x((eg(2) --> in emp, the age=1),Y). */


