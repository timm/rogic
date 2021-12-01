% a bag with many values for each key (keys unique).

:- module(bag,[bag/2,bag/3,bag/1]).

bag(blank,b(_,_,_,_)).

bag(new(Inits),B) :-
	B0=  b(  0,  % size
                 0,  % total queries
                 0,  % max depth of queries
                 Q   % a heap of difference lists
                 ),
	pq(new([]),Q),
	bag(pokings(Inits),B0,B).
bag(size(S),b(S,_,_,_)).
bag(show,b(S,N,Dall,Q)) :- 
	L is log(S)*1.44269,
	D is Dall/N,
	write(b(size(S),logSize(L), averageDepth(D))),
	nl,
	pq(show,Q).

bag(poke(K,V),b(S0,N,Dall,Q0), Out) :- 
	S is S0 + 1,
	pq(poke(K,V,D),Q0,Q),
	bag(queried(D),b(S,N,Dall,Q),Out).
bag(pull(V), b(S0,N,Dall,Q0),Out) :-
	S is S0 - 1,
	pq(pull(V,D),Q0,Q),
	bag(queried(D),b(S,N,Dall,Q),Out).
bag(queried(D),b(S,N0,Dall0,Q0), Out) :-
	N is N0+1,
	Dall is Dall0+D,
	(bag(balancingActOn),
	 thisQueryIsDeep(D),
	 weHaveDoneLotsOfQueries(N),
         mostQueriesAreTooDeep(Dall,N,S)
	-> sHOUT('>'),
	   pq(balance,Q0,Q),
	   sHOUT('<'),
	   Out = b(S,0,0,Q)
	;  Out = b(S,N,Dall,Q0)).

% size measure is wrong- dup keys

bag(pokings([]),   B, B) :-  bag(blank,B).
bag(pokings([K-V|T]),B0,B)   :- bag(poke(K,V),B0,B1),bag(pokings(T),B1,B).
bag(pullings([]),  B, B) :-  bag(blank,B).
bag(pullings([V|Vs]))    --> bag(pull(V)), bag(pullings(Vs)).

bag(balancingActOn).

bag(demo1) :-
	Inits=[2-200,4-400,12-1201,7-701,9-900,9-9001,11-1100],
	bag(new(Inits),B),
	bag(show,B).

bag(demo2) :-
	N = 1,
	R=1000,
	shout(0),
	nNumbers(R,Nums0),
	maplist(zap(1000),Nums0,Nums1),
	append(Nums0,Nums1,Nums2),
	maplist(zap(2000),Nums2,Nums3),
	append(Nums2,Nums3,Nums4),
	shout(1),
	bag(demo2a(N,4000,Nums4,T1)),
	bag(demo2b(N,4000,Nums4,T2)),
	%bag(demo2c(N,R,Numbers,T3)),
	bag(demo2d(N,4000,Nums4,T4)),
	print(t(bag(T1),raw(T2),noop(_T3),heap(T4))),nl.

bag(demo2a(N,R,Numbers,T)) :-
	shout(shoves),nl,
	T1 is cputime,
	forall(between(1,N,_),shove(Numbers,R,_)),
	T2 is cputime,
	T is (T2-T1)/N.

bag(demo2b(N,R,Numbers,T)) :-
	shout(raw),nl,
	T1 is cputime,
	forall(between(1,N,_),shoveRaw(Numbers,R,_)),
	T2 is cputime,
	T is (T2-T1)/N.

bag(demo2c(N,R,Numbers,T)) :-
	shout(zip),nl,
	T1 is cputime,
	forall(between(1,N,_),shoves0(Numbers,R)),
	T2 is cputime,
	T is (T2-T1)/N.

bag(demo2d(N,R,Numbers,T)) :-
	shout(heap),nl,
	T1 is cputime,
	forall(between(1,N,_),shoveHeap(Numbers,R,_)),
	T2 is cputime,
	T is (T2-T1)/N.

