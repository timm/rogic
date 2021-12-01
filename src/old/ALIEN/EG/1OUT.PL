% input: person(name, age=0, jobs=[])
% output...
 
recordDefinition(person(name, age=0, jobs=[])).
:-dynamic person/4.
:-multifile person/4.
:-discontiguous person/4.
:-discontiguous person0/3.
blank(person, A, person(A, B, C, D)).
person0(defaults, A, person(B, C, 0, [])).
person0(id(A, B), person(A, C, D, E), person(B, C, D, E)).
person0(id(A), person(A, B, C, D), person(A, B, C, D)).
person0(name(A, B), person(C, A, D, E), person(C, B, D, E)).
person0(name(A), person(B, A, C, D), person(B, A, C, D)).
person0(age(A, B), person(C, D, A, E), person(C, D, B, E)).
person0(age(A), person(B, C, A, D), person(B, C, A, D)).
person0(jobs(A, B), person(C, D, E, A), person(C, D, E, B)).
person0(jobs(A), person(B, C, D, A), person(B, C, D, A)).
person0(asList([id=A, name=B, age=C, jobs=D]), person(A, B, C, D), person(A, B, C, D)).
bridge(person(A, B, C, D), E, person(F, G, H, I)) :-
        person0(E, person(A, B, C, D), person(F, G, H, I)).
