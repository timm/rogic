goal=[weight := 0,id,aov,proved,route].
	
goal+yeah(R) --> o proved := t, o route := R,  o incw.
goal+boo     --> o proved := f, o route := [], o decw.
goal+inc(X)  --> X is 1 + myrand(10^4)/10^6.
goal+incw    --> o inc(X), o weight + X.
goal+decw    --> o inc(X), o weight - X.