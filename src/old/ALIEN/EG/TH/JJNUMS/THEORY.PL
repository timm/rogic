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
* numeric are [age,wieght,shoeSize].
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
 
* 1 if  wieght < 12 and infant or moron  then wieght is 23 . %and not legally_responsible.
* 2 if  age > 7 or age < 12 then infant.
* 3 if  shoeSize > 23 or shoeSize < 100 then shoeSize is 20.









