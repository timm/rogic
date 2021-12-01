%%%% Pre-load actions  
%%% Operators
%How to access an  option:
%<
:- op(700,xfx, :=).
%>
/*
We also need a ``?'', but that is predefined,
in SWI-Prolog as {\tt op(500, fx, ?)}.
*/
%%% Flags
%Options are stored internally in {\tt option/2}
%facts.
%<
:- dynamic       option/2.
:- discontiguous option/2.
%>
%%% Hooks
%Options are set via a side effect of
%{\tt term_expansion/2}.
%<
term_expansion(A=B,[]) :- set(A=B).
%>
