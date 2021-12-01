/*

=head1 Demos 

C<Demos/1> runs a goal C<G> and catches the output to the file
C<G.spy>. Also, just so you know what is going on,
it runs the goal C<G> a second time and sends the output to the screen.  */

 demos(G) :-
    sformat(Out,'~w.spy',G),
    freshFile(Out),
    tell(Out),
    format('% output from '':- demos(~w).''\n\n',G),
    T1 is cputime,
    ignore(forall(G,true)),
    T2 is (cputime - T1),
    format('\n% runtime = ~w sec(s)\n',[T2]),
    told,
    nl,write('\n%-------------------------------\n'),
    format('% output from '':- demos(~w).''\n',G),  
    ignore(forall(G,true)),
    format('\n% runtime = ~w sec(s)',[T2]). /*

C<Demos/1> needs a helper predicate. C<FreshFile/1> 
that makes sure that no one
else has scribbled, or is currently scribbling, on our output file. */

 freshFile(X) :- 
    (current_stream(X,_,S) -> close(S)       ; true),
    (exists_file(X)        -> delete_file(X) ; true). /*

Here's a gizmo to run the above for all known C<eg/1> 
predicates: */

egs :- forall(clause(eg(X),_),demos(eg(X))).
