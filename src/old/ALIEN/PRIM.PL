+ X :- load_files(X,[silent(true),if(changed)]).

:- +[ops].

commandLineArguments(Args) :-
    unix(argv(Args0)),
    append(_,[--|Args],Args0),
    !.
commandLineArguments([]).

:- multifile defSwitch/2.

switch(X,Y) :- commandLineArguments(Args), switch1(Args,X,Y).

switch1([], Switch,V1)           :- defSwitch(Switch,V), !, V1=V.
switch1([Switch,V|_], Switch,V1) :- !, V1=V.
switch1([_,_|T],      Switch,V)  :- switch1(T,Switch,V).

switches(Goals) :-
	unix(argv(Args0)),
        append(_,[--|Args],Args0),
	switches(Args,['-nothing'/_|Goals]).
	
switches([],[_/[]|_]).
switches([H|T],[Old/[]|Goals0]) :-
	oneLess(Goals0,H/Hs,Goals),!,
	switches(T,[H/Hs,Old/[]|Goals]).
switches([H0|T],[What/[H|Rest]|Goals]) :-
	call(What,H0,H),
	switches1(T,[What/Rest|Goals]).
	
'-nothing'(X,X).

oneLess([X|T],X,T).
oneLess([H|T],X,[H|Rest]) :- oneLess(T,X,Rest).

topLevelGoal :- 
    clause(go,_)
    -> ignore(go), 
       halt
    ;  write('No main program found: halting.'), nl, halt.

eg/X :- 
	(X<10, sformat(String,'eg/00~a',[X])
        ;X<100, sformat(String,'eg/0~a',[X])
        ;sformat(String,'eg/~a',[X])
        ),
	!,
	string_to_atom(String,Atom),
	load_files([Atom],[silent(true)]),
	(clause(go1,_)
        -> go1
        ;  true).









