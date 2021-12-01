:- op(1001,fx,all).
all X :- X, fail.
all _.

%shout(_).
shout(X) :- write(user,' '),print(user,X),  flush_output(user).


