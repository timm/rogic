:- [lib/io,law/mercury].

go :- watch(go1).

go1 :- xpands(
	22 if not (a and b)
              and 
              not (l and k) 
           then m and not n or o,
	Out),
	portrays(Out).
