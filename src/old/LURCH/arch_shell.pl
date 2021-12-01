term_expansion(W is X of Y,weight(W,X of Y)).
term_expansion(_ says B if C,(B :- C)).
goal_expansion(X and Y,(X,Y)).
goal_expansion(X or Y, (X;Y)). 
goal_expansion(X by Y of Z, (qualifier(X,W), Y of Z)) :- 
	qualifier(X,W).

% what is this about?

weights(X,N) :- weight(Tag,X),weight1(Tag,N),!.
weights(_,1).

weight1(veryCritical, 4).
weight1(critical,     2).

qualifier(unbroken, -1   ).
qualifier(unhurt,   -0.33).
qualifier(helped,    0.33).
qualifier(made,      1   ).


