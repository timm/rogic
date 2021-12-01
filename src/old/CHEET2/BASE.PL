% object=nothing+object(oid)
def(object,
	def(object,   % handle
	    object,   % functor
	    1,        % arity
	    [oid],    % fields
	    object(_) % empty
	)).

% fact=nothing+fact.
def(fact,
	def(fact,   % handle
	    fact,   % functor
	    0,      % arity
	    [],     % fields
	    fact    % empty
	)).

term_expansion((bone X :- Y), [bone(X), (X:- Y)]) :- !.
term_expansion((bone X --> Y),[bone(Head),
	                       (Head :- Body)]) :- !,
	expand_term((X --> Y),(Head :- Body)).
term_expansion((bone X),      [bone(X), X]).

base(handle,  X,Y,def(X,A,B,C,D),def(Y,A,B,C,D)).
base(functor, X,Y,def(A,X,B,C,D),def(A,Y,B,C,D)).
base(arity,   X,Y,def(A,B,X,C,D),def(A,B,Y,C,D)).
base(fields,  X,Y,def(A,B,C,X,D),def(A,B,C,Y,D)).
base(blank,   X,Y,def(A,B,C,D,X),def(A,B,C,D,Y)).
bone join(        def(A,B,C,D,E),X,Y) :- 
           base(X,def(A,B,C,D,E),Y).

bone (:- discontiguous(base/3)).

bone goal_expansion(base(A,B,C),One) :- 
	optimizing(_),
	nonvar(A),
	clause(base(A,B,C),One).

bone goal_expansion(base((H ,T),A,C),(base(H,A,B),base(T,B,C))) :-
	nonvar(H).

bone goal_expansion(base(X,A,B,C,D),true) :-
	optimizing(2),
	nonvar(X),
	clause(base(X,A,B,C,D),true).

bone goal_expansion(base({X},C,C),X) :-	nonvar(X).
bone goal_expansion(base(X,C,C),!)   :- nonvar(X),X = !.

bone base(X,Y) :- base(X,Y,_).
bone base(fresh,_,F) :- base(_,_,_,_,F),!.
bone base(X <- Y) --> base(X,_,Y).
bone base(X =  Y) --> base(X,Y,Y).
bone base(X \=  Z) --> base(X,Y,Y), Y \= Z.
bone base(+X) --> base(X,Y,Z),{Z is Y + 1}.
bone base(-X) --> base(X,Y,Z),{Z is Y - 1}.

base(accept(Handle=Super+Wme)) -->
	base(fresh),
	{Wme =.. [Functor|Fields]},
	base(handle  <- Handle),
	base(functor <- Functor),
	base(fields  <- Fields),
	base(extend(Functor,Super,Fields)).

base(extend(Functor,Super,Fields0)) -->
	{def(Super,SuperDef),!,
         base(fields=SuperFields,SuperDef,_),
	 append(SuperFields,Fields0,Fields),
	 length(Fields,Arity),
	 functor(Blank,Functor,Arity)},
	 base(fields <- Fields),
	 base(arity  <- Arity),
	 base(blank  <- Blank).

base(extend(_,Super,_)) -->
	{oops(unknown(Super))}.
