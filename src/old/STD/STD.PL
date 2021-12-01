%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Std.pl
%% Tim Menzies, 1998
%% 
%% The predicates in this file are listed dumbest to smartest.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% some declarations

:- discontiguous demo/2.

:- op(800,xfx,does), op(800,fx,o). op(800,xfy,and).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% misc low-level stuff

%% demo stuff
demo(X) :- demo(X,_).
demos :- bagof(What,
			Return^Body^
				clause(demo(What,Return),Body),
		Whats),
	 nList(Whats).

%% print stuff
w(X)     :- write(X), flush_output(user).
w(N,X)   :- tab(N), write(X), flush_output(user).

wln(X)   :- write_ln(X).
wln(N,X) :- tab(N), write_ln(X).

%% list stuff

nList(L) :- nList(L,1).
nList([],_).
nList([H|T],N0) :- write_ln(N0=H),N is N0 + 1, nList(T,N).

asList(X,X) :- is_list(X),!.
asList(X,[X]).

%% term stuff

aMember(X,(X,_)).
aMember(Z,(_,Y)) :- !, aMember(Z,Y).
aMember(X,X).

% simple utility for changing some functors in a clause
% L is a list of symbol pairs "old"/"new". Terms with the functor
% "old" become terms with the functor "new".

subF(In,L,Out) :- subF1(In,L,Out),!.

subF1([],_,[]).
subF1([H0|T0],L,[H|T])     :- subF(H0,L,H), subF(T0,L,T).
subF1((A0:-B0),L,(A :- B)) :- subF([A0,B0],L,[A,B]).
subF1((A0,B0), L,(A,B))    :- subF([A0,B0],L,[A,B]).
subF1((A0;B0), L,(A;B))    :- subF([A0,B0],L,[A,B]).
subF1((A0->B0),L,(A->B))   :- subF([A0,B0],L,[A,B]).
subF1(In,L,Out)            :- In  =.. [Old|T], member(Old/New,L), 
                              Out =.. [New|T].
subF1(Out,_,Out).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% buidling accessors into terms

%% macros for auto-generating the accessors
% neat thing about term_expansion is that when the source
% file is reloaded, all the expanded terms are auto-retracted.

:- discontiguous isWme/1, touch/5, new/2, blank/2, wmes1/2, wmes1Zap/2.
:- dynamic isWme/1.

term_expansion(wme(Term),All) :- wmes(Term,All).

wmes(Term0,All) :-
	Term0 =.. [F|Args],
	Term  =.. [F,id=0|Args],
	wmesZap(F),
	bagof(One,Term^(wmes1(Term,One)),All). 

wmesZap(Functor) :- wmes1Zap(Functor,Zapper), Zapper, fail.
wmesZap(_).

wmes1(Term, (:- index(Blank)) ) :-
	functor(Term,F,A),
	functor(Blank,F,A),
	Blank =.. [F|Args],
	indexFirstNArgs(Args,4).
wmes1(Term,(:- dynamic F/A)) :- functor(Term,F,A).
wmes1(Term,(:- multifile F/A)) :- functor(Term,F,A).
wmes1(Term,(:- discontiguous F/A)) :- functor(Term,F,A).
wmes1(Term,(:- discontiguous F/5)) :- 
	functor(Term,F0,_), accessorName(F0,F).

wmes1(Term,isWme(X)) :- 
	functor(Term,F,A), 
	functor(X,F,A).
wmes1Zap(F,retractall(isWme(X))) :-
	isWme(X),
	functor(X,F,_).

wmes1(Term,Out) :-
	Term =.. [S|Args0],
	maplist(secondItem,Args0,Inits),
	New =.. [S|Inits],
	Out =   new(S,New).
wmes1Zap(F,retractall(new(F,_))).

wmes1(Term,Out) :-
	functor(Term,F,A),
	functor(Blank,F,A),
	Out= blank(F,Blank).
wmes1Zap(F,retractall(blank(F,_))).

wmes1(Term,Touch) :-
	Term =.. [S0|Args0],
	accessorName(S0,S),
	maplist(firstItem,Args0,Firsts),
	length(Firsts,Arity),
	functor(Term0,S0,Arity),
	nth1(Pos,Firsts,Arg),
        copyArgs(Term0,Pos,Value0,Value,Term1),
	Touch =.. [S,Arg,Value0,Value,Term0,Term1].
wmes1Zap(F0,retractall(Doomed)) :-
	accessorName(F0,F),
	functor(Doomed,F,5).

wmes1(Term,(Head :- Touch)) :-
	Head=touch(Term1,Arg,Value0,Term2,Value),
	functor(Term,Functor,Arity),
        functor(Term1,Functor,Arity),
  	functor(Term2,Functor,Arity),
        accessorName(Functor,IName),
        Touch =.. [IName,Arg,Value0,Value,Term1,Term2].
wmes1Zap(F,retractall(Doomed)) :-
	Doomed = touch(Term,_,_,_,_), 
	clause(Doomed,_),
	functor(Term,F,_).

% support code for wmes1/2

