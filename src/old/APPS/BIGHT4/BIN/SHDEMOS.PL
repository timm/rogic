:- discontiguous demo/1.

demo(compile) :-
	compile(qcm,'1simple').

demo(import) :- 
	wmeSetUp,
	my_file([data,dialects,qcm,'1simple'],'.pl',IN),
	my_file([data,dialects,qcm,'1simple'],'.d',OUT),
	old2New(qcm,IN,OUT).

demo(import(X)) :- 
	compile(qcm,X).

demo(import_go) :-
	demo(import),
	shmain(ExpName,Exp1,In,Exp2,Out,W),
	printl([exp=ExpName,exp1=Exp1,in=In,
	        exp2=Exp2,out=Out,w=W]).

demo(imports) :-
	tPrintOff,
	member(F,['1simple','2simstd', '3simpno', '4string', '6xshape',
	          '7twoin', '8twox', '9clumps', '10bath', '11twox', '12andas',
		  '13strin', '14std', '15sgt', '16sym', '17smy', '18smy',
		  '19able', '20ables', '21dis' ,'28sym'
	      ]),
        write(F),nl,
	demo(import(F)),
	fail.
demo(imports).

demo(proofs(X)) :- demo(validate(X)).

demo(newLoader(X)) :- demo(import(X)), qmod3(X).

demo(1)   :- demo(newLoader('1simple')).
demo(2)   :- demo(newLoader('2simstd')).
demo(3)   :- demo(newLoader('3simpno')).
demo(4)   :- demo(newLoader('4string')).
demo(4.1)   :- demo(newLoader('4strin1')).
demo(5)   :- demo(newLoader('5string')).
demo(6)   :- demo(newLoader('6xshape')).
demo(7)   :- demo(newLoader('7twoin')).
demo(8)   :- demo(newLoader('8twox')).
demo(9)   :- demo(newLoader('9clumps')).
demo(10)  :- demo(newLoader('10bath')).
demo(11)  :- demo(newLoader('11twox')).
demo(12)  :- demo(newLoader('12andas')).
demo(13)  :- demo(newLoader('13strin')). % should get same basic
                                        % results as demo12.
demo(14) :- demo(newLoader('14std')).
demo(15) :- demo(newLoader('15sgt')).
demo(16) :- demo(newLoader('16sym')). % some inexplicables
demo(17) :- demo(newLoader('17sym')). % all explicables
demo(18) :- demo(newLoader('18smy')). % all explicables
demo(19) :- demo(newLoader('19able')).
demo(20) :- demo(newLoader('20ables')). % same as 19
demo(21) :- demo(newLoader('21bucdis')).
demo(22) :- demo(newLoader('22wundl')).
demo(23) :- demo(newLoader('23wundd')).
demo(24) :- demo(newLoader('24rats')).
demo(25) :- demo(newLoader('25blump')).
demo(26) :- demo(newLoader('26ands')).
demo(27) :- demo(newLoader('27cach')).
demo(28) :- demo(newLoader('28sym')).
demo(29) :- demo(newLoader('29tidemo')).


%demo(5) :- demo(load('5stringn')). % not working for wierd reasons

demo(mrun(X,Repeats)) :-
	my_file([dialects,qcm,mutations,X], '.net', File),
	wmeClear,
	write('% loading...'),
	load_dialect(qcm),
	my_consult(File),
	write(' running...'),
	tPrintOff,
	watch_it_run_random(slow,Repeats,_),
	fail.
demo(mrun(_,_)).

%XXX to do: time cut off

demo(load(X)) :- demo(load(X),fail).
demo(validate(X)) :- time(demo(validate(X),fail)).
demo(fastValidate(X)) :-
	noprotocol,
	theory_file(qcm,X,'.out',Out),	
	write('% '),print(logFile(X)),nl,
	tPrintOff,
	%load_theory(qcm,X),
	protocol(Out),
	%b(_ExpName,Exp1,Exp2,_,_),
	watch_it_run(slow,_Exp1,_Exp2,_),
	fail.
demo(fastValidate(_)) :- noprotocol.

