
/*

=head1 Demo

After defining some example predicate such as: */

  egDemo :-
	forall(member(X,[i,love,prolog]),
	      format(' ~p\n',[X])). /*

Then also define a one-liner that wraps the example predicate
in a call to C<demo>. */

  egDemos :- demo(egDemo). /*

If executed, this generates the file C<egDemo.spy>:

=include egDemo.spy

Note that if it is planned to include demo output to a
pod file, like this one, then 
its good practice to print a leading
blank space before each line of output..

=head1 Source Code

C<Demo/1> runs a goal C<G> and catches the output to the file
C<G.spy>. Also, just so you know what is going on,
it runs the goal C<G> a second time and sends the output to the screen. */

 demo(G) :-
     sformat(Out,'~w.spy',G),
     sformat(Header,'\n %% ~w (output from '':- demos(~w).'')\n',[Out,G]),
     write(Header), 
     T1 is cputime,
     ignore(forall(G,true)),
     T2 is (cputime - T1),
     sformat(Footer,' %% runtime = ~w sec(s)',T2),
     write(Footer),
     freshFile(Out),
     tell(Out),
     write(Header),
     ignore(forall(G,true)),
     write(Footer),
     told. /*

C<Demo/1> needs a helper predicate. C<FreshFile/1>
makes sure that no one
else has scribbled, or is currently scribbling, on our output file. */

 freshFile(X) :- 
    (current_stream(X,_,S) -> close(S)       ; true),
    (exists_file(X)        -> delete_file(X) ; true).

%=include _footer