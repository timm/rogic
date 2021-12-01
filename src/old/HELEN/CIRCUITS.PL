:- [helen].

circuit1 has battery=bat to switch=sw1 to bulb=b1 to
             (switch=sw2 to bulb=b2
	      by
	      bulb=b3
	      by
	      switch=sw3
	  ) to
	      battery=bat.

circuit2 has switch=s1 to bulb to switch=s1.
circuit3 has switch=s1 by switch=s2.

circuit4 has switch=sw1 to bulb=b1 to
             (switch=sw2 to bulb=b2
	      by
	      bulb=b3
	      by
	      switch=sw3
	  ).

do(circuit4,'circuit.data').
inits([sw1=on]).
