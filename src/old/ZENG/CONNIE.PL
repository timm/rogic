/*rule has conditions
conditions are condition AND|OR|NOT conditions
condtion  are 	object WITH feature1 comparison value
			WITH feature2 comparison value

object:feature comp Value
object(Id)

	if
	then
	or
	and
	not
	with
	:
	< <= = >= > */

wme(inPrice(id,amount,itemId)).
wme(outPrice(id,type,itemId,amount)). % type = out or return
wme(bank(id,interestRate)).
wme(delivery(id,
	date,	% date is in days since
			% jan 1 1900
	quantity,
	what)).		% item id
wme(item(id,number,description,shortDescription)).

rule 	23
for 	detect
if	delivery 	with date=D1 
			with what=ID 			and
	item(ID)	with inPrice:amount=InPrice 	and
			with outPrice(OP):amount=OutPrice 
			with saleLineItem:sale:date=D2  
	bank		with interestRate=IR		and
	do		P is 	(OutPrice-InPrice)	-
				(InPrice*IR*(D2-D1))	
then	new(profile)	with amound=P.
		