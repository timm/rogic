magic(96). % `  

:- Stuff=(data/2),
   (dynamic Stuff),
   (discontiguous Stuff).

main(In,Out) :-
	see(In),
	tell(Out),
	xString,
	seen,
	told.

xString :-
	get0(A), 
	xString(A).

xString(-1) :- !.
xString(X)  :- 
	magic(X),!, 
	evalTerm(X),
	xString.
xString(X)  :- 
	put(X), 
	xString.

println(X) :- print(X),nl.

else(X,_) :- X,!.
else(_,Y) :- Y,fail.

evalTerm(X) :-
	upTo(X,What),
	else(atom_to_term(What,Term,_),
             println(readFailure(What))),
	else((println(do(Term)),
              eval(Term)),
             println(executeFailure(Term))).
	
upTo(X,What) :-
	get0(Y),
	upTo(Y,X,What).
upTo(-1,_,[]) :- !.
upTo(X,X,[]) :- !.
upTo(X,Stop,[X|T]) :- upTo(Stop,T).


eval((X,Y)) :- !, eval(X), eval(Y).
eval(f X) :- f(X,Y),print(Y).
eval(X) :-
	X =.. L0,
	append(L0,[Out],L),
	Goal =.. L,
	Goal,
	write(Out).

a(X,a(b(c(X)))).

:- op(800,fx,f).
f X=Y0 :- f(Y0,Y), f(X,Y), !.
f X=_  :- print(user_error,failed(X)),fail.

f(X,X)           :- var(X),!.
f(X*Y*Z,Out)     :- !, f(Y*Z,Temp), f(X*Temp,Out).
f(append(P)*X,Y) :- !,	s('~a~a',[X,P],Y).
f(get*X,Y)       :- !, data(X,Z),!,Y=Z.
f(gif*X,Y)       :- !, f(append('.gif')*image*X,Y).
f(image*X,Y)     :- !, val(images,V), f(prepend(V)*X,Y).
f(jpg*X,Y)       :- !, f(append('.jpg')*image*X,Y).
f(o*X,X)         :- !,	print(X).
f(prepend(P)*X,Y):- !,	s('~a~a',[P,X],Y).
f(put*X,Y)       :- !, ensure(data(X,Y)).
f(X,X).

ensure(X) :- X,!.
ensure(X) :- assert(X).

s(Spec,Args,String) :-
	sformat(String0,Spec,Args),
	string_to_atom(String0,String).

val(X,dasdsa).



