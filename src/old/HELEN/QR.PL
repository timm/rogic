%blub(Volts,Amps,Shine)
bulb(_Any, 0, blown, dark,   0).
bulb(+,    +, ok,    light,  1).
bulb(-,    -, ok,    light,  1).
bulb(0,    0, ok,    dark,   0).

%switch(Volts,Amps,State)
switch(0,     _Any,on).
switch(_Any,  0,   off).

% battery
battery(-,-).

sum(+,+,+).    sum(+,0,+). sum(+,-,_Any).
sum(0,+,+).    sum(0,0,0). sum(0,-,-).
sum(-,+,_Any). sum(-,0,-). sum(-,-,-).
