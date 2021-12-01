:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[bashar='ban@doc.ic.ac.uk', russo='ar3@doc.ic.ac.uk'], members=[1=[bashar, russo]]].
*boolean are[true].
*author=1.
*boolean are[accident(peter, londonRoad)].
*boolean are[check(0)].
*0 if true then accident(peter, londonRoad).
*mt(0)if not accident(peter, londonRoad)then not true.
*boolean are[medicalEmergency(londonRoad)].
*boolean are[check(1)].
*1 if accident(peter, londonRoad)then medicalEmergency(londonRoad).
*mt(1)if not medicalEmergency(londonRoad)then not accident(peter, londonRoad).
*boolean are[check(2)].
*2 if not medicalEmergency(londonRoad)then not accident(peter, londonRoad).
*mt(2)if accident(peter, londonRoad)then medicalEmergency(londonRoad).
*boolean are[dispatchAmbulanceTo(londonRoad)].
*boolean are[check(3)].
*3 if medicalEmergency(londonRoad)then dispatchAmbulanceTo(londonRoad).
*mt(3)if not dispatchAmbulanceTo(londonRoad)then not medicalEmergency(londonRoad).
*boolean are[check(4)].
*4 if not dispatchAmbulanceTo(londonRoad)then not medicalEmergency(londonRoad).
*mt(4)if medicalEmergency(londonRoad)then dispatchAmbulanceTo(londonRoad).
*boolean are[ambulanceAvailable].
*boolean are[check(5)].
*5 if not ambulanceAvailable then not dispatchAmbulanceTo(londonRoad).
*mt(5)if dispatchAmbulanceTo(londonRoad)then ambulanceAvailable.
*boolean are[check(6)].
*6 if dispatchAmbulanceTo(londonRoad)then ambulanceAvailable.
*mt(6)if not ambulanceAvailable then not dispatchAmbulanceTo(londonRoad).
*boolean are[check(7)].
*7 if true then not ambulanceAvailable.
*mt(7)if ambulanceAvailable then not true.

statement(0, 0 if true then accident(peter, londonRoad)).
statement(1, 1 if not not accident(peter, londonRoad)then medicalEmergency(londonRoad)).
statement(2, 2 if not medicalEmergency(londonRoad)then not accident(peter, londonRoad)).
statement(3, 3 if not not medicalEmergency(londonRoad)then dispatchAmbulanceTo(londonRoad)).
statement(4, 4 if not dispatchAmbulanceTo(londonRoad)then not medicalEmergency(londonRoad)).
statement(5, 5 if not ambulanceAvailable then not dispatchAmbulanceTo(londonRoad)).
statement(6, 6 if not not dispatchAmbulanceTo(londonRoad)then ambulanceAvailable).
statement(7, 7 if true then not ambulanceAvailable).
