/*

=head1 Knowledge Base

A theory is a set of:

=over 8

=item Machines

Devices with (a) a finite set of mutually exclusive states;
	(b) an intial state; and transition functions
    represented as horn functions.

=item Horn Functions

I<Horn functions>; i.e. a horn clause whose head's divides into a
C<key> and a C<value>.  The C<key> is machine name and the C<value> is
a machine state. 
Horn function bodies can call arbitrary
side-effect-free horn clauses.  A horn function need not be not
ground, but when it is proved, the head becomes ground.

=item Pure Prolog Clauses

Side-effect free Prolog clauses.

=back

=head1 Set-up

=head2 Options */

 options_(20    % collisions
         ,20    % depth
         ,20    % repeats
         ,65536 % hash table size (power of two)
         ). /* 

=head2 Operators */

 :- op(1200, fy, machine).
 :- op(1001, fx, fun). /*

=head2 Flags */

 :- dynamic global_/2,globals_/1.
 :- discontiguous  machine_/5.
 :- index(machine_(1,1,0,0,0)).
 :- flag(id,_,0).  /*

=head2 Hooks */

 term_expansion(machine M=S,X)        :- defMachine_(M,S,X).
 term_expansion((fun Head :- Body),X) :- defFunction_(Head,Body,X).

/*

=head1 Parser */

 defMachine_(M,S0,[machine_(T,M,1,S0,S)
                  ,(:- dynamic(M/1))
	          ,(:-discontiguous(M/1))]) :- T=..[M,S].

 defFunction_(H,B,L) :- flag(id,N,N+1),c2l_(H,L0),maplist(c_(N,B),L0,L).
 c_(N,B,H,(H :- use_(N),B)). /*

=head2 Rest, Run, Report */

 go_         :- globalReset, run_, report_ .
 globalReset :- retractall(globals_(_)), retractall(global_(_,_)).
 reset_(L)   :- all_(T,(machine_(T,_,_,_,_),retract(T)), L).
 report_     :- forall((machine_(T,_,_,_,_),clause(T,true)),(print(T),nl)).
 run_        :- tchain_. /*


=head2 Match select act */

 match_(L)   :- all_(T,(machine_(T,_,_,_,_),T),L). /*

Given multiple assignments to a machine, pick one at random (which,
	thanks to match_/1, is the first one). */

 select_([],[]).
 select_([N/M/S,_/M/_|T],Out) :- !,select_([N/M/S|T],Out).
 select_([H|T0],[H|T]) :- select_(T0,T). /*

Assert all matched terms that don't contradict existing term. */

 act_(L) :-
	member(T,L),
	machine_(T,F,_,_,_),
	machine_(T1,F,_,_,_),
	clause(T1,true),
	assert(T),
	fail.
 act_(_). /*

=head2 Temporal forward chaining */

 tchain_ :- options_(Collides,Depth,Repeats,_),
	    firsts_(L),
	    tchain_(Collides,Depth,Repeats,L).

 tchain_(0,  _, _, _) :- !.
 tchain_(_,  0, _, _) :- !.
 tchain_(_,  _, 0, _) :- !.
 tchain_(C0,D0,R0,B4) :-
	reset_(Past0),
	collisions_(D0,Past0,R0,R,C0,C),
	D is D0 - 1,
	act_(B4),
	match_(New0), select_(New0,New), act_(New),
	select_(Past0,Past), act_(Past),
	match_(Next),
	tchain_(C,D,R,Next). /*

=head2 Loop detection */

 collisions_(N,State,R0,R,C0,C) :-
        hash_(State,H),
        (global_(H,_) -> C is C0 - 1; C=C0),
	(globals_(H)  -> R is R0 - 1; R=R0,assert(globals_(H))),
	assert(global_(H,N)).

 hash_(State,H) :- options_(_,_,_,HS), hash_term(State,H0), H is H0 mod HS. /*

=head2 Utilities 

Return solutions to a C<Goal> in a random order. */

 all_(One,Goal,L) :- setof(N/One,Goal^(Goal,N is random(2147483647)),L),!.
 all_(_,_,[]).

 c2l_((A,B),[A|C]) :- !,c2l_(B,C).
 c2l_(A,[A]).

 firsts_(L) :- all_(T,first_(T),L).
 first_(T)  :- machine_(T,_,_,V,V). /*

Trivial implementation of the C<use/1> predicate: */

 use_(_).
