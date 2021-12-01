:- + [basic,records, types/v, types/e, types/obj].

output(obj).       output(v).  output(e). 
output(assertion). output(assertionEdge).

term_expansion((X@Y :- Z),Out) :-
	vulcanises((X@Y :- Z),Out).

term_expansion(object(X),Out) :-
	exists(obj,[name(X)],Out).

record(vdat(attr,time,op,value,from,sourceId,
	    assertId,goals,cost,top,subEdgeCost)).

vdat0(conjunct) -->
	vdat0(goals([_,_|_])).
vdat0(subGoal(Attr,Time,Op,Value)) -->
	vdat0(goals(Goals)),
	{member(Attr@Details,Goals),
	 Details =.. [Op,Time,Value]}.
vdat0(add((A@Details :- 
            {W,S,C},Goals))) -->
	 {Details =.. [Op,T,V],
	  c2l(Goals,GoalList)
         },
	 vdat0([attr(A),   time(T), op(Op),    
	        value(V),  cost(C), from(W), sourceId(S), 
		goals(GoalList)
		]).
vdat0(first([HeadV,Assert|Rest]),Dat0,Dat) :-
	 Rules= [attr(_),time(_),op(_),value(_)],
	 vdat0([top(HeadId),sourceId(S),time(T),
               from(Who),assertId(Aid), cost(C),
	       subEdgeCost(SubEdgeCost)
               |Rules], Dat0,Dat),
	 exists(v,[id(HeadVId),kind(or)|Rules],HeadV),
	 exists(assertion, 
                 [id(Aid),number(S),author(Who)],Assert),
	(vdat0(conjunct,Dat) 
        ->   create(v,[and,id(AndId),time(T)], And),
	     create(e,[from(AndId), id(Eid),
                       to(HeadVId),cost(C)], Edge),
             create(assertionEdge,[eid(Eid) ,
                                   aid(AndId)],AE),
	     HeadId=AndId,
	     SubEdgeCost=0,
	     Rest=[And,Edge,AE]
	;    HeadId=HeadVId,
	     SubEdgeCost=1,
             Rest=[]).

vulcanises(In,Out) :-
	create(vdat,[add(In),first(H)],Dat),
	bagof(Some,Dat^vulcanise(Dat,Some),T),
	flatten([H|T],Out).

vulcanise(Dat,[Vertex,Edge,AE]) :-
	 vdat0([top(Top)
	       ,subEdgeCost(Cost) 
	       ,assertId(Aid)
	       ,subGoal(A,T,Op,V) 
               ],Dat),
	 exists(v, [attr(A),time(T),op(Op),value(V),kind(or),id(Vid)],Vertex),
	 create(e, [id(Eid),from(Vid),to(Top),cost(Cost)],Edge),
	 create(assertionEdge,[eid(Eid) ,aid(Aid)],AE).




