:- [ops].

rangeP(true, t).
rangeP(true, f).
rangeP(accident(peter, londonRoad), t).
rangeP(accident(peter, londonRoad), f).
rangeP(check(0), t).
rangeP(check(0), f).
rangeP(medicalEmergency(londonRoad), t).
rangeP(medicalEmergency(londonRoad), f).
rangeP(check(1), t).
rangeP(check(1), f).
rangeP(check(2), t).
rangeP(check(2), f).
rangeP(dispatchAmbulanceTo(londonRoad), t).
rangeP(dispatchAmbulanceTo(londonRoad), f).
rangeP(check(3), t).
rangeP(check(3), f).
rangeP(check(4), t).
rangeP(check(4), f).
rangeP(ambulanceAvailable, t).
rangeP(ambulanceAvailable, f).
rangeP(check(5), t).
rangeP(check(5), f).
rangeP(check(6), t).
rangeP(check(6), f).
rangeP(check(7), t).
rangeP(check(7), f).

oneOfP(boolean, [t, f]).

personP(bashar, 'ban@doc.ic.ac.uk').
personP(russo, 'ar3@doc.ic.ac.uk').

groupP(1).

personGroupP(1, bashar).
personGroupP(1, russo).


object(true).
object(accident(peter, londonRoad)).
object(check(0)).
object(medicalEmergency(londonRoad)).
object(check(1)).
object(check(2)).
object(dispatchAmbulanceTo(londonRoad)).
object(check(3)).
object(check(4)).
object(ambulanceAvailable).
object(check(5)).
object(check(6)).
object(check(7)).

statement(0, 0 if true then accident(peter, londonRoad)).
statement(1, 1 if not not accident(peter, londonRoad)then medicalEmergency(londonRoad)).
statement(2, 2 if not medicalEmergency(londonRoad)then not accident(peter, londonRoad)).
statement(3, 3 if not not medicalEmergency(londonRoad)then dispatchAmbulanceTo(londonRoad)).
statement(4, 4 if not dispatchAmbulanceTo(londonRoad)then not medicalEmergency(londonRoad)).
statement(5, 5 if not ambulanceAvailable then not dispatchAmbulanceTo(londonRoad)).
statement(6, 6 if not not dispatchAmbulanceTo(londonRoad)then ambulanceAvailable).
statement(7, 7 if true then not ambulanceAvailable).

accident(peter, londonRoad)@t(1)=t :-
	{1, 0, 1},
	true@t(1)=t.
true@t(1)=f :-
	{1, mt(0), 1},
	accident(peter, londonRoad)@t(1)=f.
medicalEmergency(londonRoad)@t(1)=t :-
	{1, 1, 1},
	accident(peter, londonRoad)@t(1)=t.
accident(peter, londonRoad)@t(1)=f :-
	{1, mt(1), 1},
	medicalEmergency(londonRoad)@t(1)=f.
accident(peter, londonRoad)@t(1)=f :-
	{1, 2, 1},
	medicalEmergency(londonRoad)@t(1)=f.
medicalEmergency(londonRoad)@t(1)=t :-
	{1, mt(2), 1},
	accident(peter, londonRoad)@t(1)=t.
dispatchAmbulanceTo(londonRoad)@t(1)=t :-
	{1, 3, 1},
	medicalEmergency(londonRoad)@t(1)=t.
medicalEmergency(londonRoad)@t(1)=f :-
	{1, mt(3), 1},
	dispatchAmbulanceTo(londonRoad)@t(1)=f.
medicalEmergency(londonRoad)@t(1)=f :-
	{1, 4, 1},
	dispatchAmbulanceTo(londonRoad)@t(1)=f.
dispatchAmbulanceTo(londonRoad)@t(1)=t :-
	{1, mt(4), 1},
	medicalEmergency(londonRoad)@t(1)=t.
dispatchAmbulanceTo(londonRoad)@t(1)=f :-
	{1, 5, 1},
	ambulanceAvailable@t(1)=f.
ambulanceAvailable@t(1)=t :-
	{1, mt(5), 1},
	dispatchAmbulanceTo(londonRoad)@t(1)=t.
ambulanceAvailable@t(1)=t :-
	{1, 6, 1},
	dispatchAmbulanceTo(londonRoad)@t(1)=t.
dispatchAmbulanceTo(londonRoad)@t(1)=f :-
	{1, mt(6), 1},
	ambulanceAvailable@t(1)=f.
ambulanceAvailable@t(1)=f :-
	{1, 7, 1},
	true@t(1)=t.
true@t(1)=f :-
	{1, mt(7), 1},
	ambulanceAvailable@t(1)=t.
