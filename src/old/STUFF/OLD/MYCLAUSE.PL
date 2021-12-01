% low-level SWI prolog hack
% predicate_property is SLOW.
% so i pre-compute and cache the built-ins

 otherKnownBuiltIns :-
        predicate_property(X,built_in),
	\+ knownBuiltIn(X),
	assert( knownBuiltIn(X)),
	fail.
 otherKnownBuiltIns.

 myclause(A, B) :-
        \+knownBuiltIn(A),
        clause(A, B).