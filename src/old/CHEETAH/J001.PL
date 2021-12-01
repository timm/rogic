% costs if true not propergating backwards

domain='europa submarine'.

%--| stakeholders |-------------------------
tim2=  [month=dec,day=31,year=2000
       ,elm='tim@menzies.com'].
jim2=  [month=dec,day=31,year=2000
       ,elm='martin.shephard@jpl.nasa.gov'].

%--| glossary |-----------------------------
known= [antannaeWorks
           ,batteryShort
           ,batteryWorks
           ,collision
           ,collisionTest
           ,communicationsWork
           ,corrision
	   ,experimentsPerformed
	   ,instrumentsWork
	   ,leakage
	   ,returnsData
	   ,true      
	  ].

%--| traditional rules |-----------------------------
tim2 says cost=0 and chances=1.

leakage            if not experimentsPerformed rand instrumentsWork.
returnsData        if not experimentsPerformed. 
batteryWorks       if experimentsPerformed.
%returnsData       if corrision.

not experimentsPerformed if true.

%--| actions that cost |-----------------------
tim2 says cost=22 and chances=1.
instrumentsWork    if true.

tim2 says cost=2 and chances=1.
corrision           if true.

% btw, if you dont tell me then all unknown 
% facts are true at cost=0 and chances=1

b/B :- 
	go(
	[],
	[returnsData=_,batteryWorks=_,leakage=_],
	B,
	X),
        o(results,X,_),
        o(show,X,_).
