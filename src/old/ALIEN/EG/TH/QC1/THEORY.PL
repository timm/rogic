* boolean are oneOf = [t,f].
* authors are [groups = [1],
               persons= [bashar = 'ban@doc.ic.ac.uk'
                        ,russo  = 'ar3@doc.ic.ac.uk'
                        ]
	      ,members= [1 = [bashar,russo]]].
* boolean are [true].
* author = 1.

% background knowledge
who(peter).
where(londonRoad).

% axioms
% note... all these horn clauses must go ground
accident(X,W)          :- who(X), where(W).
medicalEmergency(W)    :- where(W).
dispatchAmbulanceTo(W) :- where(W).
ambulanceAvailable.

% constraints
* accident(_,_) or false.
* not accident(_,Loc) or medicalEmergency(Loc).
* not medicalEmergency(Loc) or dispatchAmbulanceTo(Loc).
* ambulanceAvailable or not dispatchAmbulanceTo(_).
* not ambulanceAvailable or false.