demo(fasterValidate(X)) :-
	noprotocol,	
	write('% '), print(logFile(X)),nl,
	protocol(X),
	tPrintOff,
	load_theory(qcm,X),
	data(_,Experiments,_Measurements),
	actions(Experiments,_Actions),
	removes([Exp1,Exp2],Experiments),
	watch_it_run(fast,Exp1,Exp2,_),
	fail.
demo(fasterValidate(_)) :- noprotocol.

demo(speed) :- 
	tPrintOn,
	load_theory(qcm,'28sym'),
	member(Exp2-Exp1,[[ptu,etherstr] - [twoDg],
	                  % magic numbers: 16/21.5- [1,34]
                          %                1,85.7,XXX
			  [diaz] - [msg,parg],
			  [diaz,chroniCdiaz] - [msg,parg],
			  [ptu,etherstr] - [chroniCinsulin],
			  [etherstr] - [gentle,yoh],
			  [ptu,etherstr] - [gentle,yoh] 
		      ]),
		      !,
		      print(1),nl,
		      watch_it_run(slow,Exp1,Exp2,_),
	fail.
demo(speed).


demo(ratsbug) :- demo(show(qcm,'24rats',[],[switch])).
demo(symbug) :- demo(show(qcm,'16sym',[dex],[dex,coldSwim])).

demo(show(Dialect,Th,X1,X2)) :-
        tPrintOff,
	load_theory(Dialect,Th),
	nl,
	write('----------------------'),
	Exp1 = X1,
	Exp2 = X2,
	shmain(ExpName,Exp1,In,Exp2,Out,Proofs,
               _,_,Time,Worlds),	
	t('v'),
	validate(Worlds,Proofs,BC,_BestWorlds),
	length(Worlds,AllW),
	runtimeReport([exp=ExpName,exp1=Exp1,exp2=Exp2,in=In,
	        out=Out,  %proofs=Proofs,
                time=Time,allWorlds=AllW,cover=BC]),
	true.




demo(speed1) :- 
	tPrintOn,
	load_theory(qcm,'28sym'),
	data(_,Experiments,_Measurements),
	actions(Experiments,_Actions),
	removes([Exp1,Exp2],Experiments),
	!,
		      print(1),nl,
		      watch_it_run(fast,Exp1,Exp2,_),
	fail.
demo(speed1).



demo(validate(X),Then) :-
        tPrintOff,
	load_theory(qcm,X),
	nl,
	write('----------------------'),
	shmain(ExpName,Exp1,In,Exp2,Out,Proofs,
               _,_,Time,Worlds),	
	t('v'),
	validate(Worlds,Proofs,_,BestWorlds),
	length(Worlds,AllW),
	runtimeReport([exp=ExpName,exp1=Exp1,exp2=Exp2,in=In,
	        out=Out,  proofs=Proofs,
                time=Time,allWorlds=AllW,cover=BestWorlds]),
	nl, write('========================================================'), nl,
	Then,
	!.
demo(validate(_),_).

demo(load(X),Then) :-
	tPrintOn,
	load_theory(qcm,X),
	shmain(ExpName,Exp1,In,Exp2,Out,Proofs,_,_,Time,W),
	runtimeReport([exp=ExpName,exp1=Exp1,in=In,
	        exp2=Exp2,out=Out,proofs=Proofs,time=Time,w=W]),
	Then,
	!.
demo(load(_),_).

demo(mutateN) :-
	demo(mutateN('28sym',The-_,G)), print(The), tab(2), print(G), fail.
demo(mutateN).

demo(mutateB) :-
	demo(mutateB('28sym',The-_,G)), print(The), tab(2), print(G), fail.
demo(mutateB).

demo(mutateN(X,The-Net,G)) :-
	between(1,4,_),
	member(NFactor,[1,1.5,2,3,6,7,8]), %2,3,4,5,6]),
	BFactor=1,
	nl,
	print(n(NFactor)),write(' '), print(b(BFactor)), write(' '),
	demo(mutate(X,NFactor,BFactor,The-Net,G)).

demo(mutateB(X,The-Net,G)) :-
	NFactor=1,	
	member(BFactor,[1.25,1.5,1.75,2,2.25,2.5,2.75,3]),
	nl,
	print(n(NFactor)),write(' '), print(b(BFactor)), write(' '),
	demo(mutate(X,NFactor,BFactor,The-Net,G)).


