%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Here is the example from Mitchell's book

% Training example
fact(on(obj1,obj2)).
fact(isa(obj1,box)).
fact(isa(obj2,endtable)).
fact(color(obj1,red)).
fact(color(obj2,blue)).
fact(volume(obj1,0.1)).
fact(density(obj1,0.1)).

% domain theory
1:: safe_to_stack(_,Y) <- unfragile(Y).
2:: safe_to_stack(X,Y) <- lighter(X,Y).
3:: lighter(X,Y) <- weight(X,WX) & weight(Y,WY) & WX<WY.
4:: weight(X,V*D) <- volume(X,V) & density(X,D).
5:: weight(X,5) <- isa(X,endtable).

built_in((_<_)).

% Example query:
% ? ebl(safe_to_stack(obj1,obj2),safe_to_stack(X,Y),true,B).
