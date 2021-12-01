:-dynamic v/5.
:-multifile v/5.
:-discontiguous v/5.
:-discontiguous v0/5.

blank(v, A, v(A, B, C, D, E)).

v0(defaults, A, B, v(B, C, D, E, F), v(B, C, D, E, F)).
v0(id,       A, B, v(A, C, D, E, F), v(B, C, D, E, F)).
v0(attr,     A, B, v(C, A, D, E, F), v(C, B, D, E, F)).
v0(op,       A, B, v(C, D, A, E, F), v(C, D, B, E, F)).
v0(value,    A, B, v(C, D, E, A, F), v(C, D, E, B, F)).
v0(time,     A, B, v(C, D, E, F, A), v(C, D, E, F, B)).
v0(asList,   A, [id=B, attr=C, op=D, value=E, time=F], 
                   v(B, C, D, E, F), v(B, C, D, E, F)).

bridge(v(A, B, C, D, E), F, G, v(H, I, J, K, L), M) :-
	v0(F, G, M, v(A, B, C, D, E), v(H, I, J, K, L)).
