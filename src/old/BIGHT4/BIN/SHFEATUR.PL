%------------------------------------------------------------------------
% some useful feature for ht4 data structures extractors

:- op(1050,fx,av).

av X :- avs(X).

av1(V) :-
        vertexDetails(V,O,Va,C,_,T),
	itOr(noGoods(V,I),  [],I),
	itOr(parents(V,Dad),[],Dad),
	itOr(kids(V,Kids),  [],Kids),
	printl([V-C/T,O=Va,forbids=I,parents= Dad, kids= Kids]).


avs(VS) :- inside(V,VS), av1(V), fail.
avs(_).

vertexDetails(V, Object, Value, Class, _Domain,Type) :-
	v(V,Literal,_AndOr), 
	l(Literal,Object,Value),
	o(_,Object,Class), 
        class(Class,_,_,_,_, Type).

sources :- 
	defEdge(_,X,_,_), 
	(	G = X 
	;	G = (if A then X)
	; 	G = (if A then not X)
	),
	source(_,G), 
	print(G), 
	nl, 
	fail.
sources.

pv :- 	maxV(MaxV),
	between(1,MaxV,V),
	pv(V),
	fail.	
pv.

maxV(MaxV) :- setof(V,Lit^Type^v(V,Lit,Type),All), last(MaxV,All).

pv(V) :- 
	vertexDetails(V,Object,Value,Class,_,_Type),
	class(Class,ShortName,_,_,_,_),
	itOr(parents(V,Ps),Ps,[]),
	itOr(kids(V,Kids),Kids,[]),
	format('~q(~q) ~q = ~q > ~q < ~q~n',
               [V,ShortName,Object,Value,Kids,Ps]).

% if Class and Value bound
vertexDetailsFast(VX, Object,Value, Class, _Domain,Type) :-
	class(Class,_,_,_,_,Type),
	coi(Class,Oid),
	o(Oid,Object,Class),
	oli(Oid,Literal),
	l(Literal,Object,Value),
	lvi(Literal,VX),
	v(VX,Literal,_).
	
value(V,Object, Value) :- 
	v(V,Literal,_AndOr), 
	l(Literal,Object,Value),
	o(_,Object,_Class).

valueFast(VX,Object,Value) :-
	o(Oid,Object,_Class),
	oli(Oid,Literal),
	l(Literal,Object,Value),
	lvi(Literal,VX),
	v(VX,Literal,_).

object2Value(Class,Object,Value,VX) :-
	coi(Class,Oid),
	o(Oid,Object,_Class),
	oli(Oid,Literal),
	l(Literal,Object,Value),
	lvi(Literal,VX),
	v(VX,Literal,_).

neutralValue(O,V) :-
	o(_,O,Class),          
	neutral(Class/Value),
	l(Lid,O,Value),     
	lvi(Lid,V).
positiveValue(O,V) :-
	o(_,O,Class),          
	pos(Class/Value),
	l(Lid,O,Value),     
	lvi(Lid,V).
negativeValue(O,V) :-
	o(_,O,Class),          
	neg(Class/Value),
	l(Lid,O,Value),     
	lvi(Lid,V).
	
posNeg(V,VPos,VNeg) :-
	v(V,Lid1,_),
	l(Lid1,Object,Neu),
        o(Oid,Object,Class),
	class(Class,_,Poss,Neus,Negs,_),
	member(Neu,Neus),
	member(Pos,Poss),
	member(Neg,Negs),
	oli(Oid,Lid2),
	\+ Lid1 = Lid2,
	l(Lid2,Object,Pos),
	oli(Oid,Lid3),
	\+ Lid1 = Lid3,
	l(Lid3,Object,Neg),
	lvi(Lid2,VPos),
	lvi(Lid3,VNeg).

comesFromTheSameObject(V,X) :-
	v(V,Lid1,_),
	l(Lid1,Object,_),
        o(Oid,Object,_),
	oli(Oid,Lid2),
	lvi(Lid2,X).
	
