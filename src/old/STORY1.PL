% Generate a random story from productions of form Nonterminal=>Expression
:- op(1200, xfx, =>). 

story(X) :- 
	between(1,100,_),
	prove(X,5,Y,[]),
	writes(Y,60,0),nl,nl,
	fail.
story(_).

writes(L,Max) :- 
	writes(L,Max,0).

writes([],_,_).
writes([H|T],Max,Used) :-
	string_length(H,N),
	X is Used + N + 1,
	(X > Max
        -> nl,
	   writes([H|T],Max,0)
        ;  write(H), write(' '),
           writes(T,Max,X)).
 
prove(true,_)  --> !,[].
prove((A,B),N) --> !,prove(A,N),prove(B,N).
prove((A;B),N) --> !, 
	{one((A;B),X)},
	prove(X,N).
prove(A,_) --> 
	[A],
	{\+ clause(A,_)},!.
prove(A,N0) --> 
	{N0 > 0, 
	 N is N0 - 1, 
	 clause(A,B)}, 
        prove(B,N).

one(X,One) :-
	d2l(X,L),
	length(L,N), 
	Pos is random(N), 
	nth0(Pos,L,One).

d2l((X;Y0),[X|Y]) :- !, d2l(Y0,Y).
d2l(X,[X]).

term_expansion((A => B),(A :- B)).

%-----------------------------------------------------------------------

start       => 'Earth' , (catestrophe ;  science ;  attack ;  collision).
catestrophe => ('burns up' ;  'freezes' ;  'falls into the sun'),
	       and,
	       possible_megadeath.
collision   => 'is struck by a giant',
               (comet ;  asteroid ;  cloud),
               ('but is saved.' ;  'and is destroyed.' ; saved ).
possible_megadeath => 'everybody dies.'
                      ; ('some people'; everybody ;  'almost everbody'),
                        ('dies.';rescued;saved).
rescued  => 'is rescued by', sizes , extraterestrial ,beings.
saved    => 'but is saved by', 
            (earth;extraterestrial), 
            'scientists.', 'The',science.
science  => scientists,(invent ; discover),sizes,beings,whichetc.
attack   => 'is attacked by',sizes,extraterestrial,beings,whichetc.
sizes    => tiny ; giant ; enormous.
extraterestrial => 'Martian' ; 'Lunar' ;  'ExtraGalactic'.
beings   => bugs ;  reptiles ;  blobs ; superbeings.
whichetc => who ,(wantwomen ; 
	 		('are friendly'
	  		,('.' ; 
	  		 (and,(denoument ; happyending)
           		) 
         		) ; ( 
				('are friendly','but misunderstood' ; 
		 		'misunderstand us' ; 
		 		'understand us all too well' ; 
		 		hungry
				)
				,butetc
	      		     ) ;  
	                 (hungry , ('and eat us.';denoument)
                   )       )      ).
hungry    => 'look upon us as a source of nourishment'.
wantwomen => 'want our women, and take a few and leave'.
butetc    => ('and are' ; 'and are not'),'radioactive',and,try_to_kill.
killers   => killer ;  killer,and,killer.
killer    => 'a crowd of peasants' 
	     ;  'the Army'
	     ;  'the Navy'
	     ;  'the Air Force'
	     ;  'the Marines'
	     ;  'the Coast Guard'
	     ;  'the Atom Bomb'.
	
dot => '.'.

try_to_kill => 'can be killed by',killers,'.' 
               ; 'can not be killed by',killers,soetc.

soetc => 
            'but they die from catching a cold.' ; 
	       'so they kill us.' ; 
	       'so they put us under a benign dictatorship.' ; 
	       'so they eat us.' ; 
	       'so scientists invent a weapon',
		 ( 'which turns them into disgusting lumps'  
		 ; 'which kills them' 
		 ; 'which fails.',soetc)
	       ;'But',denoument.

denoument => 'a cute little kid convinces them people are OK.' ,ending 
	     ;'a priest talks to them of God,',ending 
	     ;'they fall in love with this beautiful girl',
	     (ending ;  happyending).
	   
ending => 'and they die.' 
	  ;'and they leave.' 
	  ;'and they turn into disgusting lumps.'.
	
happyending => 'and they get married and live happily forever after'.