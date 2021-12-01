%%%% Pre-load actions %<
%%% Flags
:- multifile     option/2.
:- dynamic       option/2.
:- discontiguous option/2.
%>
%%% Hooks %<
term_expansion(A=B, []) :- set(A=B).
%>
