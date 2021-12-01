% Pirate, a small OO case tool (Version 0.1)
% Application ... tut.pl
% Author ........ 
% Source ........ /home/timm/apps/pirate/demos/tut
% Date .......... 04/03/98 (Wednesday)

:- ['/home/timm/apps/pirate/pout/bin/pirate.pl'].
:- style_check(-atom).

&something be &something.
&type      be &something
	   does :test are of boolean.   % test applies the rule symbol

&boolean   be &type.
&string    be &type.
&atom      be &type.
&number    be &type.
&date      be &type.
&time      be &type.
 

:- viewpoint(connie(0.1)/timm).

&authorizationLevel be &something
	has :options are in (none,some,many,all).

&phone be &something
	has :county are of    &posInt
	has :area   are of    &posInt
	has :digits are in    0 to 99999999.

&posInt be &number
	has :$rule=posInt.

&person be &something
	has  :name    are of &string
	has  :address are of &string
	has  :phone   are of &phone       % note: relationship-ness is
                                          % when not a builtin
        has  :team    are of &person
                      are 0 to many.

&session be &something
	has :startDate            are of &date
	has :endDate              are of &date
	has :startTime            are of &time
	has :endTime              are of &time
	does :howManyOverInteval  are of &posInt
	does :howMuchOVerInterval are of &posInt.

&cashier be &something
	has :idNumber	          are of &posInt
	has :password             are of &string
	has :person               are of &person
	has :currentSession       are of &session
	has :authorizationLevel   are of &authorizationLevel
				  are maybe
	has :session              are of &session
			          are 1 to 1 .. many
	does :isAuthorized	  are of &boolean
	does :accessPerfOverInteval  
	does :howManyOverInterval are of &posInt
	does :howMuchOverInterval are of &posInt.

&store be &something
	has  :name
	has  :cashiers are many
	               are of &cashier
	does :getItemForUPC(upc are of &posint, fred are of &nurd) 
                       are of &item
	does :getCashierForNumber(&number) 	
                       are of &cashier.

&payment be &something
	has	:amount.

&cash be &payment
	has :cashTendered.

&sale be &something
	has :payments are 1 to many
		      are of &payment.
 
&qcmElement be &something        % new super-class
     has :timeLinkStatus=false are of &boolean
     has :timeLink             are of &delay.

&delay be &something
      has :duration=0 are in (0,1).

&change be &qcmElement
       has :value    are in (up,down,steady). % constraint rule

&tub be  &qcmElement
     has :inflow     are of &pipe       % is of class pipe
                     are many           % 1 .. many
     has :outflow    are of &pipe       % is of class pipe
                     are many           % 1 .. many
     has :state      are of &change.    % 1 .. 1

&pipe be  &something
     has :source     are of &tub        % 1 .. 1 to class tub
     has :sink       are of &tub        % 1 .. 1 to class tub
     has :influence  are of &effect     % 1 .. 1 to class effect
     has :controller are of &abler      % of class abler
                     are maybe          % 0 .. 1   
     has :mediater   are of &abler      % of class abler
                     are maybe.          % 0 .. 1.

&abler be &something
      has :owner are of &event.
&disabler be &abler.
&enabler  be &abler.

&compartment be &tub.
&measure     be &compartment.
&event       be &compartment.
&flow        be &tub
             has :controller are maybe
                             are of &compartment.
&effect be  &something
       has :symbol
       has :fromType    are of &tub
       has :toType      are of &tub
       has :synonym     are maybe.

&oneEffect be &effect
       has :cause1 are of &change has :effect1 are of &change.

&twoEffects be &effect
       has :cause1 are of &change has :effect1 are of &change
       has :cause2 are of &change has :effect2 are of &change.

&direct   be   &twoEffects
          but :symbol       = '++' 
          but :synonym      = 'encourages'
          but :cause1       = up       but :effect1  = up
          but :cause2       = down     but :effect2  = down.

&direct11   be   &twoEffects
          has :symbol       are of &number.

&inverse  be   &twoEffects	
          but :symbol       = '--'    
          but :synonym      = 'discourages'
          but :cause1       = up       but :effect1   = down
          but :cause2       = down     but :effect2   = up.

&creator  be   &oneEffect
          but :symbol       = '+-+'
	  but :cause1       = up       but :effect1    = up.

&destroyer be   &oneEffect
           but :symbol       = '+--'
  	   but :cause1       = up      but :effect1    = down.
 
