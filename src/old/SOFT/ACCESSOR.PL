/*

=head1 Accessor

=head1 Header

=head2 Flags */

 :- discontiguos def/3.
 :- multifile def/3.
 :- index(def(1,1,0)).

  maxSwapSize(30). /*

=head2 Hooks */

 term_expansion(def(This,Fields),Out) :-
    accessors(def(This,Fields),Out). /*

=head1 Body */

  accessors(def(This,Fields),Out) :- 
    bagof(def(This,Field,Pos), Fields^nth1(Pos,Fields,Field),Out). /*

=head1 Footer

=head2 Start-ups */

  :- retractall(swap1(_,_,_,_,_)).
 
  swaps(swap1(N,Old,New,L0,L1)) :-
    maxSwapSize(Max),
    length(L0,Max),
    length(L1,Max),
    between(0,Max,N),
    length(B4,N),
    append(B4,[Old|Rest],L0),
    append(B4,[New|Rest],L1).
        
   :- forall(swaps(S),assert(S)).
  
