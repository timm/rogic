% this should be the only place where
% the internal of thing and things are
% manipulated

 class(Class,      things(Class, _,_,_,_)).
 instance(Class=Id,thing(Id,Class,_,_)).

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

% demand that certain things
% work

 demandKnown(Class) :-
	demand(known(Class),
	       'unknown things'(Class)).
 demandKnownField(F,Fs) :-
	demand(knownField(F,Fs),
	       'unknown field'(F)).

 known(Class) :- var(Class).
 known(Class) :- nonvar(Class), things(Class,_,_,_,_).

 knownField(F,Fs) :- var(F);var(Fs).
 knownField(F,Fs) :- nonvar(F), nonvar(Fs), member(F,Fs).
