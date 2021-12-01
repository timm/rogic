%
:- style_check(-atom), style_check(+string).

copyLeft("
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.
").

:- dynamic control/1.
:- discontiguous com/2.
:- discontiguous com/3.

con(X=Y) :- !, retractall(control(X=_)), assert(control(X=Y)).
con(X)   :- control(X),!. 
con(X)   :- assert(control(X)).


defaults(['-n1'=8,
	  '-n2'=4,
          %'-re'=t,
	  %'-oc'=t,
	  %'-opor'=t,
	  %'-onth'=t,
	  %'-on1'=t,
	  %'-on2'=t,
          '-ob'=t,
	  '-oab'=t
          ]).

com(X) :- com(X,_).

com('-a','        show (brief) about text') :-
	write('HT0 v0.1- a fast (maybe) single world abductive inference engine'),nl,
	write('Copyright (C) 1999 tim@menzies.com'),nl.
com('-A','        show full about text') :-
	com('-a'),
	copyLeft(X),write(X).
com('-c','        show control settings') :-
	forall( control(X),
	        (X = (A=B)
                 -> say([A,B])
                 ;  say([X,t]))).
com('-d','        use default settings (always called at start-up)') :-
	defaults(D),
	forall(member(X=Y,D),(Y=t -> com(X) ; com(X,Y,_))).

com('-d?','       show default settings') :- 
	defaults(D),
        forall(member(X=Y,D),say([X,Y])).

com('-?','        show help') :- 	
	setof(Switch-Text,
	        Goal^Arg^Body^
                          (member(Goal,
                            [com(Switch,Text)
                            ,com(Switch,Arg,Text)
                            ]),
		            clause(Goal,Body)
                          ),
		 All),
	com('-a'),nl, 
        write('When called with no parameters, ht0 tries to run the previous command.'),
        nl,nl,
	forall(member(Switch-Text,All),
	   format(' ~w~w~n',[Switch,Text])),
        halt.

com('-i','        interactive mode') :-
	prolog.
com('-l',X, '   X    load theory X, without validating (best used with -i)') :-
	tload(X).
com('-n1',N,'  N    run outer loop N times') :-
	con(repeats1=N).	
com('-n2',N,'  N    run inner loop N timess') :-
	con(repeats2=N).	
com('-q','        quit') :- halt.
com('-oa','       output the assumptions made in each run') :-
	con(showGuesses).
com('-oab','      output the average best cover') :-
	con(show(averageCover)).
com('-ob','       output the best cover') :-
	con(show(best)).
com('-oc','       output the run\'s cover') :-
	con(showCover).
com('-oe','       output everything') :-
	maplist(com,['-oc','-ot','-of','-og','-oi'
                    ,'-os','-oa','-op','-onth', '-on1', '-on2'],_).
com('-of','       output facts') :- con(show(facts)).
com('-og','       output goals') :- con(show(goals)).
com('-oi','       output inputs') :- con(show(inputs)).
com('-on1','      output n1') :- con(show(r1)).
com('-on2','      output n2') :- con(show(r2)).
com('-onth','     output goal number') :- con(show(nth)).
com('-op','       output proofs') :-
	con(showPaths).
com('-opor','     portray value assignments succinctly') :-
	con(show(succinct)).
com('-os','       output runtime (in secs)') :-
	con(showRunTime).
com('-ot','       output theory name') :-
	con(show(theory)).
com('-re','       randomise everything') :-
	com('-rc'),
	com('-rg'),
	com('-rs').
com('-rc','       randomise order of clause lists') :-
	con(swapClauses).
com('-rg','       randomise order of goals') :-
	con(swapGoals).
com('-rs','       randomise order of sub-goals') :-
	con(swapSubGoals).
com('-t',X, '   X    validate theory X') :-
	t/X.
com('-tr',X, '  F/A  trace functor F with arity A') :-
	atom_to_term(X,Y,[]),
	(Y = F/A -> trace(F/A); trace(Y)).
com('-sp',X, 
    '  F/A  spy on functor F with arity A') :-
	atom_to_term(X,Y,[]),
	(Y = F/A -> spy(F/A); spy(Y)).

:- com('-d').

gos :-  Start is cputime,
	bagof(One,A^B^Out^(go(A,B,Out),
                     print(A),nl,
                     member(One,Out)),L),
%	flatten(L0,L),
	av(L,Cover),
	showX(averageCover=Cover),
	showRunTime(Start).

cc(P-_/_,P).

nll :- forall(control(show(nth)),nl).

say([X,list([H|T])]) :- !,
	writef('%20R : %p\n',[X,H]),
        forall(member(Item,T),say([+,Item])).
say(X) :- writef('%20R : %p\n',X).

t/N :- tload(N), gos.

tload(N) :-
	tname(N,T),
	must(exists_file(T)),
	load_files([T],[silent(true)]),
	showX(theory=T).

tname(X,Y) :- X < 10,!,asString('t00~p.pl',[X],Y).
tname(X,Y) :- X < 100,!,asString('t0~p.pl',[X],Y).
tname(X,Y) :- X < 1000,!,asString('t~p.pl',[X],Y).

showRunTime(Start) :-
	control(showRunTime)
        ->  Now is cputime,
	    N is Now-Start,
	    say([totalRunTime,N])
        ;   true.

asString(Spec,Args,String) :-
	sformat(String0,Spec,Args),
	string_to_atom(String0,String).

bins([Num|Nums],Bins) :- 
	bins(Nums,[Num-1],Bins).

bins([],B,B).
bins([H|T],[H-N0|Rest],Bin) :- !,
	N is N0 + 1,
	bins(T,[H-N|Rest],Bin).
bins([H|T],Rest,Bin) :- 
	bins(T,[H-1|Rest],Bin).

hist(Bins) :- hist(Bins,5,4).
hist(Bins,Width1,Width2) :-
	member(Thing-N1,Bins),
	name(Thing,L),
	length(L,N2),
	stringOfLength(Width1-N2,S1),
	stringOfLength(N1,'*',S2),
	name(N1,L1),
	length(L1,N2),
	stringOfLength(Width2-N2,S3),
	format('~w~w | ~w~w | ~w~n',[S1,Thing,N1,S3,S2]), 
	fail.
hist(_,_,_).

dist(X) :- 
	msort(X,Y), 
	bins(Y,B0), 
	msort(B0,B), 
	forall(member(M-N,B),
	       (write(M-N),nl)).
	
stringOfLength(L,S) :-
	stringOfLength(L,' ',S).

stringOfLength(L0,Char,Out) :-
	L is L0,
	(L > 0
	-> 	length(Temp,L),
		name(Char,[Value]),
		stringOfLength1(Temp,Value),
		name(Out,Temp)
	| 	Out = '').

stringOfLength1([],_).
stringOfLength1([Char|Rest],Char) :-
	stringOfLength1(Rest,Char).






