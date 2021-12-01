%=head2 Known Type

  knownType(Type) :-
    clause(Type!_,_) -> true ; barphln(badType(T))..

%=head2 Known Var

  knownVar(Var) :- Var of Type, knownType(Type).

%=head2 C<good(Type,Old,New>: consistency check

%Currently, we don't have any knowledge of special types. So 
%something is consistent with something else if it matches to it.

  good(_Type,Out,Out).

%=head2 C<assume(Id,Value)>: declare that C<Id> has a C<Value>

%Helper- in the case where there is only one value for a type,
%then the type name is the value name.

  assume(Id,Value) :- assume(Id,Id,Value).

%Worker- if we have assumed it previously, then fail if the new C<Value>
%contradicts the old C<Value>. Else, generate a random new C<Value> for
%this C<Type> of thing..

  assume(Id,Value) :-
     Id of Type,
     hash_term(Id,Hash), 
     (memo(Hash,Id,Temp)
      -> good(Type,Temp,Value)
      ;  any(!(Type,Value)),
	 bassert(memo(Hash,Id,Value))).

%=head2 C<reset> the memos

%Wipe all the old memos, pick some new ones from the what-if ranges.

  reset :-
	retractall(memo(A,B,C,D)),
	forall(guessable(X,Y),(guess(X,Y), assume(X,Y))).

%=head2 C<Guess(Var,Value)>: draw C<Value> from C<Var>'s what-if range

  guess(X,Y) :- 
      guessable(X,Y), any(X?Y), X of T, (T!Y -> true;  burp(badValue(X?Y))).

%=head2 C<Guessable>

%Find variables with a defined what-if range

  guessable(X,Y) :- bagof(X?Y,clause(X?Y),L),member(X?Y,L).



