% demos- stuff to show off the system

eg(1) --> 
	[H|T]=[23,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60,
	       23,10,60
	   ],
	o(init(H)),
	o(adds(T)).
eg(2)  --> 
	o(init(23)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)),
	o(add(23)),o(add(10)),o(add(60)).

demo(1) :-
      eg(2,_,X), o(bins=B,X), distBin(B).

demo(2) :-
	oStatus,
	eg(2,_,X),
        o(show(2),X),
        o(average(A),X),
        format('\t--\n\taverage = ~w\n',[A]),

	% how to time a program
        N = 1000,
        T1 is cputime,
        forall(between(1,N,_),eg(2,_,_)),
        T2 is cputime,
        T is (T2 - T1) /N,
        format('\truntime = ~w (ms)\n',[T]).

demo(3) :-
	bagof(X,X0^Y^(between(1,1000,Y),
                     normDist(20,4,X0), 
                     X is round(X0/5)*5),
                   All),
	dist(All).
 
% code to call the profiler- wont work under windows
prof :-
  	profile(forall(between(1,10000,_),demo),plain,10).




