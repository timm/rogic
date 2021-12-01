
%=head2 PadChars (right justify)

 padChars(default,X) :- right_justify(5,X).
 padChars(N,      X) :- right_justify(N,X).   

 right_justify(N,X) :-
    writeThing(X,Y,N1),
    Pad is N - N1,
    forall(between(1,Pad,_),put(32)),
    write(Y).

 writeThing(X,Y,L) :- 
    sformat(Y,'~w',[X]), 
    string_length(Y,L).

%=head2 charsPad (left justify)

 charsPad(default,X) :- left_justify(5,X).
 charsPad(N,      X) :- left_justify(N,X).

 left_justify(N,X) :-
    writeThing(X,Y,N1),
    Pad is N - N1,
    write(Y),
    forall(between(1,Pad,_),put(32)).

%=head2 Squiggles

 squiggle(default,X) :- squiggles(25,X).
 squiggle(N,      X) :- squiggles(N,X).

 squiggles(W,N) :-
    N1 is round(N/W),
    forall(between(1,N1,_),put(126)).
