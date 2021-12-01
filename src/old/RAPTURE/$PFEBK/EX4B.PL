% = is find
% := is assignment
% ! is create

%=================================================
% very general

:- op(800,xfx,:=).
:- op(750,xfx,@).

=(Pid@This,What,In,In) :- !,
	member((Pid@This)=What,In).

=(This,What,In,In) :-
	once(member(pid(Pid),In)),
	member((Pid@This)=What,In).

:=(Pid@This,New,In,Out) :- !,
	set(Pid@This,New,In,Out).
	
:=(This,New,In,Out) :-
	once(member(pid(Pid),In)),
	set(Pid@This,New,In,Out).

set(This,New,In,[This=New|Less]) :-
	oneLess(In,This=_,Less),!.
set(This,New,In,[This=New|In]).

oneLess([H|T],H,T).
oneLess([H|T],One,[H|Less]) :- oneLess(T,One,Less).

%=================================================
%moderately general

% are pids recursive?

%another(P0,P1,Wme,Wme) :- % ??
%	member(pid(X),Wme), %?? soemthing about the active pids??%
%	enter(_,
%	P1 \= P0.

term_expansion(type(Proc,bit,X), 
              (type(Proc,X,Y) :- member(Y,[0,1]))).

%=================================================
% specific

pids(main,[main1]).
pids(user,[user1]).

enter(X,Space,Pid,Wme,[pid(Pid)|Wme]) :-
	pids(X,Pids),
	member(Pid0,Pids),
	Pid=[Pid0|Space].


exit(Pid,Wme0,Wme) :-
	append(_,[pid(Pid)|Wme],Wme0).

def(main,bit,flag/_).
def(main,bit,turn).

main(Sp) -->
	enter(main,Sp,Pid),
	flag/0 := 0,
	flag/1 := 0,
	turn   := 0,
	user(Pid),
	exit(Pid).

user(Sp) -->
	enter(user,Sp,Pid),
	flag/Pid  := 1,
	turn    := Pid,
	another(Pid,Pid1),
	(flag/Pid1 =0
         ;turn     =Pid1
	),
	flag/Pid  := 0,
	exit(Pid).

go :-
	X=pid(0),
	main([X],[X],_).




