:- [bnet,bnet_t4].

demo(X1,X2) :-
	p(used,[],X1),
	p(residualDefects,[muchDesign=yes],X2).

/*
Welcome to SWI-Prolog (Version 4.0.2)
Copyright (c) 1990-2000 University of Amsterdam. 
Copy policy: GPL-2 (see www.gnu.org)

For help, use ?- help(Topic). or ?- apropos(Word).

?- cd('c:/tim/src/pl/bayes').

Yes
?- [davedemo].
%  bnet compiled 0.00 sec, 16,424 bytes
%  bnet_t4 compiled 0.00 sec, 6,828 bytes
Warning: (c:/tim/src/pl/bayes/davedemo.pl:3):
        Singleton variables: [X1, X2]
% davedemo compiled 0.00 sec, 23,936 bytes

Yes
?- make.
%  bnet compiled 0.01 sec, 0 bytes
%  bnet_t4 compiled 0.00 sec, 0 bytes
% c:/tim/src/pl/bayes/davedemo.pl compiled 0.01 sec, 80 bytes

Yes
?- demo(X,Y).
ERROR: '.'/2: Type error: `[]' expected, found `[1]'
^  Exception: (10) _G16509 is[1, 1]*[[0.4936, 0.4936], [0.4936, 0.4936]] ? goals
     [10] _G16509 is[1, 1]*[[0.4936, 0.4936], [0.4936, 0.4936]]
      [9] multiply_corresp_elts([[1, 1], [1, 1]], [[[0.4936, 0.4936], [0.4936, 0.4936]], [[0.5064, 0.5064], [0.5064, 0.5064]]], [_G16509|_G16510])
      [7] p(residualDefects, [muchDesign=yes], _G193)
      [6] demo([0.85, 0.15], _G193)
      [1] '$toplevel'
^  Exception: (10) _G16509 is[1, 1]*[[0.4936, 0.4936], [0.4936, 0.4936]] ? creep
?-
	*/


	