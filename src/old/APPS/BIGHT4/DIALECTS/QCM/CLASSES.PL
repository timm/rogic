
% class(name,      shortName, positive,     neutral, negative, valuesAre). 
class(and,         a,         [t],          [],      [],       discrete).
class(measure,     m,         [up],         [std],   [down],   discrete).
class(event,       e,         [present],    [],      [absent], discrete).
class(eventChange, ec,        [arrived],    [],      [left],   discrete).
class(timeMeasure, tm,        [up],         [std],   [down],   discrete).
% Note only implemented time measures (events not included at this stage)

can_effect(X,X).
can_effect(event,and).
can_effect(eventChange,measure).
can_effect(eventChange,timeMeasure).
can_effect(measure,timeMeasure).
can_effect(timeMeasure,measure).

timeClass(timeMeasure).
timeClass(Name) :-
	class(Full, Name, _, _, _, _),
	timeClass(Full).
