:- op(1,fx,? ).
:- op(1,fx,!).
:- Common=(inits/2,show/1,db/1),
   (discontiguous Common),
   (multifile Common).

