fields(data, [+v         
	     ,+in        
	     ,noAlpha
	     ,noMean
	     ,+depth
	     ,andpAlpha
	     ,+andpMean
	     ,orpAlpha
	     ,+andfMean
	     ,+orpMean
	     ,time
	     ,isTree
	     ,av
	     ,n
	     ,class
	     ]).

granularity(5).

o(now) -->
	o(in > 200), o(orpMean in 8 .. 12), 
now(X) :-
	colvals([in=In,orpMean=Orp,depth=Depth],X),
	In > 200,Orp in 8 .. 12,
        Depth in  0.2 .. 0.7.

changes(X) :-
	colvals([v=V,orpMean=Orp],X),
	V > 500,
	Orp > 9.
	
  
