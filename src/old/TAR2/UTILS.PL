
:- discontiguous noop/0.

term_expansion(data=L,Stuff) :-
	fields2Stuff(fields(F,L),Stuff).

fields2Stuff(fields(F,L0),[fields(L)
                          ,(:- multifile(F/A))
                          ,(:- dynamic(F/A))
                          ,(:- discontiguous(F/A))
                          ,(row(Term) :- Term)
                          
                          ,trans(TransList,
                                      Term1)
                          |Changes]) :-
	numberOf(L0,L),
	length(L0,A),
	functor(Term,F,A),
	changes(L0,Changes),
	maplist(transOf,Changes,TransList0),
	sort(TransList0,TransList),
	maplist(arg(2),TransList,Vars),
	Term1 =.. [dat|Vars].

numberOf(L0,L) :- findall(X-N,(nth1(N,L0,Item),about(Item,_,X)),L).

about(+X,change,X) :- !.
about(X,fixed,X).

transOf(change(X),X=_).	

changes(L,All) :- bagof(One,L^changes1(L,One),All).

changes1(L,change(One)) :- member(X,L),about(X,change,One).

col(   F,N) :- fields(Fs), member(F-N,Fs).
colval(F,V) :- col(F,N),   numval(N,V).
numval(N,V) :- row(Term),  arg(N,Term,V).

colvals([],_).
colvals([Col=Val|Rest],X) :- col(Col,N), arg(N,X,Val), colvals(Rest,X).

range(F,Range) :- 
	col(F,N),
	F \= class,
	bagof(V, numval(N,V),Range0),
        msort(Range0,Range).

groups(L,N,Gs) :- 
	length(L,Size),
	N1 is max(integer(Size/N),1),
	groups(L,N1,1,blah,Gs).

groups([],_,_,_,[]).
groups(L,N,Id0,Last,Out) :- 
	head(N,L,Min,Max,Rest),!,
	G=group(Id0,Min,Max),
	Next=group(_,Min,Max),
	(G=Last
         ->  groups(Rest,N,Id0,Next,Out)
        ;    Id is Id0 + 1,
             Out=[G|Gs],
             groups(Rest,N,Id, Next,Gs)).

groups([Min|_],_,Id,_,[group(Id,Min,Inf)]) :- infinity(Inf).

head(1,[H|T],H,H,T) :- !.
head(N,In,Min,Max,Rest) :- 
	N0 is N - 1,
	length([Min|T],N0), 
	append([Min|T],[Max|Rest],In).

v2Band(R,V,N) :-
	bands(R,Bands),
	member(group(N,Top,Bottom),Bands),
	V < Bottom, V >= Top,!.

go :- granularity(N),go(N).

go(N) :- reset(N), \+ madness, time(run), report.

wme(bands(_,_)).
wme(rule(_,_,_,_)).
wme(n(_,_)).

:- index(rule(1,1,0)).

setup :- wme(X), functor(X,F,A), dynamic(F/A), fail.
setup.
reset(N) :- flag(id,_,0), flag(runs,_,0),zap, ranges(N).

zap :- wme(X), retractall(X),fail.
zap.

ranges(N) :- 
	range(F,Range),
	groups(Range,N,Gs), 
	format('% ~w has ~w ranges\n',[F,N]), 
        assert(bands(F,Gs)),
	fail.
ranges(_).

report :- reportBands, nl, flag(id,I,I),format('~w rules made\n',[I]).

reportBands :-
	bands(X,L),
	format('\n~w: ',[X]),
	member(group(_,A,B0),L),
	(infinity(B0) -> B = inf ; B = B0),
	format(' [~w .. ~w) ',[A,B]),
	fail.
reportBands.

madness :- 
	\+ row(_), 
	write('% E> no rows. Load a dataset.\n').
madness :- 
	\+ (row(X), now(X)),
	write('% E> no rule matches current situation. Relax now/1.\n').
madness :- 
	\+((row(X),now(X),\+ changes(X))),  
	write('% E> no rule satisfies the goal situation. Relax changes/1\n').
madness :- 
	\+((row(X),changes(X),now(X))), 
	write('% E> can''t get to the goal from here. Relax now.\n').

run :-
	bagof(C,run1(C),Cs0),
	msort(Cs0,Cs1),
	bins(Cs1,Cs2),
        maplist(asserts,Cs2,_).

asserts(Thing-N,_) :-
	currentDataSet(Id),
	trans(_,Meta,Thing),
	member(repeats=N,Meta),
	flag(id,I,I+1),
	assert(Thing).

run1(Clump) :-
	row(X),now(X),
	clumps(X,Clump).

bins([Num|Nums],Bins) :- 
	bins(Nums,[Num-1],Bins).

bins([],B,B).
bins([H|T],[H-N0|Rest],Bin) :- !,
	N is N0 + 1,
	bins(T,[H-N|Rest],Bin).
bins([H|T],Rest,Bin) :- 
	bins(T,[H-1|Rest],Bin).

clumps(X,I,Thing) :- 
	col(class,N),
	arg(N,X,Class),
	trans(L,Meta,Thing),
	members([dataset=I,class=Class],Meta),
	maplist(clumps1(X),L,_).

clumps1(X,C=Band,_) :-
	col(C,N),
	arg(N,X,V),
	v2Band(C,V,Band).

members([],_).
members([H|T],L) :- member(H,L),members(T,L).

:- dynamic dataSetId/1.
	
dataset(N) :- asserta(dataSetId(N)).

currentDataSetId(N) :- dataSetId(N),!.

%spit(_).
spit(X) :- write(X), flush_output(user).	
spitln(X) :- write(X), nl,flush_output(user).	
	
show(N) :- 0 is N mod 100,!,spit(N),nl.
show(_).

