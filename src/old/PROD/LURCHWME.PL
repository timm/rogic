%%%% Working Memory
%<
wme(Term,Key,Value) :- whatevered(Term,Key,_,Value).
%>
%<
wmeNew(w([start],[])).
wmeNew(Inits,w([start],Inits)).
wmeHas(X,w(P,L0),w(P,[X|L])) :- less1(L0,X,L).
wmeAdd(X,w(P,L), w(P,[X|L])).
wmeHolds(w(_,L),L).
%wmePush(Step,w(P,L),w([Step|P],L)).
%wmePop(Step,w([_|P],L),w(P,L)).

%step(X,W0,W) :- wmePush(
%>