zap(X,Y,Z) :- Z is X + Y.

%%%%%%%%%%%%%%%%%

thisQueryIsDeep(D)              :- D > 6.
weHaveDoneLotsOfQueries(N)      :- N > 30.
mostQueriesAreTooDeep(Dall,N,S) :- Dall/N > log(S)*1.44269*2.
                                                  
%%%%%%%%%%%%%%%%% 

shove(Numbers,R,H) :-
	bag(new([1-1]),H0),
	shove(R,Numbers,H0,H).

shove(0, _,H,H)  :- !.
shove(_,[],H,H) :- !.
shove(N,[Key|Keys],H0,H) :- 
	N > 0, 
	%heap_size(H0,Size),print(Size),
	N1 is N - 1,
	(bag(size(S),H0),
	 S > 0,
	 random(3) > 1
	->	shout('-'),
		bag(pull(_) ,H0,H1),
	  	shove(N1,[Key|Keys],H1,H)
	;	shout('+'),
		bag(poke(Key,v),H0,H1), 
		shove(N1,Keys,H1,H)).


/*

shoves([H|T],B) :-
	bag(new([1-1]),B0),
	shove([1],_,B0,B). %, bag(show,B).

shove(0,_,Keys,Keys,B,B).
shove(N,R,Keys0,Keys,B0,B) :- 
	N > 0, 
	N1 is N - 1,
	(bag(size(S),B0),
	 S > 0,
	 random(3) > 1
	->	shout('-'),
	  	bag(pull(_) ,B0,B1),
	  	shove(N1,R,Keys0,Keys,B1,B)
	;	shout('+'),
		Key is random(R), 
		Value=v,
		bag(poke(Key,Value),B0,B1), 
		shove(N1,R,[Key|Keys0],Keys,B1,B)).
*/
shoves0(N1,N2) :-
	%bag(new([]),B0),
	shove0(N1,N2,[],_).

shove0(0,_,K,K).
shove0(N,R,Keys0,Keys) :- 
	N > 0, 
	N1 is N - 1,
	(
	 random(3) > 1
	->	shout('-'),
	  	%bag(pull(_) ,B0,B1),
	  	shove0(N1,R,Keys0,Keys)
	;	shout('+'),
		Key is random(R), 
		_=v,
		%bag(poke(Key,Value),B0,B1), 
		shove0(N1,R,[Key|Keys0],Keys)).


shoveRaw(Numbers,R,H) :-
	pq(new([1-1]),H0),
	shoveRaw(R,Numbers,H0,H).

shoveRaw(0, _,H,H)  :- !.
shoveRaw(_,[],H,H) :- !.
shoveRaw(N,[Key|Keys],H0,H) :- 
	N > 0, 
	%heap_size(H0,Size),print(Size),
	N1 is N - 1,
	(\+ pq(empty,H0),
	 random(3) > 1
	->	shout('-'),
		pq:qpullmin(_,0,_,H0,H1),
	  	shoveRaw(N1,[Key|Keys],H1,H)
	;	shout('+'),
		pq:qpokes(Key,[v],0,_,H0,H1),
		shoveRaw(N1,Keys,H1,H)).


shoveHeap(Numbers,R,H) :-
	empty_heap(H0),
	shoveHeap(R,Numbers,H0,H).

shoveHeap(0, _,H,H)  :- !.
shoveHeap(_,[],H,H) :- !.
shoveHeap(N,[Key|Keys],H0,H) :- 
	N > 0, 
	%heap_size(H0,Size),print(Size),
	N1 is N - 1,
	(\+ empty_heap(H0),
	 random(3) > 1
	->	shout('-'),
		get_from_heap(H0,_,_,H1),
	  	shoveHeap(N1,[Key|Keys],H1,H)
	;	shout('+'),
		add_to_heap(H0,Key,v,H1),
		shoveHeap(N1,Keys,H1,H)).


	
