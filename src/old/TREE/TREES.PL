
 	
 wanteds(N,List,All) :- setof(Temp,One^List^N^
 				    (member(One,List),
                                     wanteds1(One,N,Temp)),
                              All).
 
 wanteds1(-X,N,want(N,-,One)) :- !,dash2list(X,Temp), reverse(Temp,One).
 wanteds1( X,N,want(N,+,One)) :- dash2list(X,Temp), reverse(Temp,One).
 
 
 dash2list(X/Y,[Y|Rest]) :- !,dash2list(X,Rest).
 dash2list(X,[X]).
 
 portray(class(A,B)) :- format('db(~p,"~s").',[A,B]).
 
 lint :- forall(lint1(X),(print(X),nl)).
 
 lint1(unknown(doing(C))) :- doing(_,_,C), \+ class(C,_).
 lint1(wrongSum(P,Sum))   :- projectValues(P,Sum), Sum \= 6.
 lint1(unknown(wanted(C))):- want(_,_,C), \+ class(C,_).
 
 project(P) :- doing(P,_,_).
 projects(Ps) :- setof(P,project(P),Ps).
 
 projectValue(P,V) :- doing(P,V,_).
 projectValues(One,Sum) :-
 	projects(All),
 	member(One,All),
 	findall(V,projectValue(One,V),Nums),
 	sum(Nums,Sum).
 	
 sum([H|T],Out) :- sum(T,H,Out).
 sum([],Out,Out).
 sum([H|T],Old,Out) :- New is H + Old, sum(T,New,Out).
 
 tree :- 
 	tell('tree.txt'),tree1, told.
 
 tree1 :-
 	All=[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z],
 	forall(member(X,All), forall(tree2([X],0),true)).
 	
 tree2(X,L) :-   
 	class(X,What), tab(L), head(X), format('. ~s',[What]),
 	forall(want(_,+,X),write('?')),
 	forall(want(_,-,X),write('X')),
 	forall(doing(_,_,X),write('!')),
 	nl.
 tree2(X,L) :-  subitem(X,Y), tree2(Y,L+4).
 
 subitem(X,Y) :- class(X,_),append(X,[_],Y),class(Y,_).
 
 head([H1,H2|T]) :- write(H1),write('.'),head([H2|T]).
 head([H]) :- write(H).
 
 branch(Branch ) :-
 	All=[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z],
 	member(One,All),
 	branch([One],Branch).
 	
 branch([X,Y,Z|W],[])   :- want(_,_,[X,Y,Z|W]),!.
 branch(Parent,[Parent|T]) :-  subitem(Parent,Child),  branch(Child,T).
 
 wantedBranch(B) :-
 	branch(B),
 	once((member(One,B), want(_,_,One))).

 term_expansion(class(A,[_|B]),class(A,C)) :-
  	append(C,[13],B).
  
  term_expansion(wanted(N,List),Out) :-
 	wanteds(N,List,Out).
 	
  :- [class,doing,wanted].
  
 