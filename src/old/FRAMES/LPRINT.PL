:- ensure_loaded(plog).

lprint = l(list,isNumbered,itemPrefix,itemSuffix,
	   betweenString,beforeBanner,afterBanner,outFile).

%me(lprint).

lprint o b --> o k.
lprint o a --> o b.

lprint o init -->
	o [blah,list     = []
          ,outFile       = user
          ,isNumbered    = n
          ,itemPrefix    = ''
          ,itemSuffix    = ''
          ,betweenString = '\n'
          ,afterBanner   = '\n'
          ,beforeBanner  = '\n'
          ].

lprint o say(X) --> o X=Y,  {print(Y),nl}.
lprint o run    --> o [outFile=F,{tell(F)}, say(beforeBanner)].
lprint o go(L)  --> o [init,list := L, run].
lprint(line(L)) --> o [init
                      ,beforeBanner := ''
		      , afterBanner := ''
		      , betweenString is ','
		      ,list := L
		      ,run].

lprint o htmlHeader(Title) -->
	{sformat(String,'<html><title>~w</title><body><h1>~w</h1>
	                <ul><li>',
                 [Title,Title])},
	o beforeBanner := String.

lprint(line(L)) :- lprint(line(L),_,_).
lprint(L)       :- lprint(go(L),_,_).