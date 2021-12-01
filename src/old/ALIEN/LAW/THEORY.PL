% types
* boolean are oneOf = [t,f].
* priors are oneOf = [lots,some,none].

% stuff required by system
* authors are [groups = [prosecute
                        ,defend
                        ]
	      ,persons= [tim = 'tim@menzies.com'
	                ,tom = 'tom@menzies.com'
                        ]
              ,members= [prosecute = [tim]
	                ,defend    = [tom]
              ]         ].

% define variables
* numeric are [age].
* priors are  [convictions].
* boolean are [guilty
              ,infant
              ,jail
	      ,legally_responsible
	      ,means 
	      ,moron
	      ,motive
	      ,opportunity
	      ,witnesses
	      ].

% here are the ideas of the prosecution
* author = prosecute.
 
* 1 if   infant or moron  then not legally_responsible.
* 2 if   age > 7 then infant.
* 3 if   legally_responsible and guilty then jail.
* 4 if   guilty then jail.
* 5 if   motive and means and opportunity and witnesses 
    then guilty.

% here are the ideas of the defence.
* author = defence. 

* 6 if   guilty and not legally_responsible then not jail.
* 7 if   infant or moron  then not legally_responsible.
* 8 if   not convictions = lots then not guilty.
* 9 if   infant or moron  then  not legally_responsible.



