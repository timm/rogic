

%methods
	
term_expansion(X if Y,Out) :-
	\+ X = wrong,
	expandRule(X if Y, Out).

term_expansion(wrong if Conjunction, Outs) :-
	expandMutex(Conjunction, Outs).

term_expansion(X isa Y,Out) :-
	expandObject(X isa Y,Out).

expandRule(X if Y,Out) :-
	write(rule(X)),nl,
	aon2Prefix(Y,Body,Uses),
	bagof(used(Used,rule-X),
		Uses^member(Used,Uses),
	      Useds),
	Out = [ rule(X,Body),
		used(X,rule-X)
	      | Useds
              ],
	is_wmes(Out).

expandMutex(Conjunction, Outs) :-
	write(rule(wrong)),
	aon2p(Conjunction,_,MutuallyExclusive),
	mutexs(MutuallyExclusive,Outs),
	is_wmes(Outs),
	nl.

expandObject(X isa Y, All) :-
	write(object(X)),nl,
	dissectObjectSpecification(X,Y,Parents,ParentsFields0,
                                     Buts,Ands),
	\+ parentsConflicts(ParentsFields0),
	combineParentFields(ParentsFields0,ParentFields),
	\+ andsConflictsWithParents(Ands,ParentFields),
	\+ butsExistInParents(Buts,ParentFields),
	append(ParentFields, Ands, AllFields0),
	insertFieldDetails([parents=Parents|Buts],
			   AllFields0,AllFields),
	bagof(One,X^Parents^AllFields^
			expandObject1(X,Parents,AllFields,One),
	      All).

insertFieldDetails([],Out,Out).
insertFieldDetails([Detail|Details],In,Out) :-
	insertFieldDetail(In,Detail,Temp),
	insertFieldDetails(Details,Temp,Out).

insertFieldDetail([],_,[]).
insertFieldDetail([Old|Olds],Detail,[New|Olds]) :-
	fieldType(Old,   _  , Field, Type, _),
	fieldType(Detail,_  , Field, _   , Value),
	fieldType(_     ,New, Field, Type, Value),
	!.
insertFieldDetail([Old|Olds],Detail,[Old|Rest]) :-
	insertFieldDetail(Olds,Detail,Rest).

% combination priority in left to right order

membersMembers(Lists,List) :-
	bagof(One,Lists^memberMember(One,Lists),List).

memberMember(X,L) :- member(Y,L), member(X,Y).

combineParentFields([],[]) :- !.	
combineParentFields(In,Out) :-	
	membersMembers(In,Temp0),
	maplist(fName,Temp0,Temp1),
	takeFirstKey(Temp1,[],Out).

fName(X,Y-X) :- fieldType(X,_,Y,_,_).

takeFirstKey([],_,[]).
takeFirstKey([Key-Value|Rest],Seen,[Value|Out]) :-
	\+ member(Key,Seen), !,
	takeFirstKey(Rest,[Key|Seen],Out).
takeFirstKey([_|Rest],Seen,Out) :-
	takeFirstKey(Rest,Seen,Out).

%XXX where is id set?
%XXX getting types, not init values in there.

:- 	Things= (isa/2,set/2, used/2, parent/2),
	(multifile Things),
	(discontiguous Things).

expandObject1(X,_,_,set(X,object-X)).
expandObject1(X,Ps,_,used(Parent,object-X)) :- 
	member(Parent,Ps).
expandObject1(X,Ps,_,parent(X,Parent)) :- 
	member(Parent,Ps).
expandObject1(X,_,Fields,Accessor) :-
	accessors(X,Fields,Accessors),
	member(Accessor,Accessors).

% idiom: if you define  astructure,
% define accessors to that structure	
dissectObjectSpecification(X,Y, Parents, 
				ParentsFields,
                              	Buts, 
                              	Ands) :-
	once(dissectObjectSpecification1(Y, Parents0, Buts0,Ands0)),
	maplist(asList,[Parents0, Buts0,Ands0], [Parents,Buts,Ands]),
	(X = any
	->	ParentsFields=[]
	;	maplist(parentField,Parents,ParentsFields)).

