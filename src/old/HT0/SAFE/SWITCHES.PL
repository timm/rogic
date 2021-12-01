must((X,Y)) :- !, must(X), must(Y).
must(X) :- X,!.
must(X) :- format(user_error,'%E> not ~p~n',[X]), halt.

might((X,Y)) :- !, might(X), might(Y).
might(X) :- X,!.
might(X) :- format(user_error,'%W> not ~p~n',[X]), fail.

commandLineArguments(Args) :-
    unix(argv(Args0)),
    append(_,[--|Args],Args0),
    !.
commandLineArguments([]).

switch([Switch|T]) :- 
	clause(com(Switch,_),_)
        ->  (com(Switch,_)
	    -> switch(T)
            ;  format('HT0: ~w broken~n',[Switch]))
        ;   (T=[V|Rest],
             clause(com(Switch,_,_),_)
            -> (com(Switch,V,_)
                -> switch(Rest)
                ; format('HT0: ~w broken~n',[Switch]))
            ;  format('HT0: ~w unknown~n',[Switch])).

switches :- commandLineArguments(Args), 
            switch(Args).

