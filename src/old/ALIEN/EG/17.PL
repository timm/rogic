:- +[lib/io,lib/graphs].

go :- watch(go1).

go1 :-
	G0=[a-[b]
	  ,b-[d,k]
	  ,c-[e]
	  ,d-[c,d]
	  ,e-[]
	  ,k-[c]
          ],
	warshall(G0,G),
	print(G), nl.
	
	
		
