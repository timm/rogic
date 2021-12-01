% read prolog facts in old-style HT4 prolog format and write
% a new file in the new format.

default_old2New_output(user).

old2New(In) :-
	default_old2New_output(Out),
	old2New(qcm,In,Out).
old2New(Dialect,In,Out) :-
	load_dialect(Dialect),
	t1,
	see(In),
	old2New1,
	seen,
	t2,
	new_object,
	t2,
	finish_ls,
	t3,
	cache_parents, 
	t4,
	cache_kids,
	t5,
	indexObjects2Literals,
	t6,
	indexClasses2Objects,
	t7,
	indexLiterals2Vertices,
	t8,
	ensure_invariants,	
	noGoodsSweep,
	t9,
	tell(Out),
	wmePrint,
	told.
old2New1 :-
	wmeClear(names),
	repeat,
	read(Old),
	once(old2New2(Old,Result)),
	ensures(Result),
	Old = end_of_file,
	!.

new_object :-
	l(ID,OName,State),
	class(CName,_,D1,D2,D3,_Type),
	member(D,[D1,D2,D3]),
	member(State,D),
	\+ o(_,OName,CName),
	assert(o(ID,OName,CName)),
	fail.
new_object :-
	o(_,change(X),eventChange),
	\+ o(_,X,event),
	newN(ID1),
	assert(o(ID1,X,event)),
	fail.
new_object :-
	o(_,X,event),
	\+ o(_,change(X),eventChange),
	newN(ID1),
	assert(o(ID1,change(X),eventChange)),
	fail.
new_object.

finish_ls :-
        l(_,change(Object),arrived),
	\+ l(_,Object,present),
	newN(ID),
	assert(l(ID,Object,present)),
	newN(V),
	assert(v(V,ID,or)),
	fail.
finish_ls :-
        l(_,Object,present),
	\+ l(_,change(Object),arrived),
	newN(ID),
	assert(l(ID,change(Object),arrived)),
	newN(V),
	assert(v(V,ID,or)),
	fail.
finish_ls :-
        l(_,change(Object),left),
	\+ l(_,Object,absent),
	newN(ID),
	assert(l(ID,Object,absent)),
	newN(V),
	assert(v(V,ID,or)),
	fail.
finish_ls :-
        l(_,Object,absent),
	\+ l(_,change(Object),left),
	newN(ID),
	assert(l(ID,change(Object),left)),
	newN(V),
	assert(v(V,ID,or)),
	fail.
finish_ls.


noGoodsSweep :-
	vertex(V),
	my_setof(V1,V^i(V,V1), Set), 
	ensure(noGoods(V,Set)),
	fail.
noGoodsSweep.

%class(C,Domain,Type)
imported_classes(Classes) :-
	setof(Class,Id^O^o(Id,O,Class),Classes).

domain_item_for_class(Class,Item) :-
	o(Id,Object,Class),
	l(Id,Object,Item).

indexClasses2Objects :-
	o(Oid,_,Class),
	class(Class,_,_,_,_,_),
	ensure(coi(Class,Oid)),
	fail.
indexClasses2Objects.

indexObjects2Literals :-
	l(Literal,Object,_Value),
	o(Oid,Object,_Class),
	ensure(oli(Oid,Literal)),
	fail.
indexObjects2Literals.

indexLiterals2Vertices :-
	v(V,Literal,_),
	l(Literal,_,_),
	ensure(lvi(Literal,V)),
	fail.
indexLiterals2Vertices.
	
ensure_invariants :-
	class(Class,_,_,_,_,discrete),
	domain(Class,Domain),
	\+ (Class = and),
	remove1(Domain,Value1,Domain1),
	member(Value2,Domain1),
	
	vertexDetailsFast(V1,Object,Value1,Class,_,_),
	vertexDetailsFast(V2,Object,Value2,Class,_,_),
	ensure(i(V1,V2)),
	fail.
ensure_invariants.
	

old2New2(end_of_file,[]).
old2New2(word(ID,S),[d(S)]) :- \+ ID = ( _ - _).
old2New2(word(_,_),[]).

old2New2(vertex(_,ID,change(Object)=left,_),
	[l(ID,change(Object),left),
	 v(ID,ID,or)
        ]).

old2New2(vertex(_,ID,change(Object)=arrived,_),
	[l(ID,change(Object),arrived),
	 v(ID,ID,or)
        ]).

old2New2(vertex(_,ID,Object=present,_),
	[l(ID,Object,present),
	 v(ID,ID,or)
        ]).

old2New2(vertex(_,ID,Object=absent,_),
	[l(ID,Object,absent),
	 v(ID,ID,or)
        ]).

old2New2(vertex(_,ID,Object=up,_),
	[l(ID,Object,up),
	 v(ID,ID,or)
        ]).

old2New2(vertex(_,ID,Object=down,_),
	[l(ID,Object,down),
	 v(ID,ID,or)
        ]).

old2New2(vertex(_,ID,Object=std,_),
	[l(ID,Object,std),
	 v(ID,ID,or)
        ]). 
    
old2New2(vertex(_,ID,Object,and),
	[l(ID,Object,t),
	 v(ID,ID,and)
        ]) :-
	\+ Object = (_ = _).

old2New2(edge(_,From,To),[e(Eid,From,To,0,1),
                          ei(From,Eid),ebi(To,Eid)]) :-
	newN(Eid).

old2New2(input(_,_),[]).
old2New2(output(_,_),[]).
old2New2(data(A,B,C),[data(A,B,C)]).

old2New2(X,[]) :-
	oops([unknown,{b-X}]).

newClassType(e,event).
newClassType(m,measure).
andor(and,and) :- !.
andor(_,or).



