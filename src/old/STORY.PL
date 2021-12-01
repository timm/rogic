% Generate a random story from productions of form Nonterminal=>Expression
:-op(600, xfy, =>).

story([]).
story(A * B):- story(A), story(B).
story(A  +  B):-makelist(A  +  B, L),
	length(L, M),
	P is random( M)+1,!,
	nth1(P, L, X), 
	story(X).
story(A):- A => B, !, story(B).
story(A):-atomic(A),  write(A), write(' ').

makelist(A  +  B, [A|C]):-makelist(B,C).
makelist(A, [A]).

gos(N) :- between(1,N,_), go, fail.
gos(_).

go:-story(start), nl,nl.
 
:- write('Enter go. to be told stories.'), nl.

start=>'Earth'*(catestrophe +  science +  attack +  collision).
catestrophe=>(('burns up' +  'freezes' +  'falls into the sun')
	*'and'
	*possible_megadeath
).
collision=>('is struck by a giant'
		*('comet' +  'asteroid' +  'cloud')
		*('but is saved.' +  'and is destroyed.' + saved
		 )
	 ).
possible_megadeath=> (     'everybody dies.'  
                           + ('some people'+ 'everybody' +  'almost everbody')
                     *('dies.'+rescued+saved)).
rescued=>('is rescued by'*sizes*extraterestrial*beings).
saved=>('but is saved by'*('earth'+extraterestrial)* 'scientists.'* 'The'*science).
science=>('scientists'*('invent' + 'discover')*sizes*beings*whichetc).
attack=>('is attacked by'*sizes*extraterestrial*beings*whichetc).
sizes=>('tiny' + 'giant' + 'enormous').
extraterestrial=>('Martian' + 'Lunar' +  'ExtraGalactic').
beings=>('bugs' +  'reptiles' +  'blobs' + 'superbeings').
whichetc=>
('who'
*(wantwomen + 
	 ('are friendly'
	  *('.' + 
	   ('and'*(denoument + happyending)
           ) 
         ) + ( 
		('are friendly'*'but misunderstood' + 
		 'misunderstand us' + 
		 'understand us all too well' + 
		 hungry
		)
		*butetc
	      ) +  
	      (hungry * ('and eat us.'+denoument)
              )
	)
 )
).
hungry=> 'look upon us as a source of nourishment'.
wantwomen=>'want our women, and take a few and leave'.
butetc=>('and are' + 'and are not')*'radioactive'*'and'*try_to_kill.
killers=>(killer +  killer*'and'*killer ).
killer=>('a crowd of peasants' 
	+  'the Army'
	 +  'the Navy'
	 +  'the Air Force'
	 + 'the Marines'
	 +  'the Coast Guard'
	 + 'the Atom Bomb'
	).
try_to_kill=>(('can be killed by'*killers*'.') + 
		 ('can not be killed by'*killers*soetc)).
soetc=>('but they die from catching a cold.' + 
	'so they kill us.' + 
	'so they put us under a benign dictatorship.' + 
	'so they eat us.' + 
	('so scientists invent a weapon'
		*('which turns them into disgusting lumps' + 
		  'which kills them' + 
		  'which fails,'*soetc)
	) + 
	('But'*denoument)
).
denoument=>(('a cute little kid convinces them people are OK.' *ending) + 
	    ('a priest talks to them of God,'*ending) + 
	    ('they fall in love with this beautiful girl'
	     *(ending +  happyending)
	    )
	   ).
ending=>('and they die.' + 
	 'and they leave.' + 
	 'and they turn into disgusting lumps.'
	).
happyending=>'and they get married and live happily forever after'.

grammar:-Nonterminal=>Expansion,  write(Nonterminal), 
	 write(' ---> '), nl,  write('    '), write(Expansion), nl, nl,
	 fail.
:- write('Enter grammar. to list the rules generating the stories.'), nl.

