% code for manipulation libraries of behaviour stored as
% data(expname,    [listofexp1, listofexp2, listofexp3..],
%        value1  - [measure1, measure2, measure3],
%	...
%	]).
% measures may be "-" indicating nil.
% e.g.
%
%data(test,     [[], [a],[b],[a,b]],
%     [height - [23, 100, 15,  75],
%      depth  - [ 0,  10, 60,  10],
%      weight - [ -,  19,  -,  45]
%     ]).

	
b(ExpName,Exp1,Exp2,In,Out) :-
	data(ExpName,Experiments,Measurements),
	actions(Experiments,Actions),
	twoExps(Experiments,Exp1,Exp2),
	exp_deltas(Actions,Exp1,Exp2,[],In),
	measures_deltas(Measurements,Experiments,Exp1,Exp2,[],Out).


actions(Exps,Actions) :-
	setof(Action,Exps^action(Exps,Action),Actions).

action(Exps,Action) :- member(Exp,Exps),member(Action,Exp).

twoExps(Experiments0,Exp1,Exp2) :-
	%reverse(Experiments0,Experiments), % JAN1
	Experiments=Experiments0,           % JAN2
	(model_symmetrical
	->	remove2(Experiments,Exp1,Exp2)
	;	removes([Exp1,Exp2],Experiments)).

model_symmetrical :- \+ asymmetrical_links.

asymmetrical_links :- source(_,X), asymmetrical_links1(X).

asymmetrical_links1(if _ then not Y) :- !,
	defEdge(Edge,Y,_,_), 
	asymmetrical(Edge).

asymmetrical_links1(if _ then Y) :- !,
	defEdge(Edge,Y,_,_),
	asymmetrical(Edge).

asymmetrical_links1(Y) :-
	defEdge(Edge,Y,_,_),
	asymmetrical(Edge).


exp_deltas([],_,_,In,In).
exp_deltas([Action|Actions],Exp1,Exp2,In0,In) :-
	exp_status(Action,Exp1,Status1),
	exp_status(Action,Exp2,Status2),
	exp_delta(Status1,Status2,Current,Delta),
	add_exp_delta([Action=Current,change(Action)=Delta],In0,In1),
%	add_exp_delta([change(Action)=Delta],In0,In1),
	exp_deltas(Actions,Exp1,Exp2,In1,In).

exp_status(Action,Exp,present) :- member(Action,Exp), !.
exp_status(_,_,absent).

exp_delta(present,present,present,std).
exp_delta(present,absent, absent, left).
exp_delta(absent, present,present,arrived).
exp_delta(absent, absent, absent, std).

% steadies are such a pest. since influences can't
% spread out from a steady, we cull them from the ins.

add_exp_delta([],In,In).
add_exp_delta([change(_)=std|Rest],In0,In) :- !,
	add_exp_delta(Rest,In0,In).
add_exp_delta([H|T],In0,In) :-
	add_exp_delta(T,[H|In0],In).

measures_deltas([],_,_,_,Out,Out).
measures_deltas([Object - Values|Rest], Experiments,
                Exp1,Exp2,Out0,Out) :-
	measure_delta(Object,Values,Experiments,Exp1,Exp2,Out0,Out1),
	measures_deltas(Rest,Experiments,Exp1,Exp2,Out1,Out).

measure_delta(Object,Values,Experiments,Exp1,Exp2,Out0,Out) :-
	measurement(Experiments,Exp1,Values,Value1),
	measurement(Experiments,Exp2,Values,Value2),
	once(measure_delta1(Value1,Value2,Object,Out0,Out)).

measurement([Exp|_],Exp, [Value|_],Value).
measurement([_|Exps],Exp,[_|Values],Value) :- 
	measurement(Exps,Exp,Values,Value).

measure_delta1(_,-,_,Out,Out).
measure_delta1(-,_,_,Out,Out).
measure_delta1(V1,V2,Object,Out,[Object = up  |Out]) :- V1 < V2.
measure_delta1(V1,V2,Object,Out,[Object = down|Out]) :- V1 > V2.
measure_delta1(V ,V ,Object,Out,[Object = std |Out]).


% RETURNS BETWEEN 1 AND 4 EVENTS AND 1 TO 10 MEASURES
bRandom(Ins,Outs,Repeats,In,Out) :-
	between(1,Repeats,_),
	randomVertices(	Ins,event,Events),
	randomVertices(Outs,measure,Out),
	addEventChanges(Events,In).

randomVertices(N,Class,Objects) :-
	Count is random(N) + 1,
	bagof(O1=Va1,V1^X^Y^Class^
                     vertexDetailsFast(V1,O1,Va1,Class,X,Y),
             L),
	random_members(L,Count,Objects).

addEventChanges([],[]).
addEventChanges([E=present|Tail],[E=present,change(E)=arrived|Rest]) :-
	addEventChanges(Tail,Rest).
addEventChanges([E=absent|Tail],[E=absent,change(E)=left|Rest]) :-
	addEventChanges(Tail,Rest).




