
%=head1 Set-up code

%=head2 Uses

  :- [io,random,meta].

%=head2 Operators

 :- op(1,xfx,[(!),(?),of]).

%=head2 Flags

  :- index(memo(1,1,0)).
  :- dynamic(memo/3).

%=head2 Hooks

  term_expansion(X of Type,X of Type) :- knownType(Type).

  term_expansion((Var ?X :- Body), (Var ?X :- Body)) :- knownVar(Var).
  term_expansion((Var ?X),         (Var ?X)        ) :- knownVar(Var).

