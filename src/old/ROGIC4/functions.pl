function(X,Y,Z) :- def(X,Y,Z),!.
function(X,X,t).

def(no ?X,    X, f).
def(X seems Y,X, Y).
