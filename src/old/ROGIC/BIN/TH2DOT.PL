vs(Vs) :- 
	setof(V,v(V),Vs).

v(V) :-
	thisIsWhatTheySaid(X,Y),
	all([X,Y],atom(Z),Z,All),
	member(V,All),
	\+ member(V,['.',[]]).

es(Es) :-
	setof(E,e(E),Es).

e(E)  :- 
	rule(X,Y),
	flag(and,A,A+1),
        e(Y,X,and(A),E).

rule(O,Body) :-
	clause(o(_,wme, _,_,_),o(hop(A of O = _, Body),_,_)),
	nonvar(A).

inRand(Z,X rand Y) :- !,(Z=X; inRand(Z,Y)).
inRand(X,X).

inRor(Z, X ror Y) :- !,(Z=X; inRor(Z,Y)).
inRor(X,X).

e(_  rand  _,Head,And,e(And,Head,'')).
e(X0 rand Y0,_   ,And,e(Thing,And,Type)) :- !,inRand(X,X0 rand Y0),xtt(X,Thing,Type).
e(X0  ror Y0,Head,_  ,e(Thing,Head,Type)):- !,inRor(X,X0  ror Y0),xtt(X,Thing,Type).
e(X,         Head,_  ,e(Thing,Head,Type)):- not(X= (_ rand _)),xtt(X,Thing,Type).

xtt(now of Thing =  1,                now(Thing), '+'   ) :- !.
xtt(now of Thing = -1,                now(Thing), '-') :- !.
xtt(direct(_,_)       o val of Thing = _,  Thing, '+'  ) :- !.
xtt(creator(_,_)      o val of Thing = _,  Thing, '+ +') :- !.
xtt(destroyer(_,_)    o val of Thing = _,  Thing, '+ -') :- !.
xtt(invcreator(_,_)   o val of Thing = _,  Thing, '- +') :- !.
xtt(invdestroyer(_,_) o val of Thing = _,  Thing, '- -') :- !.
xtt(inverse(_,_)      o val of Thing = _,  Thing, '-'  ) :- !.
xtt(Thing,                                 Thing, ''   ).

nodeit(and(X),_,_,and(X)) :- !,
	format('   "~p" [label=" AND ",shape=plaintext];\n',[and(X)]).
nodeit(A,In,_,A=B) :- 
	member(val  of A=B,In),!,
	format('   "~p" [label="~p",shape=box];\n',[A=B,A=B]).
nodeit(A,_,Goals,A=B) :-  
	member(val of A=B,Goals),!,
	(best(a(val,A,_,_,B))
        ->
	    format('   "~p" [label="~p",shape=ellipse];\n',[A=B,A=B])
	;   format('   "~p" [label="~p",style=filled,color=grey,shape=ellipse];\n',[A=B,A=B])).
nodeit(A,_,_,A=B) :-
	best(a(val,A,_,_,B)),!,
	format('   "~p" [label="~p=~p?"];\n',[A=B,A,B]).
nodeit(A,_,_,A).


draw(N) :-
	 dots(N).

dots(N) :- F=N,print(F),tell(F), dot1(F,N), told, sformat(S,'"c:\\program files\\graphviz\\bin\\dotty.exe" ~p',[F]), shell(S).
dot :- tmp_file(dot,F),dot(F,F), sformat(S,'dotty ~p',[F]), shell(S).
dot(F,H) :- tell(F),dot(H),told.
dot(H) :-
	dot1(H,_).

dot1(H,N) :-
	o new(ht0) o scenario(N,In,Goals),
	write('digraph g {
subgraph cluster0 {
label="'), write(H),write('";
node [fontsize=15,shape=plaintext];
'),
	es(Es),
	forall(member(e(X,Y,Type),Es),
	      (nodeit(X,In,Goals,X1),
	       nodeit(Y,In,Goals,Y1),
	       format('    "~w" -> "~w" [label="~a"];\n',[X1,Y1,Type]))),
	write('}
subgraph cluster1{ label="key"; "Inputs" [shape=box]; "Goal (proven)" [shape=ellipse]; "Goal (unproven)" [shape=ellipse,style=filled,color=gray];
}
}
'),
	!.
