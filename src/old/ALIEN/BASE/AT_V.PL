% assertions about "person"s could potentially be asserted 
% in many places in many files
:-dynamic person/4.
:-multifile person/4.
:-discontiguous person/4.

% "person" accessors (called "at_person") can
% be made in many places
:-discontiguous at_person/5, at_person/3.

% these at_person/3 accessors let us match on a field
at_person(id, A, person(A, B, C, D)).
at_person(name, A, person(B, A, C, D)).
at_person(age, A, person(B, C, A, D)).
at_person(jobs, A, person(B, C, D, A)).

% these at_person/5 accessors let us match on a field
at_person(id, A, B, person(A, C, D, E), person(B, C, D, E)).
at_person(name, A, B, person(C, A, D, E), person(C, B, D, E)).
at_person(age, A, B, person(C, D, A, E), person(C, D, B, E)).
at_person(jobs, A, B, person(C, D, E, A), person(C, D, E, B)).

% these accesors let us create an empty person or
% a freshly initialised person
blank(person, person(A, B, C, D)).
new0(person, person(A, B, 0, [])).

% this bridge predicate lets other predicates talk to
% the at_person/5 accessors without having to know the
% magic symbol "at_person"
bridge(person(A, B, C, D), E, F, person(G, H, I, J), K) :-
        at_person(E, F, K, person(A, B, C, D), person(G, H, I, J)).



