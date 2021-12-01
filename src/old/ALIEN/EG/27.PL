:- [lib/io,law/mercury].

go :- watch(go1).

go1 :- xpands(
	22 if not (a and b)
              or 
              not (l and k) 
           then m and not n or o,
	Out),
	portrays(Out).
