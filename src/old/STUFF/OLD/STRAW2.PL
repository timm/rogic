%ops

 :- op(991,fx,new).
 :- op(991,xfx,has).
 :- op(990,xfy,with).
 :- op(700,xfx,:=).
 :- op(399,fx,[the,my,our,an,a]).
 :- op(1200,xfx,[(?-),(?--)]).

% flags

 :- dynamic(knownBuiltIn/1).

% hooks

 term_expansion((X ?-  Y), Z) :- demand(zip((X:-Y),1,Z),
	                               'failed optimization').
 term_expansion((X ?-- Y), Z) :- demand(zip((X:-Y),2,Z),
	                               'failed optimization').

% startup stuff

 otherKnownBuiltIns :-
        predicate_property(X,built_in),
	\+ knownBuiltIn(X),
	assert( knownBuiltIn(X)),
	fail.
 otherKnownBuiltIns.

 knownBuiltIn(true).
 knownBuiltIn(fail).
 knownBuiltIn(nl).
 knownBuiltIn(_ \= _).
 knownBuiltIn(hash_term(_,_)).
 knownBuiltIn(print(_)).
 :- otherKnownBuiltIns.

% things we can run at load time

 freeze(A) :- instance(_,A).
 %eval(_) :- !, fail.
 eval(nth0(A,B,_))   :- ground(A),ground(B).
 eval(nth0(_,B,C))   :- ground(B),ground(C).
 eval(append(A,B,_)) :- nonvar(A),nonvar(B).
 eval(append(_,B,C)) :- nonvar(B),nonvar(C).
 eval(append(_,B,C)) :- nonvar(B),nonvar(C).
 eval(length(L,N))   :- nonvar(L);nonvar(N).
 eval(_ is Y)        :- ground(Y).
 eval(atomic(X))     :- ground(X).
 eval(touch(an(A),_,_,D,_)) :- ground(A), nonvar(D).
 eval(demand(X,_)) :- nonvar(X).

% the optimizer

 zip(A,B) :- zip(A,1,B).
 zip(A,M,C) :- once(zip0(A,M,B)), zip1(B,M,C).
 
 zip0(A,          _,'_self'(A)) :- var(A).
 zip0((A;B),      _,('_self'(A);  '_do'(B))):- var(A).
 zip0((A;B),      _,(  '_do'(A);'_self'(B))):- var(B).
 zip0((A;B),      _,  '_do'(B)) :- A == true.
 zip0((A;B),      _,  '_do'(A)) :- B == true.
 zip0((_;_),      2,'_no'('unzip-able disjunct')).
 zip0((X;Y),      _,     (X;Y)).
 zip0((A=A),      2,      true).
 zip0(A,          _, '_self'(A)) :- var(A).
 zip0((A,B),      _,('_self'(A),'_do'(B))) :- var(A).
 zip0((A,B),      _,('_do'(A),'_self'(B))) :- var(B).
 zip0((A,B),      _,  '_do'(B)) :- A == true.
 zip0((A,B),      _,  '_do'(A)) :- B == true.
 zip0((A=A,B),    2,  '_do'(B)).
 zip0((A,B=B),    2,  '_do'(A)).
 zip0(((A,B),C),  _   ,(A,B,C)).
 zip0((A,B),      _,     (A,B)).
 zip0((A->B),     _,  (A -> B)).
 zip0(not(A),     _,      \+ A).
 zip0(\+ A,       _,      \+ A).
 zip0((A :- B),   _,     (A:-B)).
 zip0(A,          _,  '_self'(A)) :- freeze(A).
 zip0(A,          _,  '_act'(A))  :- eval(A).
 zip0(A,          _, '_self'(A))  :- knownBuiltIn(A).
 zip0(A,          _,   '_do'(B))  :- solo(A),myclause(A,B).
 zip0(A,          _, '_self'(A)).

 zip1(true,       _,  true).
 zip1('_self'(A), _,     A).
 zip1('_act'(A),  _,  true) :- A.
 zip1('_no'(X),   _,  true) :- complain(X).
 zip1('_do'(A0),  M,     A) :- zip(A0,M,A).
 zip1(\+ A0,      M,  \+ A) :- zip(A0,M,A).
 zip1((A :- B),   M,     R) :-
	zip(B,M,TB),
	(TB==true->R=A; R=(A:-TB)).
 zip1((A0 -> B0), M,     R) :-
	zip(A0,M,A),
	zip(B0,M,B),
	(A==true -> R=B;  R=(A->B)).
 zip1((A0;B0),    M,     R) :-
	zip(A0,M,A),
	zip(B0,M,B),
	(B==true -> R=A; (A==true -> R=B ;  R=(A;B))).
 zip1((A0,B0),    M,     R) :-
	zip(A0,M,A),
	zip(B0,M,B),
	(B==true -> R=A; (A==true -> R=B ;  R=(A,B))).

