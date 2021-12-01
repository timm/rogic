:- style_check(-singleton).

wme(object(Id,[Attributes|_])).
wme(rule(Head,[Goal|SubGoals])).
wme(conflict(Id1,i(Id1,Id2))).
wme(used(Id,rule-X)). 
wme(used(Id,object-X)). 
wme(used(Id,mutex)). 
wme(parent(X,Y)).
wme(set(Id,object-X)).
wme(i(Id1,Id2)).

:- style_check(+singleton).

is_wmes(X) :-	
	\+ bad_wme(X).
bad_wme(X) :- 
	member(Wme,X), 
	(\+ ground(Wme) 
	; \+ wme(Wme)),
        barph(['bad wme: [',Wme,']']),
	abort. 
	
