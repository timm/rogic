/*

=head1 Accessor

Been at this one for years.

=head1 Header

=head2 Operators */

 :- op(1200,xfx,means).
 :- op(999,xfy, or).
 :- op(998,xfy, and).
 :- op(997, fy, not).
 :- op(800, xfy, with).
 :- op(799,fx,(`)).
 :- op(700, xfx,   :=).
 :- op(1,   fx,    in).
 :- op(2,  xfx,  next).
 :- op(1,   fx,   the).
 :- op(1,   fx,   our). /*

=head2 Flags */

 :- X=(names/2), dynamic(X),discontiguous(X),multifile(X).  
 :- X=(term/3),  dynamic(X),discontiguous(X),multifile(X).  
 :- index(term(1,1,0)). /*

=head1 Body 

=head2 Inside a C<term>  

If I've done this right, this should be the only place where we can find
an explicit referece to C<term/3>. */

 names(meta,[identity,functor,arity,values,fields]).

 term2Meta(This,term(Id,This,Vs),term(Id,meta,[Id,This,Size,Vs,Fs])) :-
        names(This,Fs),
        length(Fs,Size),
        length(Vs,Size).

 in(This,Term, Term) :-
        Term=term(_Id,This,_Values),
	\+ illegal(This,_),
        term2Meta(This,Term,_). /*

=head2 The wrapper */

 wrapper(X,Out) :-
    wrapper(X,Before,[],After,[],Goal),
    append(Before,[{Goal}|After],Temp),
    l2w(Temp,Out).

 wrapper(X,B0,B,A0,A,Y) :- once(wrapper0(X,Z)), wrapper1(Z,B0,B,A0,A,Y).

 wrapper0(X,             leaf(X) ) :- var(X).
 wrapper0(X,             leaf(X) ) :- atomic(X).
 wrapper0([],         leaf(true) ).
 wrapper0([H|T],           [H|T] ).
 wrapper0(the X,           the X ).
 wrapper0(the next X, the next X ).
 wrapper0(X,             term(X) ).

 wrapper1(leaf(X), B,B, A,A, X). 
 wrapper1([H0|T0],B0,B,A0,A,[H|T]):- wrapper(H0,B0,B1,A0,A1,H), wrapper(T0,B1,B,A1,A,T).
 wrapper1(term(X),B0,B, A0,A, Y)  :- X =.. L0, wrapper(L0,B0,B,A0,A,L), Y =.. L.
 wrapper1(the X,[the X=Y|B],B,A,A,Y).
 wrapper1(the next X,B,B,[the X:=Y|A],A,Y).

 l2w([A,B|C],(A with D)) :- l2w([B|C],D).
 l2w([A],A). /*

=head2 Error Handler */

 illegal(T,F) :- 
	aboutTerm(T,GT,PT),
	aboutTerm(F,GF,PF),
	\+ legal(GT,GF,T,F),
	write('% E> '), 
        illegal1('badness in "~w" of "~w"\n',[PF,PT]).

 illegal1(Err,Args) :-
	(source_location(Path,Line),
	file_base_name(Path,File)
        -> format('~w, line ~w: ',[File,Line])
        ;  true),
	format(Err,Args).

 aboutTerm(X,0,(?)) :- var(X).
 aboutTerm(X,1,X) :- nonvar(X).

 legal(0,_,_,_).
 legal(1,0,T,_)     :- names(T,_).
 legal(1,1,T,the F) :- names(T,Fs), member(F,Fs).  /*

=head2 Helper predicates */

 at(X)   :- at(X,_,_).
 at(X,Y) :- at(X,_,Y).

 at(F/V0/V)   --> at(F,V0,V). 
 at(F := V)   --> at(F/_/V).
 at(F=V)      --> at(F/V/V). 
 at(F is N)   --> at(F/_/V),   {V is N}.
 at(F+N)      --> at(F/V0/V),  {V is V0+N}.
 at(+F)       --> at(F/V0/V),  {V is V0+1}.
 at(-F)       --> at(F/V0/V),  {V is V0-1}.
 at(F >= V)   --> at(F/V1/V1), {V1 >= V}.
 at(F >  V)   --> at(F/V1/V1), {V1 >  V}.
 at(F <  V)   --> at(F/V1/V1), {V1 <  V}.
 at(F =< V)   --> at(F/V1/V1), {V1 =< V}.
 at(F \= V)   --> at(F/V1/V1), {V1 \= V}.
 at(`X)       --> {wrapper(X,Y)}, at(Y).
 at(X with Y) --> at(X),at(Y).
 at(X and  Y) --> at(X),at(Y).
 at(X or   Y) --> at(X);at(Y).
 at(not    X) --> \+ at(X).
 at(in     X) --> in(X). 
 at(nl)       --> at({nl}).
 at(nl(X))    --> at({nl(X)}).
 at(true)     --> at({true}).
 at(fail)     --> at({fail}).
 at(print(X)) --> at({print(X)}).
 at(print(X,Y))--> at({print(X,Y)}).
 at(format(X,Y))-->at({format(X,Y)}).
 at(once(X),W0,W) :- once(at(X,W0,W)).
 at(findall(X,Y,Z),W0,W0) :- bagof(X,at(Y,W0,_),Z).
 at(forall(X,Y),W0,W0) :- forall(at(X,W0,W1),at(Y,W1,_)).
 at({X})      --> {X}.    /*

=head2 Worker predicates 

Here's were fields are found/changed. */

 at(our X,Old,New,Term0,Term) :-
        term2Meta(This,Term0,Meta0),
        term2Meta(This,Term, Meta),
        at(the X,Old,New,Meta0,Meta).

 at(the Field,Old,New,term(Id,This,Before),term(Id,This,After)) :-
	\+ illegal(This,the Field),
        names(This,Fields),
	at1(Fields,Field,Old,New,Before,After).

 at1([Field|_],Field,Old,New,[Old|Rest],[New|Rest]).
 at1([_|Fields],Field,Old,New,[H|T0],[H|T1]) :-
	at1(Fields,Field,Old,New,T0,T1).  /*

=head2 Utils */

 add2(T0,T,In,Out) :- T0 =.. L0, append(L0,[In,Out],L), T =.. L.
   
 /*

=head1 Footer

=head2 Start-up */

 term_expansion((X0 means Y),(X :- at(Y,In,Out))) :- namesExpanion, add2(X0,X,In,Out).

 namesExpansion.


