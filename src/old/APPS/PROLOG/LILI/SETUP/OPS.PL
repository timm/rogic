:- op(1200,xfx, <--),
   op(1150,fx,  note),
   op(999, xfx, isa),
   op(998, xfy, with),
   op(998, xfy, but),
   op(990, xfx, if),
   op(899, xfy, or),
   op(898, xfy, and).
  

:- Things=      (parent/2
		, rule/2
		, used/2
		, set/2
		, i/2
		, opp/2
		, mutex/2
		, specialise/2
		),
	(multifile Things),
	(discontiguous Things),
	(dynamic Things).

:- dynamic literal/2.