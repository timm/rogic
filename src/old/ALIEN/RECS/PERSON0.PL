:-dynamic person/4.
:-multifile person/4.
:-discontiguous person/4.
:-discontiguous person0/5.

person0(defaults, A, B,                  C, person(B, D, 0, [])).
person0(id,       A, B, person(A, C, D, E), person(B, C, D, E)).
person0(name,     A, B, person(C, A, D, E), person(C, B, D, E)).
person0(age,      A, B, person(C, D, A, E), person(C, D, B, E)).
person0(jobs,     A, B, person(C, D, E, A), person(C, D, E, B)).
person0(asList,   A, [id=B, name=C, age=D, jobs=E], 
                        person(B, C, D, E), person(B, C, D, E)).

blank(person, A, person(A, B, C, D)).

bridge(person(A, B, C, D), E, F, person(G, H, I, J), K) :-
        person0(E, F, K, person(A, B, C, D), person(G, H, I, J)).
