% 3 reservered primitive structures:
prim(error(_)). 
prim(new(_)). 
prim(int(_)).

% Y is of type X if its an error of type X ...
aSort(X, error(X)).
% ... or it has the form X(_)
aSort(X, Y) :- functor(Y,X,_).

% when reducing, just find the first one
r(X,Y)  :- r1(X,Y),!.

% never allow a variable
r0(X, error(var)) :- var(X).
% reducing a primitive just gives that primitive
r0(X,X) :- prim(X).
% empty is true for any new thing, false otherwise
r0(empty(new(_)),true).
r0(empty(_),     false).
% automatic error propergation:
%     reducing a structure that contains an error,
%     return an error of the right type
r0(X,error(Sort)) :-
	sub(X,error(_)),
	functor(X,F,_),
	returns(F,Sort).

% 2 adt patterns:
% #1... to reduce on some constructors "xxx" of arguments,
%       recurse the argument, then reduce the
%       constructor on that argument
pattern(recurse, r1(xxx(In),Out)) :- 
	r(In,Temp),
	r(xxx(Temp),Out).
% #2... if a constructor "xxx" access a primitive, flag
%       an error of the return type of that constructor
pattern(primAccessError, r1(xxx(In),error(What))):- 
	prim(In),
	returns(xxx,What).







