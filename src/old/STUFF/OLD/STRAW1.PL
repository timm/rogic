/*

=head1 Rule Syntax

=head2 Keywords */

:- op(999,fx, new).
:- op(998,xfx,are).

:- op(1001,xfx,the),  op(1001,xfx,one), 
   op(1001,xfx,new),  op(1001,xfx,old),
      op(999,fx,fold),
   op(994,fy,change), op(994,fy,create), op(994,fy,cremate),
   op(993,xfy,with),  op(700,xfx,:=). /*

=head1 Meta */

 :- X=(fold)/1, dynamic(X),discontiguous(X). 

 solo(X) :- F='$so_', flag(F,_,0), \+ solo1(F,X), flag(F,1,1).
 solo1(F,X) :- clause(X,_), flag(F,N,N+1), N > 1, !.

 :- Them=('$the'/4,'$one'/4), multifile(Them), discontiguous(Them).
 :- index('$one'(1,1,1,0)).

 makeThe(Class,About, '$the'(Class,Fields,Index,Values)) :-
	makeThe1(About,Fields,Values,Index).

 makeThe1(+F with Fs0, [F|Fs],[V|Vs],[V|L]) :- !, makeThe1(Fs0,Fs,Vs,L).
 makeThe1( F with Fs0, [F|Fs],[_|Vs],   L ) :- !, makeThe1(Fs0,Fs,Vs,L).
 makeThe1(_,[],[],[]).

 fields('$the'(_,Fields,_,_),Fields). 
 defined(Class) :- '$the'(Class,_,_,_).
 
 term_expansion(Class are About,X) :- makeThe(Class,About,X). /*

=head2 Define actions within "withs" */
  
  wme_(F/V0/V,   C) --> {fields(C,Fs), nth0(Pos,Fs,F)}, wme0(Pos,V0,V). 
  wme_(F := V,   C) --> wme_(F/_/V,C).
  wme_(F=V,      C) --> wme_(F/V/V,C). 
  wme_(F+N,      C) --> wme_(F/V0/V,C), {V is V0+N}.
  wme_(F >= V1,  C) --> wme_(F=V,C),    {V >= V1}.
  wme_(F >  V1,  C) --> wme_(F=V,C),    {V >  V1}.
  wme_(F <  V1,  C) --> wme_(F=V,C),    {V <  V1}.
  wme_(F =< V1,  C) --> wme_(F=V,C),    {V =< V1}.
  wme_(F \= V1,  C) --> wme_(F=V,C),    {V \= V1}.
  wme_(X with Y, C) --> wme_(X,  C),    wme_(Y,C).
  wme_(X with Y, C) --> wme_(X,  C),    wme_(Y,C).
  /*

=head2 Get and change a list item */ 

  wme0s(Max) :-
	retractall(wme0(_,_,_,_,_)),
	forall(between(0,Max,N),
	       (length(Pre,N),
	        append(Pre,[X|Post],In),
	        append(Pre,[Y|Post],Out),
	        assert(wme0(N,X,Y,In,Out)))).

 :- wme0s(20).

 noIds :- forall(defined(C),flag(C,_,0)).

 withs(Class=Id with About, '$one'(Class,Id,Index,Values)) :- !,
	
	hash_term(Index0,Index). 

 
 Class with Y :-
	'$the'(Class,Fields,Index0,Values),
	wme_(About,'$the'(Class,Fields,Index0,Values0),
	           Values0,Values).

 goal_expansion( X with Y,Out) :- withs(X with Y, Out).
 goal_expansion(X,Y)           :- fold(X), swap(X,Y).

 swap(X,Y) :- solo(X), clause(X,Y).

 fold(wme_(_,_)).

 employee are +name with age with shoesize.

 aaaaa :-  employee with name>tim with age=alber.

 new employee with name=23 with age=1 with shoesize=2.


 %xpandOne((About one One),one(One,Id,Hash,Fields)) :-
%	c2l(About,List0),
 zzz.
 fold lll :- zzz.

 fold aaa :- bbb,lll.

 c :- aaa,d,e.
	

	 /*
=head1 Syntactic Sugar

Causes cancer of the semi-colon. */

 W=Id with What :-
	access(W,Id,What,_,_).

 create W=Id with X :-
	about(W,Fs,New),
	wme_(X,def(W,Id,Hash,Fs),_,New),
	create0(wme(W,Id,New)).

 change  W=Id with X :- access(W,Id,X,_,New), change0(wme(W,Id,New)).

 cremate W=Id :- cremate0(wme(W,Id,_)).  /*

=head1 Top-level loop */

  reset :- zap, inits. /*

Zap all elements: */

  zap       :-  zap(_).
  zap(W)    :- retract0(wme(W,_,_)), fail.
  zap(_). /*

I<REPORT: why this helper predicate for zap/1 with an unbound arg?>

Show all elements */

  report       :- report(_).
  report(W)    :- report(W,_), fail.
  report(_).
  report(W,Id) :-
	defs(Type),
	def(W,Type,Fields),
	print(W is Type),nl,		      
	match0(wme(W,Id,Values)),
	write('   '),
	print(W=Id),nl,
	nth1(Pos,Fields,Field),
	nth1(Pos,Values,Value),
	write('      '),
	print(Field=Value),nl. /*

I<REPORT: comment out the line C<defs(Type> and see what what happens when you C<thing>. Explain.>

=head1 Working memory 

=head2 Set up */

  

  create class with name=employee
               with fields  = [name, age]
	       with defaults= [noone,0  ]
	       with index   = [name].

  %     name,    fields,       Values,       Id,    Hash
  class(employee,[name,fields],[Name,Fields],[Name],[Name,Fields]).
  wme(employee, Id,[], [Name,Fields]).
  wme(employee,Id,[Name],

  hash(wme(Class,
  create class=employee with fields=[name,age,shoesize].

  wme(emploue

  defined(W) :- def(W,_,_,_). /*

=head2 Primitive wme creation. */

 create0(wme(W,    Vs)) :- a(W,_,Vs,A),  assert(A).
 create0(wme(W,Id, Vs)) :- a(W,Id,Vs,A), assert(A).

 a(W,Id,Vs,A) :- id(W,Id), hash_term(Vs,H), A='#wme'(W,Id,Vs,H).

 id(W,Id) :- var(Id),!, gensym(W,Id).
 id(_,_).

 :- dynamic '#wme'/4.
 :- index('#wme'(1,1,0,1)).  /*

I<REPORT: why not index on the list of values?> 

=head2 Primitive wme deletion. */

 cremate0(wme(W,Id, Vs)) :- hash_term(Vs,H), retract('#wme'(W,Id,Vs,H)). /*

I<TODO: retract should complain if element not found> 

=head2 Primitve wme updating */

 change0(wme(W,Id,New)) :- retract('#wme'(W,Id,_,_)), +wme(W,Id,New). /*

=head2 Primitive wme match */

 match0(wme(W,Id, Vs)) :- hash_term(Vs,H), '#wme'(W,Id,Vs,H). /*

I<REPORT- why dont we use the hash value in the retract call?>

=head2 Get a certain element */

  find(wme(W,Id,Values),Fields) :-
	about(W,Fields,Values),
	match0(wme(W,Id,Values)).

  about(W,Fs,Vs) :- def(W,_Fs), length(Fs,N), length(Vs,N).  /*

  access(W,Id,What,Old,New) :-
	find(wme(W,Id,Old),Fs),
	wme_(What,def(W,Id,Fs),Old,New).

I<LINT: want a complaint if W unknown>

I<LINT: want a complaint if values wrong size>

=head2 Get an element and change its list */

  /*




