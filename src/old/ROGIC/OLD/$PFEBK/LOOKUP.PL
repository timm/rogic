% timm's list cheat
% tim@menzies.com
% 
% after some experimentation, i found that in swi prolog 
% at least, searching and replacing items in lists up to
% 100 items long is at least as slow as asserts or member or
% trees and stuff.
% 
% so,  my working memory is a set of N lists stored in a 
% term of arity N. we hash on the key to generate an arg number
% then pull that arg number from the term.

% i.e., i divide my working memory N ways
% and pray my hashing function distributes things evenly amongst
% the N items. if N=64, then i should be able to get in/ get out
% 6400 items real at a speed at least as fast as asserts. and i
% win with other things; e.g. memory updates are now backtracable.

%% config stuff
% number of lists in working memory.
wmeLists(256).

setArgsEnabled :- % should fail is this prolog does not support
	true.     % a backtrackable setarg

%% runtime support
% high level driver: 
% get(+Key,?Old, ?New,+Wme0,?Wme)
% Key  - key
% Wme0 - old working memory
% Wme  - new working memory
% Old  - the current list of values stored at Key in Wme0
% New  - the new list of values stored at Key in Wme
get(Key,V,In,Out) :-
	hash_term(Key,Hash),
	wmeKey(Hash,Lookup), 
	wme(Lookup,OldL,OldL,In,Out),
	member(Key=V0,OldL),!,
	V0=V.

ensurew(Key,V,In,Out) :-
	hash_term(Key,Hash),
	wmeKey(Hash,Lookup), 
	wme(Lookup,OldL,NewL,In,Out),
	swapOut(OldL,Key,V,NewL).

swapOut([],Key,New,[Key=New]).
swapOut([Key=_|Rest],Key,New,[Key=New|Rest]) :- !.
swapOut([H|T],Key,New,[H|Rest]) :-
	swapOut(T,Key,New,Rest).

%% compile-time stuff
% you should be able to ignore everything from here down
defWme(N,F,wme0(new,Wme)) :-
	length(L0,N),
	maplist(empty,L0,L),
	Wme =.. [F|L].
defWme(N,F,[wme0(blank,Wme),
          (portray(Wme) :- 
                write('#WME'/N))]):-
	length(L0,N),
	Wme =.. [F|L0].
defWme(N,_,(wmeKey(In,Out) :- 
                Out is (In mod N) + 1)).
defWme(_,_,(wme(I,Old,New,T1,T1) :- 
	        arg(I,T1,Old),
                setarg(I,T1,New))) :-
	setArgsEnabled.
defWme(Size,F,wme(I,Old,New,T1,T2)) :-
	\+setArgsEnabled,
	between(1,Size,I),
	functor(T1,F,Size),
	functor(T2,F,Size),
	joinArgs(I,Old,New,T1,T2).

empty([],[]). 

joinArgs(N,Old,New,T1,T2) :-
	T1 =.. [_|L0],
	T2 =.. [_|L],
	joinArgs(1,N,L0,Old,New,L).
joinArgs(N,N,[Old|Rest],Old,New,[New|Rest]).
joinArgs(N0,N1,[X|L0],Old,New,[X|L]) :- 
	N0 < N1, N2 is N0 + 1,
	joinArgs(N2,N1,L0,Old,New,L).

term_expansion(wmeMake,L) :-
	wmeLists(N),
	findall(One,defWme(N,w,One),L).

% this must be last in the file.
wmeMake.
	

testit :-
	retractall(val(_,_)),
	length(L0,10000),
	maplist(testitinit,L0,L),
	time(forall(member(X,L),ignore(do(X)))),
	time(tests0(L)),
	time(tests(L)).

tests0(L) :- wme0(new,W0), tests0(L,W0,_).

tests0([],X,X).
tests0([H|T],X,Z) :- tests01(H,X,Y), tests0(T,Y,Z).

tests01(_,_,_).

tests(L) :- wme0(new,W0), tests(L,W0,_).

tests([],X,X).
tests([H|T],X,Z) :- tests1(H,X,Y), tests(T,Y,Z).

tests1(ensure(val(X,Y)),W0,W) :- ensurew(X,Y,W0,W),!.
tests1(find(val(X,Y)),W0,W)   :- (get(X,Y,W0,W); W0=W),!.
tests1(X,W,W) :- print(hih(X)),nl.

:- dynamic val/2.

do(ensure(val(X,Y))) :- val(X,Y),!.
do(ensure(val(X,Y))) :- assert(val(X,Y)).

do(find(val(X,Y))) :- val(X,Y).

testitinit(_,ToDo) :- L=[0=ensure(val(This,That))
                    ,1=ensure(val(This,That))
                    ,2=  find(val(This,That))
                    ,3=  find(val(This,That))
                    ,4=  find(val(This,That))
                    ,5=  find(val(This,That))
                    ,6=  find(val(This,That))
                    ,7=  find(val(This,That))
                    ,8=  find(val(This,That))
                    ,9=  find(val(This,That))
                    ],
	          That is random(20),
                  X is random(200), 
                  string_concat(a,X,String),
		  string_to_atom(String,This),
                  Y is random(10),
		  member(Y=ToDo,L).

	          