parentField(X,   F) :- getObject(object(X,F)).

dissectObjectSpecification1(P but B with A, P,B,  A).
dissectObjectSpecification1(P with A but B, P,B,  A).
dissectObjectSpecification1(P but B,        P,B, []).
dissectObjectSpecification1(P with A,       P,[], A).
dissectObjectSpecification1(P,              P,[],[]).

% checking the object spec
parentsConflicts(P) :-
	setof(Clash, P^fieldShared(Clash,P), Clashes),
	barph(['name clash in parents on ',Clashes]).

andsConflictsWithParents(Ands,P) :-
	setof(Clash, P^fieldShared(Clash,[Ands,P]), Clashes),
	barph(['cannot ''and'' fields known in parents: ',Clashes]).

butsExistInParents(Buts,P) :-
	setof(Missing,P^fieldMissing(Missing,Buts,P),Missings),	
	barph(['cannot ''but'' fields not known in parents: ',Missings]).

fieldShared(Shared,ListOfFields) :-
	twoOf(L1,L2,ListOfFields),
	member(Field1,L1),
	member(Field2,L2),
	fieldType(Field1,_,Shared,_,_),	
	\+ member(Shared,[id,parents]),
	fieldType(Field2,_,Shared,_,_).

fieldMissing(Missing,Buts,Parents) :-
	member(But,Buts),
	fieldType(But,_,Missing,_,_),
	\+ fieldShared(_,[[But],Parents]).

mutexs(L,All) :- 
	setof(One,L^mutex(L,One),All).
mutex(L0,Out) :- 
	oneLess(L0,X,L1), 
	oneLess(L1,Y,_),
	member(Out,[i(X,Y)
		   ,i(Y,X)
		   ,used(X,mutex)
		   ,used(Y,mutex)
                   ]).

% slot accessors
getR(Class,Id,Term) :- 
	blank(Class,Id,Term), 
	Term.
putR(New,Id) :- 
	functor(New,F,A), 
	functor(Old,F,A), 
	id(New,Id),
	id(Old,Id),
	retract(Old), 
	assert(New).

 

expandMethod(Class,Feature,Value,Body0,All) :-
	internalPredicate(Class,Name),
	Head =.. [Name,Feature,In,_,method,Value,Out,Value],
	bagof(	(Head :- Body), 
			Body0^In^Out^x(Body0,Body,In,Out),
		All).

demo(method,1) :-
	all
	term_expansion((any@id=Id <-- o self X, arg(1,X,Id)),All),
	member(One,All), nl,
	portray_clause(One).
		% accessing the objects descriptions

goal(X) :- rule(X,_),!.

getObject(object(X,Y)) :-
	clause(object(X,Y),_).

field(F,V,O) :-	member(F=V,O).

field_chk(F,V,O) :-	member(F=V,O),!.
field_chk(F,_,O) :-	id(Id,O),
			barph(['In [',Id,'], could not find [',F,']']).

kid(Don,Tim) :- parent(Tim,Don), \+ Tim=Don.

kids(A, B) :-
        bagof(C, A ^ kid(A, C), B), !.
kids(_, []).

% display stuff

tree :-
	tree(any).

tree(Root) :-
	all	
	numberTree(Root,All0), 
	reverse(All0,All),
	member(about(Item,Depth),All), 
	upToDo(Depth,write('|  ')), 
	tree1(Item), nl.

tree1(Term^Number) :- format('"~w"^~w',[Term,Number]).
tree1((Term,Number)) :- format('"~w",~w',[Term,Number]).

numberTree(Root,Out) :-
	numberTree(Root,0,1,_,[],Out).

numberTree(X,Depth,N0,N,In,Out) :- 
	once(numberTree1(X,Depth,N0,N,In,Out)).
numberTree1([],_,N,N,Out,Out).
numberTree1([Kid|Kids],Depth,N0,N,In,Out) :- 
	numberTree(Kid,Depth,N0,N1,In,Temp),
	numberTree(Kids,Depth,N1,N,Temp,Out).
