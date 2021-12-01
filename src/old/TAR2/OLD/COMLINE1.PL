go :-
        current_prolog_flag(argv, All),
        append(_, [ -- | Mine], All), 
        -com(Mine,_,X),
        -com([run, q-_],X,_).
- X :- X.

showOptions :- 
	setof(One,showOptions1(One),All),
	say('usage:'),
	forall(member(_-L,All),say(L)).

showOptions1(Com-S) :-
          clause(com(Head,_,_),_),
	  nonvar(Head),
	  Head=(Com-Text),
          numbervars(Com,1,_),
	  sformat(S,'~10>    ~w',[Com,Text]).

showOptions1(X-S) :-
          com(X=_,_,_),
	  sformat(S,'~10>=X  ~w is X',[X,X]).



