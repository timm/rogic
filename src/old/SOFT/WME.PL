/*

=head1 Working Memory Management

Assertions are hashed on some index.

Assertions are grouped into I<N1> numeric levels
and C<zap> can reset all working memory
elements from level C<N2> and above.

=head1 Header

=head2 Flags */

 :- dynamic(wme/3). /*

=head1 Body  */

  make(W) :- 
    wme(W,I,_), hash_term(I,H), assert(hashed(H,W)). /*

=head2 Finding WMEs */

 wmes(L) :- wmes(-1,L).
 wmes(N,All) :- 
    setof(L=wme(W,I,L), N^(wme(W,I,L),L>=N), Temp)
    -> maplist(arg(2),Temp,All)
    ;  All=[]. /*

=head2  Reset */

 reset :-  
    forall((wme(W,_,_),functor(W,F,A)), dynamic(F/A)). /*

=head2 Zap 

Zap from level C<N> and above. */

 zap :- zap(-1).
 zap(N) :-
    wmes(N,All),
    forall(member(wme(W,_,_),All), retractall(hashed(_,W))). /*

=head2 Report

Report upwards  from level C<N>. */

 report :- report(-1).
 report(N) :-
    wmes(N,All),
    member(wme(W,_,_),All),
    functor(W,F,A),
    format('% ~w\n',F/A),
    W,
    numbervars(W,0,_),
    format('~p.\n',W),
    fail.
 report(_). 