% reach out and touch someone

 touch(X) :- touch(X,_,_).

 touch(X,Z) :- touch(X,_,Z).

 touch(W=X,     Z0,Z) :- touch(W/X/X,        Z0, Z).
 touch(W:=X,    Z0,Z) :- touch(W/_/X,        Z0, Z).
 touch(W<<X,    Z0,Z) :- touch(W/Old/[X|Old],Z0, Z).
 touch(W with X,Z0,Z) :- touch(W,            Z0,Z1),
	                 touch(X,            Z1, Z).
 touch(W/X/Y,   Z0,Z) :- touch(W,X,Y,Z0,Z).

% join from instance to class

 touch(our X,A0,A,My,My) :- touch(my class=C,My,My),
	                    touch(the one=C with the X/A0/A).

% access names slots of an instance

 touch(a  A,B,C,One,Two) :-  touch(an A, B,C,One,Two).
 touch(an A,B,C,One,Two) :-
	touch(our fields=Fs with
              my values/Vs0/Vs,One,Two),
	demandKnownField(A,Fs),
	swapItem(Fs,A,B,C,Vs0,Vs).

 touch(self,Old,New,Old,New).
 

% the only place =the and =one should appear are in this next bit
 
% access slots of a class

 touch(the class,     A0,A,  things(A0,B,C,D,E),things(A,B,C,D,E)).
 touch(the fields,    B0,B,  things(A,B0,C,D,E),things(A,B,C,D,E)).
 touch(the index,     C0,C,  things(A,B,C0,D,E),things(A,B,C,D,E)).
 touch(the values,    D0,D,  things(A,B,C,D0,E),things(A,B,C,D,E)).
 touch(the defaults,  E0,E,  things(A,B,C,D,E0),things(A,B,C,D,E)).

% access meta slots of an instance

 touch(my id,         A0,A,  thing(A0,B,C,D),  thing(A,B,C,D)).
 touch(my class,      B0,B,  thing(A,B0,C,D),  thing(A,B,C,D)).
 touch(my index,      C0,C,  thing(A,B,C0,D),  thing(A,B,C,D)).
 touch(my values,     D0,D,  thing(A,B,C,D0),  thing(A,B,C,D)).

%match class and instances from the global space

 touch(the one, Class,Class,  _,things(Class,B,C,D,E)) :-
	demandKnown(Class),
	things(Class,B,C,D,E).
 touch(my  one,  Class,Class,  _,thing(A,Class,C,Vs  )) :-
	demandKnown(Class),
	things(Class,_,_,Vs,_),
	thing(A,Class,C,Vs).

 class(Class,things(Class, _,_,_,_)).
 instance(Class=Id,thing(Id,Class,_,_)).

 known(Class) :- var(Class).
 known(Class) :- nonvar(Class), things(Class,_,_,_,_).

 knownField(F,Fs) :- var(F);var(Fs).
 knownField(F,Fs) :- nonvar(F), nonvar(Fs), member(F,Fs).
 :- index(thing(1,1,1,0)).
 :- dynamic thing/4, things/5.

%%%% no more references to =the and =one!

demandKnown(Class) :-
	demand(known(Class),
	       'unknown things'(Class)).
 demandKnownField(F,Fs) :-
	demand(knownField(F,Fs),
	       'unknown field'(F)).

 portray(X) :- class(About,X),write(About).
 portray(X) :- instance(About,X), write(About).

 zapInstances :-
	flag(id,_,0), instance(_,X), retract(X), fail.
 zapInstances.

 zapClasses   :- class(_,X), retract(X), fail.
 zapClasses.

 reset :- zapInstances, zapClasses.

