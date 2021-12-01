:- [adt, always].

% signatures
* new(list)      = list. % jack... where is new defined?
* cons(int,list) = list.
* head(list)     = int.
* tail(list)     = list.
* empty(list)    = bool.
* sum(list)      = int.

% axioms
% important: 1) all recursive calls are to r/2, NOT r1/2
%            2) fist r1 clause MUST call r0
%            3) immediately after the last r1/2 clause, you
%               must call the patterns
%            4) signatures must be defined above r1.

r1(X,Y)                              :- r0(X,Y).

r1(cons(X,L0),        cons(X,L))     :- aSort(int,X), r(L0,L).
r1(head(cons(X0,_)),  X)             :- r(X0,X).
r1(tail(new(list)),   new(list)).
r1(tail(cons(_,L0)),  L)             :- r(L0,L).
r1(sum(new(list)),    0).
r1(sum(int(X)),       X).
r1(sum(cons(X0,L0)),  Y)  :- r(cons(X0,L0), cons(X1,L1)), r(sum(X1),X2), 
                             r(sum(L1),L2), Y is X2 + L2.

:- usePattern(primAccessError,X=[head,tail],     [xxx/X]).
:- usePattern(recurse,        X=[sum,head,tail], [xxx/X]).

% this next line is just for demo purposes. you can comment it out.
:- listing(r),listing(r0),listing(r1).

% test cases: note the 2 new reserved words: new(list) and int(N)
test(a,head(
	tail(
           cons(int(3),
                tail(cons(int(5),new(list)))))),
     error(int)
    ).
test(b,head(cons(int(1),new(list))),
     int(1)
    ).
test(c,tail(cons(int(1),new(list))),
     new(list)
    ).
test(d,sum(cons(int(1),cons(int(2),cons(int(4),new(list))))),
     7
    ).
test(e,som(cons(int(1),cons(int(2),cons(int(4),new(list))))),
     r2Failure
    ).
test(f,sum(cons(int(1),cons(int(2),cons(int(4),new(list))))),
     shouldBeAFailure
    ).

% this next line automatically runs the above tests and checks if
% they generate the required output.  you can comment it out.
:- tests.