indexFirstNArgs(Args,N) :-
	indexFirstNArgs(Args,N,1).

indexFirstNArgs([],_,_).
indexFirstNArgs(Args,0,1) :- !,
	indexFirstNArgs(Args,0,0).
indexFirstNArgs([I|T],N0,I) :-
	N is N0 -1,
	indexFirstNArgs(T,N,I).

accessorName(F,N) :- name(F,X),name('0',Y), append(X,Y,Z), name(N,Z).

firstItem(X,Y) :- arg(1,X,Y),!.
firstItem(X,X).

secondItem(X,Y) :- arg(2,X,Y),!.
secondItem(_,_).

copyArgs(T0,Except,Old,New,T) :-
        T0 =.. [Functor|Args0],
        copyArgs1(Args0,1,Except,Old,New,Args),
        T  =.. [Functor|Args].

copyArgs1([],_,_,_,_,[]).
copyArgs1([Old|Args],Pos,Pos,Old,New,[New|Args]) :- !.
copyArgs1([Arg|Args0],Pos0,Except,Old,New,[Arg|Args]) :-
        Pos is Pos0+1, 
        copyArgs1(Args0,Pos,Except,Old,New,Args).


o(X,W) :- o(X,W,_).

o(X and Y, W0,W)      :- !, o(X,W0,W1), o(Y,W1,W).
o([],W, W).
o([H|T],W0,W)         :- o(H,W0,W1), o(T,W1,W).
o(X=Old,W, W)         :- touch(W,X,Old,W,_).
o(X is Old/New, W0,W) :- !, touch(W0,X,Old,W,New).
o(X is New,     W0,W) :- touch(W0,X,_,W,New). 
o(X + M,W0,W)         :- touch(W0,X,Old,W,New), 
    			 New is Old + M.
o(X << Add0,W0,W) :- 
	asList(Add0,Add),
	touch(W0,X,L0,W,L),
	append(Add,L0,L).


pp(X) :-  touch(X,Field,Value,_,_),
	  format('~n~a ~`.t~20| ~a',[Field,Value]),
	  fail.
pp(_).

%% demo of the accessors

wme(demo_o(name,age=0,shoes=[])).

demo(o,Y) :-
	new(demo_o,X),
	o(	[name=tim
		, age+4
		, shoes<<leather
		]
	  	,X
	  	,Y).
	
term_expansion(X does Y=R <-- Z, Out) :- 
	xpandMethod(X,Y,R,Z,Out).
term_expansion(X does Y=R, Out) :- 
	xpandMethod(X,Y,R,true, Out).

xpandMethod(Class,Action,Result,Body,Out) :-
	bagof(One,xpandMethod1(Class,Action,Result,Body,One),Out).

xpandMethod1(Class,Action,Result,Body0,Out) :-
	accessorName(Class,A),
	Head =.. [A,Action,_,Result,T1,T2],
	(Body0=true
	->	Out=Head
	;	odcg(Body0,Body,T1,T2),
		Out=(Head :- Body)
	).

odcg(X       ,X     ,In, In)    :- var(X),!.
odcg((X0->Y0;Z0),New, In,Out)   :- !,( odcg(X0 ,X,In,T),
                                       odcg(Y0,Y,T, Out),
                                       New=(X,!,Y)
                                     ; odcg(Z0,Z,In,Out),
                                       New=Z).
odcg((X0,Y0) ,(X,Y), In,Out) :- !,odcg(X0 ,X,In,T),    odcg(Y0,Y,T, Out).
odcg((X0;Y0) ,X,     In,Out) :- !,(odcg(X0,X,In,Out);  odcg(Y0,X,In,Out)).
odcg((X0|Y0) ,X,     In,Out) :- !,(odcg(X0,X,In,Out);  odcg(Y0,X,In,Out)).
odcg(not X0, not X,  In,In)  :- !,odcg(X0 ,X,In,_).
odcg(o X,o(X,In,Out),In,Out) :- !.
odcg(X  ,X,          In, In).

wme(methodDemo(name,dob,shoeSize)).

methodDemo does init=Id <--
	flag(id,Id,Id+1),
	get_time(Time), 
	convert_time(Time,Y,Mn,D,_,_,_,_),
	o 	id is Id and 
		dob is date(Y,Mn,D) and
		name= who('Menzies','Tim').

demo(method,Ready) :-
	new(methodDemo,New),
	o(init is _,New,Ready).

methodDemo does this(1,2,3)=y.
methodDemo does this(A,1,B)=y <--
        A=B,
        b(a,5,A),
        c,!,
        (d ->
                e,
                o fred + 1,
                o fred > 10,
                o tom = 23
         ;      Z is 1 + 1,
                f(Z,B)
        ),
        not (a(a),
             l(1),
             o z + 1
            ),
         o a + -1 ,
         l(h).


demo(odcg,y) :- clause(methodDemo0(this(_,_,_),B,C,D,E),Body),
		\+ Body=true,
		portray_clause((methodDemo0(this(_,_,_),B,C,D,E) :- Body)),
		fail.
demo(odcg,y).



