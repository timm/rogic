
%%% Multis/2
%Fast, named, assertions
%<
multis(Stuff,All) :-
	print(no),
	bagof(One,Stuff^multi(Stuff,One),All).

multi((Heads :- Tail),(Head :- Tail)) :-
	d2l(Heads,List),
	member(Head,List).
%>
%%% Labels/3
%Very simple access scheme to terms with names args.
%<
defs(T,Defs) :- print(no),bagof(Def,T^defs1(T,Def),Defs).

defs1(T,(Access :- Get,Sub)) :-
	functor(T,  F,A),
	functor(Get,F,A),
	arg(N,T,Label : Type),
	arg(N,Get,X),
	Label =.. List0,
	append(List0,[X],List),
	Type =.. TypeList0,
	append(TypeList0,[X],TypeList),
	Access =.. List,
	Sub =.. TypeList.
%>
%%% Fields/3
%Poke some values into the named fields.
%<
fields(Fields,Functor,Term) :- print(no),
	fields1(Fields,Functor,Term),!.
fields(_,_,[]).

fields1([],_,_).
fields1([Field|Fields],Functor,Term) :-
	fields2(Field,Functor,Term),
	fields1(Fields,Functor,Term).

fields2(Field,Functor,Term) :-
	clause(Field,(Term,_)),
	functor(Term,Functor,_),!.
fields2(Field,Functor,_) :-
	barph(badField(Functor is [Field])).
%>


%%% LOC per Function points
/* Also loaded, but not shown due to size,
are tables showing producitivity in different 482 different
programming systems.
It tables a {\em lot} of code to get anything done in
binary, but less code as the language matures. So:

\begin{LISTING}
upf2sloc('1st generation default',320).
upf2sloc('2nd generation default',107).
upf2sloc('3rd generation default',80).
upf2sloc('4th generation default',20).
upf2sloc('5th generation default',5).
\end{LISTING}

The units here are lines of code per function point. For more details,
	see Boehm.
*/

