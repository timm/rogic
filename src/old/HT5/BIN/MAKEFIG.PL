reads(File, All) :-
        see(File),
        current_stream(File,_,S),
        read(S,X),
        reads1(X,S,All),
        seen.

reads(All) :-
        read(X),
        reads2(X,All).

reads1(end_of_file,_,[]) :- !.
reads1(H ,S,[H|Rest]) :- read(S,X), reads1(X,S,Rest).

reads2(end_of_file,[]) :- !.
reads2(H ,[H|Rest]) :- read(X), reads2(X,Rest).

plindex :- 
	reads(L), 
	setof(Index,plindex(L,Index),Indexes),
	writel(Indexes).

% dcg this

plindex(X,S) :- once(plindex1(X,S)).

plindex1([X|Y],[S|SS]) :- plindex(X,S), plindex1(Y,SS).

plindex1((X :- Y)) :- plindex(X).
	
plindex1(X) :-
	functor(X,F,A),
	indexIt(F/A).

indexIt(It,S) :- sformat(S,'\index{~w}',[It]).

