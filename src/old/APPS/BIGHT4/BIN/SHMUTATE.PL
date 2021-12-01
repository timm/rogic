:- q(qmut(classes,     nclasses, entities, size, nlinks,
	  connections, name,     tooHards)).

qmut1(X) :-
	qmut0(X0),
	set_new(C0),
	set_new(C1),
	set_new(C2),
	qmuts([nclasses=C0,connections=C2,entities=C1],X0,X).

%----------
% control

mutateName(Stem,D,Name) :-
	gensym(Stem,Name0),
	my_file([dialects,D,mutations,Name0], '.the', Temp),
	(exists_file(Temp)
	->	mutateName(Stem,D,Name)
	|	Name = Name0).

mutate(Stem,D,In,NFactor,BFactor,The,Net,
       Vertices=OVertices+AVertices,Fanout) :-
	qmut1(Q0),
	%print(analysing(In)),nl,
	see(In),
	read(Item),
	mutateStats(Item,Q0,Q1),
	seen,
	
%	qprint(Q1),
	mutateName(Stem,D,Name),
        my_file([dialects,D,mutations,Name], '.the', The),
        my_file([dialects,D,mutations,Name], '.net', Net),
    	my_file([dialects,D,mutations,Name], '.stats', Stats),
      
	%print(writing(The)),nl,
	ignore(delete_file(The)),
	tell(The),
	mutate1(Q1,NFactor),
	told,
	graphStats(_=_+As,OldFanout),
	NewFanout is OldFanout * BFactor,
	As > 0,
	load_dialect(D),
	%print(writing(Net)),nl,
	ignore(delete_file(Net)),
	compile_theory_generate(D,The),
	mutateB(NewFanout,_NewlyCreatedB),
	tell(Net),
	compile_theory_print(Net,D),
	told,  
	graphStats(  Vertices=OVertices+AVertices,Fanout),
	ignore(delete_file(Stats)),
	tell(Stats),
	print(graphStat(Name, Vertices=OVertices+AVertices,Fanout)),
	write('.'), nl,
	told.

graphStats(  Vertices=OVertices+AVertices,Fanout) :-
	n(e(_,_,_,_,_),Edges),
	n(v(_,_,and),AVertices),
	n(v(_,_,or),OVertices),
	Vertices is OVertices + AVertices,
	Fanout is Edges/Vertices.
	

mutateStats(end_of_file,Q,Q) :- !.
mutateStats(Item,Q0,Q) :- 
	mutateStats1(Item, Q0,Q1), !,
	read(Item1),
	mutateStats(Item1,Q1,Q).
mutateStats(Item,Q0,Q) :-
	qmuts(tooHard*Item,Q0,Q1),
	read(Item1),
	mutateStats(Item1,Q1,Q).

% -------------------
% data collection on the input model

mutateStats1(name = X,Q0,Q) :- 
	gensym(X,NewName),
	qmuts([name=NewName],Q0,Q).


mutateStats1(objects(Class) = Names,Q0,Q) :- 
	length(Names,Size),
	qmuts(nclasses=Classes0,Q0),
	set_incsel(Classes0,Class+Size,Classes),
	mutClassInstances(Names,Class,[],E),	
	qmuts([size+Size,nclasses=Classes,classes*Class,entities*E],Q0,Q).
	
mutateStats1(Link,Q0,Q) :- 
	skeleton(Link,Skel,Vars), 
	classesInVars(Vars,Q0,Classes),	
	qmuts(connections=C0,Q0),
	(remove1(C0,Classes/Skel=Old,C1)
	-> 	New is Old + 1,
		C2 =  [Classes/Skel=New|C1]
        |	C2 =  [Classes/Skel=1|C0]),
	qmuts([nlinks++,connections=C2],Q0,Q).
	
mutClassInstances([],_,Out,Out).
mutClassInstances([H|T],C,In,Out) :- 
	mutClassInstances(T,C,[H=C|In],Out).

classesInVars([],_,[]).
classesInVars([H==_|T0],Q,[C|T]) :-
	qmuts(entities=E,Q),
	member(H=C,E) ,
	classesInVars(T0,Q,T).

%------------------------------

mutate1(Q0,NFactor) :-
	qmuts([name=Name,size=Size0,nclasses=Classes,nlinks=NLinks, 
               connections=Connects],Q0),
	Vertices is integer(NFactor * Size0),
	normalise_alist(Classes,NClasses),
	print(name = Name), write('.'),nl,nl,
	mutateNames(NClasses,Vertices,[],Names),
	mutateObjectsDefinition(Names),
	mutateLinks(NLinks,Connects,Names).

mutateNames([],_,Names,Names).
mutateNames([Class=Percent|T],S,Names0,Names) :-
	N is integer(Percent*S),
	mutateNames1(N,Class,[],Objects),
	mutateNames(T,S,[Class=Objects|Names0],Names).

mutateNames1(0,_,Names,Names).
mutateNames1(N,Class,In,Out) :-
	N > 0,
	gensym(Class,Name),
	N1 is N - 1,
	mutateNames1(N1,Class,[Name|In],Out).
	
mutateObjectsDefinition(Names) :-
	member(Class=Objects,Names),
	print(objects(Class) = Objects),
	write('.'),
	nl,nl, 
	fail.
mutateObjectsDefinition(_).

mutateLinks(N,Connects,Names) :-
	between(1,N,_),
	mutateLink(Connects,Names),
	fail.
mutateLinks(_,_,_).

mutateLink(Connects,Names) :-
	random_amember(Connects,Classes/Link0),
	skeleton(Link0,Link,Vars),
	mutateLink1(Classes,Names,Vars),
	print(Link),
	write('.'),
	nl.

mutateLink1([],_,[]).
mutateLink1([Class|Classes],Names0,[_== Object|Rest]) :-
	remove1(Names0,Class=Objects0,Names1),
	random_delete(Objects0,Object,Objects1),
	mutateLink1(Classes,[Class=Objects1|Names1],Rest).

%---------------
mutateB(Goal,Out) :-
	bagof(V,X^v(V,X,or),Ors),	
	bagof(V,X^Y^v(V,X,Y),All),	
	n(e(_,_,_,_,_),Edges),
	length(All,Vertices),
	Repeats is integer((Goal*Vertices) - Edges),
	Repeats > 0,
	mutateB1(Repeats,Ors,All),
	graphStats(_,Out). 

mutateB1(0,_,_) :- !.
mutateB1(N,Ors,All) :-
	mutateEnds(Ors,All,From,To),
	newN(E1),
	ensures([e(E1,From,To,0,mutateB),
	         ei(From,E1),
	         ebi(To,E1)]),
	N1 is N - 1,
	mutateB1(N1,Ors,All).
	
		
mutateEnds(Ors,All,From,To) :-
	random_member(Ors,To1),
	random_member(All,From1),
	(To1 = From1
	->	mutateEnds(Ors,All,From,To)
	| 	To = To1,
		From = From1).


	