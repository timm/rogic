% bootstrapping knowledge needed for the 
% query system
% all query-able terms have

:- Things = (	idClass2Term0/3, 
		id2Class/2,     
		classId2blank/2,  
		touch/5
		),
   (multifile Things),
   (discontiguous Things).

% touching a list has a side-effect: moving the
% touched item to the front of list

touch([H|T],Field,Value0,[Field=Value|Out],Value) :- 
	oneLess([H|T],Field=Value0,Out).

% dd(class(id,name,arity,fields))
touch(class(Id,Name0,Arity0,Fields0),Field,Old,
      class(Id,Name, Arity, Field  ),New) :-
	class_wme(Field,Old,New, class(Id,Name0,Arity0,Fields0),
		                 class(Id,Name, Arity, Fields )).

classId2Term0(class,Id,class(Id,Name,Arity,Fields)) :-
	class(Id,Name,Arity,Fields).

classId2Blank(class,Id,class(Id,_Name,_Arity,_Fields)).

class_wme(id,     A0,A, class(A0,B, C, D), 
		       class(A, B, C, D)) :- A=A0.
class_wme(name,   B0,B, class(A, B0,C, D),  
		       class(A, B, C, D)).
class_wme(arity,  C0,C, class(A, B, C0,D), 
		       class(A, B, C, D)).
class_wme(fields, D0,D, class(A, B, C, D0), 
		       class(A, B, C, D)).
