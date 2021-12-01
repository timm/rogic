sp2(In) :-
	wmeClear(run),
	w r(R),

	flag(vid,VId,VId+1),
	win n(Name),

	halfv(V),
	maplist(fakeIt(R,V),In,_),
	downstreams(R,All),
	touchDownstreams(All,_,Q),
	sp2a(Q).

fakeIt(R,V,In) :-
	gensym(fake,Name),
	flag(eid,EId,EId+1),

	win e(Eid,R,In,0),
	
%memo- set up edges from R to S after data inputs
sp2a(Q0) :-
	dq(D,Eid,Q0,Q1),!,
	e(Eid,U,V,Ew),
	(w d(V,_)
	-> sp2a(Q1)
	;  bar(V,VBar),
	   (w d(VBar,D),
	    w tPrime(VBar),
	    w e(XBar,VBar),
            bar(Xbar,X),
	    (U \= X
            -> sp2a(Q1)
            ;  win d(V,D)
               (w sprime(U), 
                w sprime(VBar)
                ->  win sprime(V)
                ;   win tprime(V)
                    (w sprime(U)
                     -> win cut(V,Eid)
                     ;  w   cut(U,UCutId),
                        win cut(V,UCutId)
                    ),
		    downstreams(U,All),
	            touchDownstreams(All,Q1,Q2)
             )),
             sp2a(Q2)
        ).
sp2a(_).

touchDownstreams([],Q,Q).
touchDownstreams([e(Eid,V,W,Ew0)|Rest],Q0,Q) :-
	Ew is D + Ew0, 
	nq(NewWeight,Eid,Q0,Q1),
	touchDownstreams(Rest,Q1,Q).

downstreams(U,All) :-
	bagof(One,U^downstream(U,One),All).

downstream(U,e(Eid,U,V,Ew)) :-
	w e(Eid,U,V,Ew).

bar(X,Y) :-
	halfv(Size),
	(X > Size
	-> Y is X - Size
	;  Y is X + Size).

