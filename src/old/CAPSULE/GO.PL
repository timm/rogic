:- op(1,fx,? ).
:- op(1,fx,!).
:- op(1,fx,=).
:- Common=(inits/2,show/1,db/1,touch/5, new/2,wme/2),
   (discontiguous Common),
   (multifile Common).

:- [xpand,runtime].
