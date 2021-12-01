
/*

=head2 C<lookup(+Table,+Row,+Column,-Value)>: find a value

Cell access can be via an exact match or
via a range query: */

 lookUp(T,X,Y,Out) :-
    lookUp1(T,R,C,Out),
    gt(X,R),
    gt(Y,C).

 gt(Value,X to Y) :- !, X =< Value, Value =< Y.
 gt(Value,Value). /*

=head2 C<defTable(+TabularData,-[Fact|Facts])>: define a table

Each Fact has the form C<lookUp1(Table, Row, Column,Value)>. */

  deftable(Table holds ColsRows,Out) :-
    nonvar(ColsRows),
    ColsRows = (Cols+Rows),
    lookUpTable(Table=Cols+Rows,Out). 

 lookUpTable(X,Out) :-
    bagof(Y,X^list2Relation1(X,Y),Out).

 list2Relation1(Table=Cols+Rows, lookUp1(Table,R,C,X)):-
    nth1(Pos,Cols,C),
    member([R|Cells],Rows),
    nth1(Pos,Cells,X),
    nonvar(X). /*

=head2 Demonstration code: */

 egLookUpDemo holds
    % age         weight
    % ----------  -------------------------------
                  [1 to 19, 20 to 50, 51 to inf]+
    [[ 0 to 20,        low,      low,       avg]
    ,[21 to 40,        low,      avg,      high]
    ,[41 to inf,       avg,     high,      high]
    ].

 eglookup :- 
    member(Age,[20,30,41]),
    member(Weight,[15,20,80]),
    lookUp(egLookUpDemo,Age,Weight,X),
    format('[age(~w),weight(~w)]= ~w\n',
           [Age,Weight,X]).

 eglookups :- demo(eglookup).

%=include eglookup.spy
