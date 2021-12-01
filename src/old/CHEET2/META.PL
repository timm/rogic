% accessors
magic((def/2,join/3,(<>)/3, (bone)/1,
      (base/3),wmeSize/3)).

:- magic(X),discontiguous(X), multifile(X).

:- dynamic optimizing/1.
optimizing(2).

:- op(1,   xfx, at  ).
:- op(700, xfx, <-  ).
:- op(999,  fy, <>  ).
:- op(999,  fx, bone).
:- op(999, xfx, if).
:- op(998, xfy, or).
:- op(998, xfy, ors).
:- op(998, xfy, rors).
:- op(998, xfy, ror).
:- op(998, xfy, rany).
:- op(995, xfy, and).
:- op(995, xfy, rand).
:- op(990,  fx, not).
:- op(990,  fx, no). %   = not all
:- op(990,  fx, yes). %  = all
:- op(990,  fx, all).
