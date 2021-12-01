
=for html
<em>(Available in  <a href="defs.pdf">pdf</a>,
        <a href="defs_4printer.html">printer-friendly</a> format,
        <a href="defs.html">display-friendly</a> format,
        <a href="defs.txt">plain text</a>, or
         text with <a href="defs.man">bold escape characters</a>.
        )</em>

/*

=for latex \input{aa}

=head1 Accessor

Been at this one for years.

=head1 Header

=head2 Operators */

 :- op(800, xfy, with).
 :- op(700, xfx,  :=).
 :- op(1,   fx,  in).
 :- op(1,   fx,  the).
 :- op(1,   fx,  our). /*

=head2 Flags */

 :- dynamic       def/2.
 :- discontiguous def/2.
 :- multifile     def/2.  /*

=head2 Hacks */

  /*

=head1 Body 

=head2 Interpreter */

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
 at(X with Y) --> at(X),at(Y).
 at(in X) --> in(X). 

 at(F,_,_,This=_,_) :-
    \+ def(This,_),
    
 at(our fields,_,Fields,This=In,This=In) :- def(This,Fields).
 at(the Field,Old,New,This=In,This=Out) :-
    def(This,Fields),
    at1(Fields,Field,Old,New,In,Out).

 at1([Field|_],Field,Old,New,[Old|Rest],[New|Rest]).
 at1([_|Fields],Field,Old,New,[H|T0],[H|T1]) :-
    at1(Fields,Field,Old,New,T0,T1). 

 in(This,This=L,This=L) :- 
    def(This,Fs), length(Fs,N), length(L,N). /*

=head2 Optimizer */

 goal_expansion(at(our F,Old,New,Def=In,Def=Out),true) :- 
	ground((Def,F)), 
	known(our Def,F),
        at(our F,Old,New,Def=In,Def=Out).
 goal_expansion(at(the F,Old,New,Def=In,Def=Out),true) :- 
	ground((Def,F)), 
	known(Def,the F),
	at(the F,Old,New,Def=In,Def=Out).
 goal_expansion(in(Def,In,Out),true) :- 
	ground(Def), 
	known(Def),
	in(Def,In,Out). 
 goal_expansion(at(X),Y) :- 
	clause(X,Y).
 goal_expansion(at(X,Y),Z) :- 
	clause(at(X,Y),Z). 
 goal_expansion(at(F/V0/V,Def=In,Def=Out),true) :- 
	ground((Def,F)), 
	known(Def,F),
        at(F,V0,V,Def=In,Def=Out).
 goal_expansion(at(X with Y,In,Out),true):- 
	nonvar(X), 
	nonvar(Y),
	at(X with Y,In,Out).
 goal_expansion(at(A,B,C),true) :- 
	solo(at(A,B,C)),
	at(A,B,C).

 solo(X) :- Y='#solo', flag(Y,_,0), \+ solo1(Y,X), flag(Y,1,1).
 solo1(Sym,X) :- clause(X,_),flag(Sym,N,N+1),N > 1,!.  /*

=head2 Optimizer Error Handler */

 known(Def) :- 
	def(Def,_) -> true; unknown(['unknown [~w]',Def]).

 known(Def,our fields) :-
	 known(Def) -> true; unknown(['[~w] unknown in [~w]\n',Def]).

 known(Def,the F) :- 
	known(Def),
        (def(Def,Fs), member(F,Fs)
        -> true
        ;  unknown(['[~w] unknown in [~w]',F,Def])). /*

=head2 Support code */

 unknown([Head|Tail]) :-
	format('%W>'),
        uknownWhere,
	format(Head,Tail),nl,
        fail. /*

 unknownWhere :-
    source_location(Path,Line),
    file_base_name(Path,File)
    -> format('at line ~w of ~w: ',[Line,File])
    ;  true.

=head1 Footer 

This stuff must come after the above definitions of C<at/3> and 
C<at/5>.*/

 goal_expansion(X is Y,true) :- ground(Y), X is Y.
 goal_expansion(true(X,X),true).
 goal_expansion(fail(X,X),true).
 goal_expansion(print(X,Y,Y), print(X)).
 goal_expansion(format(X,Y,Z,Z),format(X,Y)).
 goal_expansion( -(F,X,Y),  Z) :- clause(at(-F,    X,Y),Z).
 goal_expansion( +(F,X,Y),  Z) :- clause(at(+F,    X,Y),Z).
 goal_expansion( +(F,V,X,Y),Z) :- clause(at(F+V,   X,Y),Z).
 goal_expansion( =(F,V,X,Y),Z) :- clause(at(F =  V,X,Y),Z).
 goal_expansion(is(F,V,X,Y),Z) :- clause(at(F is V,X,Y),Z).
 goal_expansion(>=(F,V,X,Y),Z) :- clause(at(F >= V,X,Y),Z).
 goal_expansion( >(F,V,X,Y),Z) :- clause(at(F >  V,X,Y),Z).
 goal_expansion( <(F,V,X,Y),Z) :- clause(at(F <  V,X,Y),Z).
 goal_expansion(=<(F,V,X,Y),Z) :- clause(at(F =< V,X,Y),Z).
 goal_expansion(\=(F,V,X,Y),Z) :- clause(at(F \= V,X,Y),Z).
 goal_expansion(:=(F,V,X,Y),Z) :- clause(at(F:=V,  X,Y),Z).
