pqtest :-
	randomList(10, 5, L),
	print(L), nl, nl,
	insertPQs(L,Q),
	removePQs(Q, L2),
	print(L2), nl.

pqtest0 :-
	L = [1-one
	    ,2-two
	    ,3-three
	    ,4-four
	    ,4-five
	    ,5-six
	    ,5-seven
	    ,6-eight
	    ,6-nine
	    ,7-ten
	    ,7-eleven
	    ],
	print(L), nl, nl,
	insertPQs(L,Q),
	removePQs(Q, L2),
	print(L2), nl.

pqtest1 :-
	L = [3-one
	    ,2-two
	    ,3-three
	    ,2-four
	    ,1-five
	    ,5-six
	    ,6-seven
	    ,1.1-eight
	    ],
	print(L), nl, nl,
	insertPQs(L,Q),
	removePQs(Q, L2),
	print(L2), nl.

pqtest2 :-
	L = [3-one
	    ,3-two
	    ,2-three
	    ,2-four
	    ,3-five
	    ,1-six
	    ,0-seven
	    ,1-eight
	    ],
	print(L), nl, nl,
	insertPQs(L, Q),
	removePQs(Q, L2),
	print(L2), nl.

pqtest4 :-
	L = [0-one
	    ,1-two
	    ,1-three
	    ,2-four
	    ,2-five
	    ,2-six
	    ,3-seven
	    ,3-eight
		,4-nine
		,4-ten
		,4-eleven
		,4-twelve
	    ],
	print(L), nl, nl,
	insertPQs(L,Q),
	removePQs(Q, L2),
	print(L2), nl, nl.

