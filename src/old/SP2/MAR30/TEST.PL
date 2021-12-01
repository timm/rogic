/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * File          :                                                           *
 * By            :                                                           *
 * Last Modified :                                                           *
 * Content       :                                                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


 testin :- assert(aha).
 testout :- retract(aha).


testbound(t(N, T, U)) :-
	testbound0(t(N, T, U)),
	N = test.

testbound0(t(_, t, u)).