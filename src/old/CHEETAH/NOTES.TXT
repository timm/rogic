{X} :- load_files(X,[silent(true)]).

%%%%%%%%%%%%%%%%%%%%%
:- {sets}.

:- dynamic globalVar/2.
:- format_predicate('x',pblanks(_,_)).
:- format_predicate('>',padChars(_,_)).
:- format_predicate('<',charsPad(_,_)).
:- format_predicate('.',pdots(_,_)).
:- format_predicate('P',padChars(_,_)).
:- format_predicate('S',twiddle(_,_)).
:- {utils}.

%%%%%%%%%%%%%%%%%%%%%
:- multifile touch/3.

:- dynamic   label/2.


comb(ror).
comb(rany).
comb(rors).
comb(ors).
comb(and).
comb(rand).
comb(or).


:- {ops}.

%:- discontiguous if/2,says/2.
:- {pansion}.

%%%%%%%%%%%%%%%%%%%%%
:- {wme}.

%%%%%%%%%%%%%%%%%%%%%
:- arithmetic_function(rand/1).
:- arithmetic_function(r/0).
:- arithmetic_function(beta/1).
:- arithmetic_function(gamma/2).
:- arithmetic_function(range/3).
:- arithmetic_function(prob/1).
:- {random}.

%%%%%%%%%%%%%%%%%%%%%
:- dynamic computedRuleValue/3.

:- {do},{control}, {meta}, {features}.

%%%%%%%%%%%%%%%%%%%%%
:- 
	format('~s\n\n',["Welcome to CHEETAH (Version 0.1); 
Copyright (c) 2001 Tim Menzies (tim@menzies.com). 
Copy policy: GPL-2 (see www.gnu.org)
So, when can a few random peeks replace many hard stares?"]).