demo(mutate(X,N,B,The-Net,graph(E - F))) :-
	load_theory(qcm,X), 
	theory_file(qcm,X,'.the',Y),
	mutate(X,qcm,Y,N,B,The,Net,E,F).

demo(mutates) :-
	member(F,['1simple','2simstd', '3simpno', '4string', '6xshape',
	          '7twoin', '8twox', '9clumps', '10bath', '11twox', '12andas',
		  '13strin', '14std', '15sgt', '16sym', %'17smy', 
			'18smy',
		  '19able', '20ables' %, '21dis' % , '28sym'
	      ]),
	demo(mutate(F)),
	pause,
	fail.
demo(mutates).

countTypes([],_,0).
countTypes([_ = Type|Items],Type,N) :- !,
	countTypes(Items,Type,N0),
	N is N0 + 1.
countTypes([_|Items],Type,N) :-
	countTypes(Items,Type,N).

qmod3(X) :- demo(fastValidate(X)).

runtimeReport(Items) :-
	nl,
	member(Item,Items),
	runtimeReport1(Item),
        fail.
runtimeReport(_).

runtimeReport1(cover=Worlds) :- !,
	%spy(outs),
	outs(All),
	set_size(All,Outs),
	nth(Worlds,N/World),
	cover(World,Outs,Covered0,BestCover),
	vertexIdsToVertexNames(Covered0,Covered),
	format('world #~p, cover=~3p% : ~p~n',[N,BestCover,Covered]).
	
runtimeReport1(w=Worlds) :- !, 
	nth(Worlds,N/World),
	edgesToVertices(World,Names),
	runtimeReport1(world(N)=Names).

runtimeReport1(proofs=Proofs) :- !, 
	printProofs(Proofs,1),!.

runtimeReport1(Field=Value) :-
	writef('%10l = %t\n',[Field,Value]).

xruntimeReport1(proofs=Proofs) :- !, 
	length(Proofs,N), runtimeReport1(nproofs = N).

printProofs([],_).
printProofs([Proof|Proofs],N) :-
%	print(Proof),nl,
	p(vertices,Proof,V0),
	p(type,Proof,Type),
	p(x,Proof,X0),
	p(ab,Proof,AB0),
	vertexIdsToVertexNames([X0|V0],[X|V]),
	vertexIdsToVertexNames(AB0,AB),
	writef('%10l = %t\n',[proof(N),X/Type]),
	writef('%r%t\n',[' ',13,ab=AB]),
	writef('%r%t\n',[' ',13,v=V]),
	N1 is N + 1,
	printProofs(Proofs,N1).

edgesToVertices(W,V) :-
	set_new(New),
	edgesToVertices1(W,New,V0),
	vertexIdsToVertexNames(V0,V).

edgesToVertices1([],V,V).
edgesToVertices1([E|ES],V0,V) :-
	e(E,From,To,_,_),
	(From > To -> Temp = [To,From] | Temp = [From,To]),
	set_union(Temp,V0,V1),
	edgesToVertices1(ES,V1,V).

vertexIdsToVertexNames([],[]).
vertexIdsToVertexNames([V|Vs],[Object=Value|Rest]) :-
	value(V,Object,Value),
	vertexIdsToVertexNames(Vs,Rest). 
	
proofStats(P, '0 / 0 - [0, 0] - []') :-  var(P),!.
proofStats([],'0 / 0 - [0, 0] - []') :-  !.
proofStats(Proofs,AboutString) :-
	proofSizes(Proofs,Sizes0),
	msort(Sizes0,Sizes),
	stats(Sizes,N,Min,Max,_Sum,AverageSize,Sd),
	sformat(AboutString,'~d/~1f/~1f-[~d,~d]-~q',[N,AverageSize,Sd,Min,Max,Sizes]).
proofSizes([],[]).
proofSizes([Proof|Proofs],[Size|Rest]) :-
	p(vertices,Proof,V),
	set_size(V,Size),
	proofSizes(Proofs,Rest).









































