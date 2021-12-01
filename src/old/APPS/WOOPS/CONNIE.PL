% magic first line
:- [woops].

:- newView(connie,timm).

%%%% change next line to appliciation name %%%%
'Connie''s Convenience Store' 
<>	isa  <>[viewPoint]
<>	with <>[stakeHolder=
		%%%% change next line to your group's name %%%%
		'timm'
	       ]
.  

authorizationLevel 
<>	isa   <>[any]
<> with <>[options = [none,some,many,all] : set]
.
phone 
<>	isa   <>[any]
<>	with  <>[country : posInt
		,area    : posInt
		,digits  : posInt
		]
.
person 	
<>	isa   <>[any]
<> 	with  <>[name 	 : string 
		,address : address 
		]
<>	uses  <>[1 - 1 : phone].
 
session 
<>	isa   <>[any]
<>	with  <>[startDate : date
		,endDate   : date
		,startTime : time
		,endTime   : time
		]
<>	does  <>[howManyOverInterval : number
		,howMuchOVerInterval : number
		]
.
cashier 
<>	isa   <>[any]
<>	with  <>[idNumber	: posInt
		,password	: string
		]
<>	does  <>[isAuthorized	: boolean
		,accessPerfOverInteval 
		,howManyOverInterval
		,howMuchOverInterval
		]
<>	uses  <>[1 - 1    	: person 
		,1 - 1    	: currentSession
		,1 - 0..1 	: authorizationLevel
		,1 - 1..many 	: session
		]
.
store 
<>	isa   <>[any]
<>	with  <>[name]
<>	does  <>[getItemForUPC(upc)		: item
		,getCashierForNumber(number) 	: cashier
		]
<>	has   <>[1 - many  : cashier]
.
payment
<>	isa  <>[abstract]
<>	with <>[amount]
.
cash
<> 	isa  <>[payment]
<>	with <>[cashTendered]
.

sale 
<>	isa   <>[any]
<>	uses <> [1 - many : payment].

% magic last line.
%:- check,browse.