numberTree1(Parent,Level,N,N,In,[about((Parent^DD),Level)|In]) :- 
	member(about((Parent,DD),_),In).
numberTree1(Parent,Depth0,N0,N,In,Out) :-
	N1 is N0 + 1,
	Depth is Depth0 + 1,
	kids(Parent,Kids0),
	msort(Kids0,Kids),
	numberTree1(Kids,Depth,N1,N,
				[about((Parent,N0),Depth0)|In],
				Out).
	
field2String(id,_,X,X) :- !,fail.
field2String(parents,isa,X,X) :- !,fail.
field2String(why,why,X,X) :- !.
field2String(F,F,X,Y) :- stringField(F),!,name(Z,X),sformat(Y,'~w',Z).
field2String(Name,Name,X,X).

stringField(ask).
stringField(aka).
stringField(say).
stringField(prompt).
stringField(ifNotYes).
stringField(ifYes).
stringField(ifMaybe).
stringField(ifNo).

literal(say(X),X) :- !.
literal(report(X),X) :- !.
literal(X,X).

objects :- objects(any).
objects(X) :-
	all
	numberTree(X,Hier0),
	sort(Hier0,Hier),
	member(about((O,N),_),Hier),
	getObject(object(O,Attributes0)),
	nl,
	oneLess(Attributes0,Item,Attributes1),
	fieldType(Item,_,parents,_,Ps),
	msort(Attributes1,Attributes),
	format('"~w",~w',[O,N]),nl,
	objectIsa(Ps,Hier),
	objectKids(O,Hier),
	objectForbids(O,Hier),
	objectErrors(O),
	objectWarnings(O),
	member(F,Attributes),
	objectsFields(F), 
	nl.

objectsFields(F0=A) :- !,
	field2String(F0,F,A,String),
	print(F),
	write('={'),
	write(String),
	write('}').

objectsFields(F) :- 
	print(F), write('={}').

objectIsa(Parents,Hier) :-
	write('isa={['),
	member(Parent,Parents),
	member(about((Parent,N),_),Hier),
	format(' "~w"^~w ',[Parent,N]),
	fail.
objectIsa(_,_) :-
	write(']}'), nl.

objectKids(X,Hier) :-
	write('parentOf={['),
	kid(X,Kid),
	member(about((Kid,N),_),Hier),
	format(' "~w"^~w ',[Kid,N]),
	fail.
objectKids(_,_) :-
	write(']}'), nl.

objectForbids(X,Hier) :-
	write('contradicts={['),
	i(X,Y),
	member(about((Y,N),_),Hier),
	format(' "~w"^~w ',[Y,N]),
	fail.
objectForbids(_,_) :-
	write(']}'), nl.

objectErrors(X) :-
	write('errors={['),
	error(X,Y),
	write('~!'),write(Y),
	fail.
objectErrors(_) :-
	write(']}'), nl.

objectWarnings(X) :-
	write('warnings={['),
	warning(X,Y),
	write('~?'),write(Y),
	fail.
objectWarnings(_) :-
	write(']}'), nl.


net      :- goal(Top), net(Top).
net(Top) :- net1(Top,1,[],_,1,_).

net1([H|T],Level,Done0,Done,Pos0,Pos) :- !,
	netShow(Level,H),
	netList(T,Level+1,Done0,Done,Pos0,Pos).
net1(Here,Level,Done,Done,Pos,Pos) :- 
	member(Where-Here,Done),
	!,
	net2(Here,Where,'^',Report),
	netShow(Level,Report).
net1(Here,Level,Done0,Done,Pos0,Pos) :-
	rule(Here,There), 
	!,
	Pos1 is Pos0 + 1,
	net2(Here,Pos1,',',Report),
	netShow(Level,[Report,' if']), 
	net1(There,Level+1,[Pos1-Here|Done0],Done,Pos1,Pos).
net1(Here,Level,Done,[Pos0-Here|Done],Pos0,Pos) :-
	Pos is Pos0 + 1,
	net2(Here,Pos,',',Report),
	netShow(Level,Report).

net2(say(X),Pos,Dot,String) :- !, 
	sformat(String,'say("~w"~w~w)',[X,Dot,Pos]).
