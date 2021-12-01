% wme stuff for ht6 
def(wme,o,[path      is []
          ,known     is []
          ,debug     is 1
          ,goals     is []
          ,maxProved is 0
          ,done      is []
          ,todo      is []
          ,tries1    is 4
          ,tries2    is 4
          ,best      is []
          ,inputs    is []
          ]).

o newPath  --> o reset(path).
o init  -->
	 o resetBeliefs,
	 o goals = G,
	 o done is [],
	 o todo is G.
o resetBeliefs -->
	o inputs=F0,
	{sort(F0,F)}, 
	 o known  is F.
o proved(P) -->
	o goals=G,
	o best=B,
	{intersection(B,G,P)}.
o maxxed -->
	o todo = [].
o spy(X=Y) --> 
	o debug=3, !, 
	o path=P,
	{numbervars((X=Y,P),0,_),
	forall(member(_,P),  write('.. ')), 
	print(?X=Y),nl}.
o spy(_) --> [].
o end(X) --> o debug=3,!,{print(X),nl,nl}.
o end(_) --> [].
o say(X) --> o debug=2,!,{write(X),nl}.
o say(_) --> [].
o shoutln(X) --> o debug=1,!,{write(X),nl}.
o shoutln(_) --> [].
o shout(X) --> o debug=1,!,{write(X)}.
o shout(_) --> [].
o nl     --> o debug=2,!,{nl}.
o nl     --> [].
o report --> o debug = 0,!.
o report -->
	o done=D, 
	o todo=T,	
	{length(D,L1)}, 
	o goals=G, 
	{length(G,L2), 
	X is round((L1*100)/L2), 
	format('~4P% ~5S\n',[X,X])}.

	