upEdge(Son,Id,Dad,Cost)	:- ebi(Son,Id), e(Id,Dad,Son,Cost,_).
andVertex(V) 		:- v(V,_,and).
orVertex(V) 		:- v(V,_,or).
vertex(V)          	:- v(V,_,_).
contradicts(V1,V2)	:- i(V1,V2).
kid(Me,Child)           :- ei(Me,Id),  e(Id,Me,Child,_,_).
parent(Son,Dad)         :- ebi(Son,Id),e(Id,Dad,Son,_,_).

ins(I)                  :- my_setof(X,in(X), I).
outs(O)                 :- my_setof(X,out(X),O).
fact(F)                 :- facts(All), set_member(F,All).
facts(F)                :- ins(I), outs(O), set_union(I,O,F).
maybes(M)               :- vertices(M).
vertices(V)             :- my_setof(X,Object^AndOr^v(X,Object,AndOr),V).
missables(Missables)    :- my_setof(X,missable(X),Missables).
missable(V)             :- outs(O), set_member(V,O), steadyVertex(V).
steadyVertex(V)         :- v(V,L,_),l(L,_,std).
verticesInEdge(E,V1,V2) :- e(E,V1,V2,_,_).

edges :- edge(_,X), write(X), nl, fail.
edges.

edge(ID,[from(O0=V0),to(O1=V1)]) :-
	e(ID,From0,To0,_Cost,_Source),
	node(From0,About0),
	member(O0=V0,About0),
	node(To0,About1),
	member(O1=V1,About1).
	
examples :- example(_,X), write(X),nl, fail.
examples.

example(V,[in|About]) :- in(V),  node(V,About).
example(V,[out|About]):- out(V), node(V,About).

nodes :- node(_,X), write(X), nl, fail.
nodes.

node(V,[v(V),l(Literal),AndOr,Object = Value,class(Class),type(Type)]) :- 
	v(V,Literal,AndOr), 
	l(Literal,Object,Value),
	o(_,Object,Class), 
        class(Class,_,_,_,_, Type).

pEqual(P1,P2) :-
	ps([x=X,cost=Cost,edges=E,vertices=V,type=Type,roots=Roots],P1),
	ps([x=X,cost=Cost,edges=E,vertices=V,type=Type,roots=Roots],P2).

pset_minus(PS1 - PS2 = Diff) :-
	pset_minus1(PS1,PS2,[],Diff).

pset_minus1([],_,Out,Out).
pset_minus1([P1|PS1],PS2,In,Out) :-
	pset_minus2(PS2,P1,In,Temp),
	pset_minus1(PS1,PS2,Temp,Out).

pset_minus2([],P1,In,[P1|In]).
pset_minus2([P2| _PS2],P1,Out,Out) :- 
	pEqual(P1,P2),!.
pset_minus2([_|PS2],P1,In,Out) :-
	pset_minus2(PS2,P1,In,Out).


data :-
	data(What,Experiments, Obs),
	nl,write('<'),write(What),write('>'),nl,
	N=11,
	stringOfLength(N,S),
	write(S),
	printExperiments(Experiments,N,[],Widths),
	dataObs(Obs,Widths).

printExperiments([],_,In,Out) :-
	nl,
	reverse(In,Out). 

printExperiments([Exp|Exps],Offset0,In,Out) :-
	printExperiment(Exp,Offset0,Offset),
	printExperiments(Exps,Offset,[Offset0|In],Out).

printExperiment([],Offset0,Offset) :- !,
	printExperiment([control],Offset0,Offset).

printExperiment(Exp,Offset0,Offset) :-
	sformat(String,' | ~q',[Exp]),
	string_length(String,L),
	Offset is Offset0 + L,
	write(String).

dataObs(Obs,Widths) :-
	member(X - Ob,Obs),
	sformat(String,'~w',[X]),
	string_length(String,L),
	write(String),write('   '),
	dataOb(Ob,L,Widths),
	nl,
	fail.
dataObs(_,_).

dataOb([],_,_).
dataOb([X|Xs],Offset0,[Width|Widths]) :-
	stringOfLength(Width - Offset0,S),
	Y is X * 1.0,
	sformat(String,'~w~2f',[S,Y]),
	string_length(String,L),
	write(String),
	Offset is L + Offset0,
	dataOb(Xs,Offset,Widths).

describe :-
	nl,
	sources,
	data.



