net2(report(X),Pos,Dot,String) :- !, 
	sformat(String,'report("~w"~w~w)',[X,Dot,Pos]).
net2(X,Pos,Dot,String) :- 
	sformat(String,'"~w"~w~w',[X,Dot,Pos]).

netList([],_,Done,Done,Pos,Pos).
netList([H|T],Level,Done0,Done,Pos0,Pos) :-
	net1(H,Level,Done0,Done1,Pos0,Pos1),
	netList(T,Level,Done1,Done,Pos1,Pos).

netShow(Level,X) :-
	upToDo(Level-1,write( '|  ')),
	writes(X,''),
	nl.

% html stuff

htmls :-
	net2html,
	tree2html,
	terms2html.
	
net2html       :- x2html(a2html,abox,net).
tree2html :- x2html(h2html,h,tree).
terms2html     :- x2html(t2html,tbox,objects).

x2html(ShellFile,OutFile,Goal) :-
	environment(ltemp, Temp),
	environment(lbin, Bin),
	environment(lroot, Root),
	sformat(Config,'~w/config',[Root]),
	sformat(In0,'~w/~w.txt',[Temp,OutFile]),
	string_to_atom(In0,In),
	sformat(Com,'sh ~w/~w ~w ~w > ~w/~w.html',
                [Bin,ShellFile,Config,In,Temp,OutFile]),
	tell(In),
	Goal,
	told,
	shell(Com).


%%		
	% utils
% general prolog tricks

% meta stuff

foreach(Item,List,Goal) :-
	all
	member(Item,List),
	Goal.

ensure(X) :- X, !.
ensure(X) :- assert(X).

membera(X,X) :- var(X),!.
membera(X,(X,_)).
membera(X,(_,Y)) :- membera(X,Y).
membera(X,X) :- \+ X = (_,_).

membero(X,X) :- var(X),!.
membero(X,(X;_)).
membero(X,(_;Y)) :- membero(X,Y).
membero(X,X) :- \+ X = (_;_).

% convert and or nots to standard prolog
aon2p(X,Y,Uses) :-
	aon2p(X,Y,[],Uses).

aon2p(X0 and Y0,(X,Y))   --> !, aon2p(X0,X), aon2p(Y0,Y).
aon2p(X0 or Y0,(X;Y))    --> !, aon2p(X0,X), aon2p(Y0,Y).
aon2p(not X0,\+ X)       --> !, aon2p(X0,X).
aon2p(say(X0),say(X))    --> !, aon2p(X0,X).
aon2p(report(X0),say(X)) --> !, aon2p(X0,X).
aon2p(X,X,In,Out)        :-  union([X],In,Out).

atoms(Term,Atoms) :-
	atoms(Term,[],Atoms).
atoms(Term,In,Out) :- 
	Term =.. [_|T],
	atoms1(T,In,Out).

atoms1([],Out,Out).
atoms1([H|T],In,Out) :-
	var(H), !,
	atoms1(T,In,Out).
atoms1([H|T],In,Out) :-
	atom(H),!, 
	union([H],In,Temp),
	atoms1(T,Temp,Out).
atoms1([H|T],In,Out) :-
	atoms1(H,In,Temp),
	atoms1(T,Temp,Out).


aon2Prefix(X,Y,Uses) :- 
	aon2Prefix1(X,Temp,[],Uses),
	aon2PrefixFlatten(Temp,Y).

aon2Prefix1(X0 and Y0,[and,X,Y]) --> !,aon2Prefix1(X0,X), aon2Prefix1(Y0,Y).
aon2Prefix1(X0 or Y0,[or,X,Y])  --> !,aon2Prefix1(X0,X), aon2Prefix1(Y0,Y).
aon2Prefix1(not  X0, [not,X])   --> !,aon2Prefix1(X0,X).
aon2Prefix1((X0,Y0),[and,X,Y]) --> !,aon2Prefix1(X0,X), aon2Prefix1(Y0,Y).
aon2Prefix1((X0;Y0),[or,X,Y])  --> !,aon2Prefix1(X0,X), aon2Prefix1(Y0,Y).
aon2Prefix1(\+  X0, [not,X])   --> !,aon2Prefix1(X0,X).
aon2Prefix1(X,X,In,Out)        :-  literal(X,Y), !, union([Y],In,Out).
aon2Prefix1(X,X,In,Out)        :-  union([X],In,Out).

