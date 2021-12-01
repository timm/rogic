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

returnsData        if experimentsPerformed and  
                      instrumentsWork and 
                      communicationsWork.
instrumentsWork    if batteryWorks.
communicationsWork if batteryWorks  rand  
                      antannaeWorks.
antannaeWorks      if no collisionTest.
batteryWorks       if no batteryShort.
batteryShort       if leakage.
leakage            if corrision.
leakage            if no collisionTest.

%--| occasional events |-----------------------
tim2 says cost=0 and chances=0.2.
collision          if true.
corrions           if true.

%--| actions that cost |-----------------------
tim2 says cost=1 and chances=1.
collisionTest      if true.

% btw, if you dont tell me then all unknown 
% facts are true at cost=0 and chances=1

b/B :- 
	go(
	[rotates=t,dd=t,aa=t],
	[returnsData= _],
	B,
	_).

