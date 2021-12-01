:- [ops].

*boolean are oneOf=[t, f].
*authors are[groups=[1], persons=[bashar='ban@doc.ic.ac.uk', russo='ar3@doc.ic.ac.uk'], members=[1=[bashar, russo]]].
*boolean are[true].
*author=1.
*boolean are[accident(peter, londonRoad)].
*0 if true then accident(peter, londonRoad).
*boolean are[medicalEmergency(londonRoad)].
*1 if not not accident(peter, londonRoad)then medicalEmergency(londonRoad).
*2 if not medicalEmergency(londonRoad)then not accident(peter, londonRoad).
*boolean are[dispatchAmbulanceTo(londonRoad)].
*3 if not not medicalEmergency(londonRoad)then dispatchAmbulanceTo(londonRoad).
*4 if not dispatchAmbulanceTo(londonRoad)then not medicalEmergency(londonRoad).
*boolean are[ambulanceAvailable].
*5 if not ambulanceAvailable then not dispatchAmbulanceTo(londonRoad).
*6 if not not dispatchAmbulanceTo(londonRoad)then ambulanceAvailable.
*7 if true then not ambulanceAvailable.