aon2PrefixFlatten([H|T0],[H|T]) :- !,aon2PrefixFlatten1(T0,H,T).
aon2PrefixFlatten(X,X).

aon2PrefixFlatten1([],_,[]).
aon2PrefixFlatten1([[Top|T0]|T1],Top, Out) :- !,
	append(T0,T1,T2),
	aon2PrefixFlatten1(T2,Top,Out).
aon2PrefixFlatten1([H0|T0],Top,[H|T]) :-
	aon2PrefixFlatten(H0,H),
	aon2PrefixFlatten1(T0,Top,T).

% string stuff

showPosN(N) :- N < 10, !,write('    '),write(N).
showPosN(N) :- N < 100, !,write('   '),write(N).
showPosN(N) :- N < 1000, !,write('  '),write(N).
showPosN(N) :- N < 10000, !,write(' '),write(N).
showPosN(N) :- write(N).

asString([X|Y],String) :- number(X), !,name(String,[X|Y]).
asString(X,String) :- sformat(String,'~w',X).

% list stuff

after(X,[X|T],T).
after(X,[_|T],Y) :- after(X,T,Y). 

deletes(In,ToGo,Out) :-
	deletes1(ToGo,In,Out).

deletes1([],X,X).
deletes1([H|T],In,Out) :-	
	delete(In,H,Temp),
	deletes1(T,Temp,Out).

appends([],[]).
appends([H],H).
appends([H1,H2|Rest],Out) :-
	append(H1,H2,Temp),
	appends([Temp|Rest],Out).

inBetween([H],_,[H]) :- !.
inBetween([H|T0],Between,[H,Between|T]) :-
	inBetween(T0,Between,T).

twoOf(One,Two,L0) :- oneLess(L0,One,L1), oneLess(L1,Two,_).

oneLess([A|B], A, B).
oneLess([A|B], C, [A|D]) :- oneLess(B, C, D).

asList([],[]) :- !.
asList([H|T],[H|T]) :- !.
asList(X,[X]).

% misc stuff

arg1(X,One) :- arg(1,X,One).

	
% scren stuff

warn(X)  :- write('   '),message('??',X).
barph(X) :- write('   '),message('!!',X),fail.

message(What,Msg0) :-	asList(Msg0,Msg),writes([What|Msg]),nl.

writesln(List) :- sformat(S,'~n',[]), writes(List,S).

writes(List) :- writes(List,' ').
writes(List0,Sep) :-
	all
	asList(List0,List),
	member(Item,List),
	write(Item), 
	write(Sep). 


% operating system stuff

bell :- shell('echo ''\07\c''').	

% maths stuff

upTo(I,J)                :- upTo(I,J,_).
upTo(I0,J0,N)            :- I is I0,  J is J0,  between(I,J,N).

upToDo(J,Action)         :- upToDo(1,J,_,Action).
upToDo(J,Item,Action)    :- upToDo(1,J,Item,Action).
upToDo(I,J,Item,Action)  :- forall(upTo(I,J,Item), Action).

% demos


% macros


term_expansion((note X/2 ; Y),All) :-!,
        bagof(One,X^Y^note2(X,Y,One),All). 

term_expansion((note X ; Y),All) :-!,
        bagof(One,X^Y^note1(X,Y,One),All).

note1(X,Y,Term) :- Term=..[X,Z], membero(Z,Y).
note2(X,Y,Term) :- Term=..[X,First,Second], membero((First,Second),Y).

term_expansion((Class@Feature=Value <-- Body),All) :- !,
	expandMethod(Class,Feature,Value,Body,All). 

term_expansion((Class@Feature <-- Body),All) :- !,
	expandMethod(Class,Feature,t,Body,All). 

% a cute query system
% needs a definition of swap
% needs t be wrapped in gets and commits

