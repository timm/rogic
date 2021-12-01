%%%%Pre-load actions
%%%Operators
%Something to mark decisions we are considering
%<
:- op(1,xf,?).
%>
%Something to mark range declarations.
%<
:- op(701,xfx,of).
%>
%%%Flags
%<
:- discontiguous (of/3),(range/3),(goal/2).
:- dynamic (of/3),(range/3),(goal/2).
%>
%%%Hooks
%Define some expected value, and its associated
%range predicate.
%<
term_expansion(X of Y,Z) :- ofs(X of Y,Z).
%>
