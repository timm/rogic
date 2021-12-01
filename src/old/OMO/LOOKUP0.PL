
%=head2 Uses

  :- ensure_loaded([demos,maths]).

%=head2 Operators

  :- op(999,xfx,holds).
  :- op(1,  xfx, to).

%=head2 Flags

%Define a predicate for the lookup tables.

 :- discontiguous lookUp1/4.
 :- multifile lookUp1/4.
 :- index(lookUp1(1,1,1,0)).

%=head2 Hooks

%Tell the Prolog reader about our lookup tables.

 term_expansion(Table holds ColsRows , Out) :-
     xpandTable(Table holds ColsRows,Out).

