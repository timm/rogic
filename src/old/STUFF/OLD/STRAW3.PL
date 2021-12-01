 ensure(X) :- X,!.
 ensure(X) :- assert(X).

 :- dynamic(knownBuiltIn/1).
 knownBuiltIn(true).
 :- forall(predicate_property(X,built_in),
	   ensure(knownBuiltIn(X))).

 myclause(Head,Body) :- \+ knownBuiltIn(Head), clause(Head,Body).

 %eval(X) :- !, fail.
 eval(nth0(A,B,_))   :- ground(A),ground(B).
 eval(nth0(_,B,C))   :- ground(B),ground(C).
 eval(append(A,B,_)) :- nonvar(A),nonvar(B).
 eval(append(_,B,C)) :- nonvar(B),nonvar(C).
 eval(append(_,B,C)) :- nonvar(B),nonvar(C).
 eval(length(L,N))   :- nonvar(L);nonvar(N).
 eval(_ is Y)        :- ground(Y).
 eval(atomic(X))     :- ground(X).
 eval(touch(an A,_,_,D,_)) :- print(an A/D),nl,ground(A), nonvar(D).

 :- op(1200,xfx,[(?-),(?--)]).

 term_expansion((X ?-  Y), Z) :- demand(zip((X:-Y),1,Z)).
 term_expansion((X ?-- Y), Z) :- demand(zip((X:-Y),2,Z)).

 zip(A,B) :- zip(A,1,B).
 zip(A,M,C) :- once(zip0(A,M,B)), zip1(B,M,C).
 
 zip0(A,          _,'_self'(A)) :- var(A).
 zip0((A;B),      _,('_self'(A);  '_do'(B))):- var(A).
 zip0((A;B),      _,(  '_do'(A);'_self'(B))):- var(B).
 zip0((true;B),   _,  '_do'(B)).
 zip0((A;true),   _,  '_do'(A)).
 zip0((A=A),      2,      true).
 zip0((_;_),      2,'_no'('unzip-able disjunct')).
 zip0((X;Y),      _,     (X;Y)).
 zip0(A,          _, '_self'(A)) :- var(A).
 zip0((A,B),   _,  '_do'(B)) :- A == true.
 zip0((A,B),   _,  '_do'(A)) :- B == true.
 zip0((A,B),      _,('_self'(A),'_do'(B))) :- var(A).
 zip0((A,B),      _,('_do'(A),'_self'(B))) :- var(B).
 zip0(((A,B),C),  _   ,(A,B,C)).
 zip0((A,B),      _,     (A,B)).
 zip0((A->B),     _,  (A -> B)).
 zip0(not(A),     _,      \+ A).
 zip0(\+ A,       _,      \+ A).
 zip0((A :- B),   _,     (A:-B)).
 zip0(A,          _,  '_act'(A)) :- eval(A).
 zip0(A,          _, '_self'(A)) :- knownBuiltIn(A).
 zip0(A,          _,   '_do'(B)) :- solo(A),myclause(A,B).
 zip0(A,          _, '_self'(A)).

 zip1(true,       _,  true).
 zip1('_self'(A), _,     A).
 zip1('_act'(A),  _,  true) :- A.
 zip1('_no'(X),   _,  true) :- complain(X).
 zip1('_do'(A0),  M,     A) :- zip(A0,M,A).
 zip1(\+ A0,      M,  \+ A) :- zip(A0,M,A).
 zip1((A0;B0),    M,     R) :- zip(B0,M,B), zip(A0,M,A), (B==true->R=A;R=(A;B)).
 zip1((A :- B),   M,     R) :- zip(B,M,TB), (TB==true->R=A; R=(A:-TB)).
 zip1((A0 -> B0), M,     R) :- zip(A0,M,A), zip(B0,M,B), (A==true-> R=B; R=(A->B)).
 zip1((A0,B0),    M,     R) :- zip(B0,M,B), zip(A0,M,A), (B==true -> R=A; R=(A,B)).
 
 demand(X) :- X,!.
 demand(X) :- complain(failed(X)),fail.

 solo(X) :- F='$so_', flag(F,_,0), \+ solo1(F,X), flag(F,1,1).
 solo1(F,X) :- myclause(X,_), flag(F,N,N+1), N > 1, !.

 complain(X) :-
	source_location(Path, Line),
	file_base_name(Path,File),
	format('%E> ~w at line ~w: ~w\n',[File,Line,X]).

 a1(X) ?- true;true,b,true,v,true; X=1;X=2.
 a2    ?- true;b;true.
 a3(X) ?-- a,b,c,X=1,true.

 :- op(990,xfy,with),  op(700,xfx,:=).


 listItem(N,Old,New,In,Out) :-
	length(Pre,N),
	append(Pre,[Old|Post],In),
	append(Pre,[New|Post],Out).

 % if i've done this right, the only place =the and =one should
 % appear are here
 :- op(399,fx,the). % access slots of a class
 touch(the class,     A0,A,  '=the'(A0,B,C,D,E),'=the'(A,B,C,D,E)).
 touch(the fields,    B0,B,  '=the'(A,B0,C,D,E),'=the'(A,B,C,D,E)).
 touch(the index,     C0,C,  '=the'(A,B,C0,D,E),'=the'(A,B,C,D,E)).
 touch(the values,    D0,D,  '=the'(A,B,C,D0,E),'=the'(A,B,C,D,E)).
 touch(the defaults,  E0,E,  '=the'(A,B,C,D,E0),'=the'(A,B,C,D,E)).

 :- op(399,fx,my).  % access meta slots of an instance	                           
 touch(my id,         A0,A,  '=one'(A0,B,C,D),  '=one'(A,B,C,D)).
 touch(my class,      B0,B,  '=one'(A,B0,C,D),  '=one'(A,B,C,D)).
 touch(my index,      C0,C,  '=one'(A,B,C0,D),  '=one'(A,B,C,D)).
 touch(my values,     D0,D,  '=one'(A,B,C,D0),  '=one'(A,B,C,D)).

 %match class and instances from the global space
 touch(the one, Class,Class,  _,'=the'(Class,B,C,D,E)) :-
	'=the'(Class,B,C,D,E).
 touch(my  one,  Class,Class,  _,'=one'(A,Class,C,Vs  )) :-
	'=the'(Class,_,_,Vs,_), '=one'(A,Class,C,Vs).
 
 :- op(399,fx,our). % join from instance to class
 touch(our X,A0,A,My,My) :- touch(my class=C,My,My),
	                    touch(the one=C with the X/A0/A).

 :- op(399,fx,a).  % access names slots of an instance
 :- op(399,fx,an). % access names slots of an instance
 touch(a A,B,C,One,Two) :-  touch(an A, B,C,One,Two).
 touch(an A,B,C,One,Two) :-
	touch(our fields=Fs with my values/Vs0/Vs with our values=Vs0,One,Two),
	nth0(Pos,Fs,A),
	listItem(Pos,B,C,Vs0,Vs).

 touch(W/X/Y)    --> touch(W,X,Y).
 touch(W=X)      --> touch(W/X/X).
 touch(W:=X)     --> touch(W/_/X).
 touch(W with X) --> touch(W),touch(X).

 touch(X)   :- touch(X,_,_).
 touch(X,M) :- touch(X,_,M).

 the(Class=About, Meta) :-
	the(About,Fs,Vs,Index,Ds),
	touch(the class=Class with the fields=Fs with the index=Index
                         with the values=Vs with the defaults=Ds,
	      Meta).

 the([+F=D|T],[F|Fs],[V|Vs],[V|L],[D|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([+F  |T],[F|Fs],[V|Vs],[V|L],[_|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([F=D |T],[F|Fs],[_|Vs],   L, [D|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([F   |T],[F|Fs],[_|Vs],   L, [_|Ds]) :- !, the(T,Fs,Vs,L,Ds).
 the([],[],[],[],[]).

 term_expansion(Class=About,The) :- the(Class=About,The).

 employee=[+name,age=0,shoeSize].

 '=one'(22,employee,[],[tim,23,12]).
 '=one'(23,employee,[],[jane,24,13]).

 egThe :- listing('=the').
 egOne ?- C=employee,touch(my one=C with a name=N with an age=A),print(C=N/A),nl.
 egTwo ?- touch(my one=employee with a name=N).

%XX failure on missing fields
%arbitrary prolog
%methods
%eg with hash trees