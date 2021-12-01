 
 neg(_,V1,V2) :- ground(V1), ground(V2),  V1 \= V2.
 neg(X,V1,V2) :- ground(V1), var(V2), 
	         range(X,Range),
	         delete(Range,V1,Less),
	         rone(Less,V2,_).
 neg(X,V1,V2) :- var(V1), ground(V2),
	         neg(X,V2,V1).
 neg(X,V1,V2) :- var(V1), var(V2),
	         val(X,V1,Less),
		 rone(Less,V2,_).

 val(X,Y,Less) :- range(X,Range), rone(Range,Y,Less).

 range(X,Y) :- range1(X,Y),!.
 range(_,[1,-1]).

 :- multifile range1/2.
 
 range1(day,[m,t,w,th,f,sa,su]).
 
 do(Context0,Goals,W) :-
 	context(Context0,_,W0), % 1. intialize working memory
 	                        % with the supplied context vars
 	do1(Goals,W0,W).        % 2. try and prove stuff

 % prove things in a random order
 do1([],W,W).
 do1(L,W0,W) :-
	rone(L,X=V,L1),
	gensym(n,F),
	flag(F,_,0),
	do2(F,X=V,W0,W1),
	do1(L1,W1,W).
 
 do2(F,X=V,W0,W) :- q(X,V,W0,W), flag(F,N,N+1). 
 do2(F,_,  W, W) :- flag(F,0,0).

 % core query predicate
 q(X,New) -->
 	context(X,Old), % get the old value
 	% now set some control vars
 	{(var(Old) -> Var=new   ; Var=old), 
 	 (ab(X)    -> Todo=whatever; Todo=infer)
         },
 	q1(Var,Todo,X,Old,New).

 ab(X) :- defs(X,[]). % abducible if defined zero times.

 % helper predicate for q
 q1(old,_,        _,Old,Old,W, W).   
 q1(new,infer,    X,New,New,W0,W) :- 
	defs(X,L),
	rone(L,p(X,New,W0,W)=Body,_),
	Body. 
 q1(new,whatever, X,New,New,W, W) :-
	val(X,New,_). 
 
 % pop a random item off a list

 rone(L,Out,Rest) :-
	length(L,N),
	rone(L,N,Out,Rest,_).

 rone([H],_,H,[],0) :- !.
 rone([H|T],N0,X,Out,N) :-
        N is N0 - 1,
        Pos is random(N0) + 1,
        oneLessN(Pos,[H|T],One,Rest),
        (X=One, Out=Rest
        ; Out=[One|Tail],
          N1 is N0 - 1,
          rone(Rest,N1,X,Tail,_)).

 oneLessN(1,[H|T],H,T) :- !.
 oneLessN(N0,[H|T],X,[H|Rest]) :-
        N is N0 - 1,
        oneLessN(N,T,X,Rest).