Class=Id o Coms :-  !,
	blank(Class,Id,Old),
	Old, 
	o(Coms,Old,New),
	retract(Old),
	assert(New).

o(Gs,T)                :- o(Gs,T,_).

o(Field=Old:=New,T0,T)  :- !,	touch(T0,Field,Old,_,_,T,New).
o(Field:=New,T0,T)  :- 	touch(T0,Field,_,_,_,T,New).
o(Field@Fields, T, T)  :- 
	o(Field = T1,T,_), 
	o(Fields,T1,_).
	
o(Field = X,    T, T)  :- touch(T,Field,X,_,_,_,_).

o([],    T, T).
o([G|Gs],T0,T)         :- o(G,T0,T1), o(Gs,T1,T).

o(Field>=Value, T, T)  :- o(Field = X, T,T), X >= Value.
o(Field> Value, T, T)  :- o(Field = X, T,T), X > Value.
o(Field\=Value, T, T)  :- o(Field = X, T,T), X \= Value.
o(Field< Value, T, T)  :- o(Field = X, T,T), X < Value.
o(Field=<Value, T, T)  :- o(Field = X, T,T), X =< Value.
o(Field in List,T, T)  :- o(Field = X, T,T), member(X,List).

o(Field++,    T0,T)    :- o(Field + 1,       T0,T).
o(Field--,    T0,T)    :- o(Field + -1 ,     T0,T).
o(Field-N,    T0,T)    :- o(Field + (-1 * N),T0,T).
o(Field<<X,   T0,T)    :- o(Field = Old, T0,T0), o(Field:=[X|Old],T0,T).
o(self  T,    T,T). 
o(Field+N, T0,T)       :-
        o(Field = Old,T0,T1), 
        New is Old + N,
        o(Field=New,T1,T).

touch([Field=Value0|T],Field,Value0,any,_,[Field=Value|T],Value) :- !.
touch([H|T0],Field,Value0,any,_,[H|T],Value) :- 
	touch(T0,Field,Value0,any,_,T,Value).

% a better dcg. only the o X stuff is expanded.


term_expansion((X0 <-- []), X)   :- \+ X0 = (_@_), x1(X0, X, _,_).
term_expansion((X0 <-- Y0), All) :- \+ X0 = (_@_), xs((X0 <-- Y0), All).

xs((X0 <-- Y0), All) :- 
	bagof(	One, 
			X0^Y0^In^Out^x((X0 <-- Y0), One,In,Out),
		All).

x(X       ,X     ,In, In) :- var(X),!.
x((X0 <-- Y0),(X:-Y),In,Out) :- !,x1(X0,X,In,Out),  x(Y0,Y,In,Out).
x((X0->Y0;Z0),New, In,Out):- !,( x(X0 ,X,In,T),  
				 x(Y0,Y,T, Out),
				 New=(X,!,Y)
			       ; x(Z0,Z,In,Out),
				 New=Z).
x((X0,Y0) ,(X,Y), In,Out) :- !,x(X0 ,X,In,T),    x(Y0,Y,T, Out).
x((X0;Y0) ,X,     In,Out) :- !,(x(X0,X,In,Out);  x(Y0,X,In,Out)).
x((X0|Y0) ,X,     In,Out) :- !,(x(X0,X,In,Out);  x(Y0,X,In,Out)).
x(not X0, not X,  In,In)  :- !,x(X0 ,X,In,_).
x(o X,o(X,In,Out),In,Out) :- !.
x(X  ,X,          In, In).

x1(X0,X,In,Out) :-
     X0 =.. L0,
     append(L0,[In,Out],L),
     X  =.. L.   

xDemo(1,2,3) <-- [].
xDemo(A,1,B) <--
	A=B,
        b(a,5,A),
        c,!,
        (d -> 
		e,
      	 	o fred++ ,
         	o fred > 10,
         	o tom := 23
         ; 	Z is 1 + 1,
          	f(Z,B)
	),  
	not (a(a),
             l(1),
	     o z++ 
            ),
	 o a-- ,
         l(h).


demo(x,1) :- listing(xDemo).