% class creation (can't be optimized cause there may be no "=the" yet

 the0(Class=About, Meta) :-
	the(About,Fs,Vs,Index,Ds),
	touch(the class=Class with the fields=Fs
                              with the index=Index
                              with the values=Vs
			      with the defaults=Ds,
	      Meta).

 Class has About :- the0(Class=About,The0), assert(The0).

 the([+F=D|T],[F|Fs],[V|Vs],[V|L],[D|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([+F  |T],[F|Fs],[V|Vs],[V|L],[_|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([F=D |T],[F|Fs],[_|Vs],   L, [D|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([F   |T],[F|Fs],[_|Vs],   L, [_|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([],[],[],[],[]).

% misc utils

 swapItem([F|_], F,Old,New,[Old |Rest],[New |Rest]).
 swapItem([_|Fs],F,Old,New,[Skip|L0],  [Skip|L   ]) :-
	swapItem(Fs,F,Old,New,L0,L).
	
 runtime(N,G,T) :-
	T1 is cputime,
	repeats(N,G),
	T2 is cputime,
	repeats(N,true),
	T3 is cputime,
	T is ((T2-T1) -(T3-T2)).

 repeats(N,G) :- between(1,N,_),once(G),fail.
 repeats(_,_).

 myclause(Head,Body) :-
	\+ knownBuiltIn(Head), clause(Head,Body).

 
 ensure(X) :- X,!.
 ensure(X) :- assert(X).

 demand(X,_) :- X,!.
 demand(_,Y) :- complain(Y),fail.

 solo(X)    :- F='$so_', flag(F,_,0), \+ solo1(F,X), flag(F,1,1).
 solo1(F,X) :- myclause(X,_), flag(F,N,N+1), N > 1, !.

 complain(X) :-
	source_location(Path, Line),
	file_base_name(Path,File),
	format('%E> ~w at line ~w: ~w\n',[File,Line,X]).
 
 

% begin optimzed code

% instance creation, no assertion

 fresh0(Class,Out) ?-
	touch(my class=Class
                with our defaults=D
                with my values := D,
	      Out).

 fresh(Class with Fields,Out) ?-
	fresh0(Class,Temp),
	touch(self := Temp with Fields,Out).

% instance creation, with assertion

 new0(Class with Fields,Out) ?-
	fresh(Class with Fields,Temp),
	touch(self := Temp with my  values=Vs
		           with my  index:=Hash
		           with my  id:=Id,
	      Out),	
        touch(the one=Class with the values=Vs
		            with the index=Index),
	hash_term(Index,Hash),
	flag(id,Id,Id+1).

%XXX need a deletion

 new(X) ?- new0(X,Y), assert(Y).

 X with Y :- touch(X with Y).

% knowledge base

 a1(X) ?- true;true,b,true,v,true; X=1;X=2.
 a2    ?- true;b;true.
 a3(X) ?-- a,b,c,X=1,true.

 :- reset.

 :- employee has [+name,age=0,shoeSize].

 :- new employee
     with a name:=tim  with an age:=23 with a shoeSize:=12.

 :- new employee
     with a name:=jane with an age:=24 with a shoeSize:=13. 

 egThe :- listing(things).
 egOne :- listing(thing).

 egFresh :- listing(fresh).

 eg1 ?--
	C=employee,
	touch(my one=C with a name=N with an age=A),
	print(C=N/A),nl.
 eg2 :-
	C=employee,
	touch(my one=C with a name=Name with an age=Age),
	Name \= Age.
 eg3 ?-
	C=employee,
	touch(my one=C with a name=Name with an age=Age),
	Name \= Age.
 eg4 ?--
	C=employee,
	touch(my one=C with a name=Name with an age=Age),
	Name \= Age.
 eg5 :-
	R=100000,
	runtime(R,eg2,T1),
	runtime(R,eg3,T2),
	runtime(R,eg4,T3),
	Com1 is T2/T1*100,
	Com2 is T3/T1*100,
        format('t1=~p (=100%)\nt2=~p (=~1f%)\nt3=~p (=~1f%)\n',
	        [T1,T2,Com1,T3,Com2]).

 eg6 ?-
	touch(my one=employee with a names=Name with an ages=Age),
	Name \= Age.

 eg7 ?- touch(my one=employee with a F=V),
	print(F=V),nl,fail.
 eg7.
 

%arbitrary prolog
%methods
%eg with hash trees