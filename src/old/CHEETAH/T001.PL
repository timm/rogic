domain= 'tutorial e.g. 1'.
tim=    [month=jan,day=18,year=2000,elm='tim@menzies.com'].
known=  [
         baseball ,content ,enthusiasm, exercise ,football ,happy ,healthy
        ,likesSweat ,overweight ,rich ,running ,sick ,smoker ,swimming
        ,tranquil].

tim says cost    = 0  
    and  chances = 1.
r1 if  rich rors 
       healthy rors 
       content          then happy.
r2 if not tranquil      then rich.
r3 if tranquil          then content.
r4 if no sick           then healthy.
r5 if overweight        then sick.
r6 if no exercise       then overweight.
t7 if baseball rany 
     running   rany 
     swimming  rany 
     football           then exercise.

% each item costs, but has a one time only start up cost
tim says cost    = 1 to +4 
    and  chances = +0 to 1.
r8  if enthusiasm rand 
      likesSweat        then baseball.
r9  if enthusiasm rand 
       likesSweat       then running.
r10 if enthusiasm rand 
       likesSweat       then football.


r11 if enthusiasm rand 
       not likesSweat   then swimming.

% cost of enthusiasm
tim says cost    = 2 
    and  chances = 1.
r12 if true             then enthusiasm.


run :- prove(happy).

runs :- time(proves(1000,'eg.names','eg.data',
             [goal     =happy
	     ,options  =[swimming,football,running,baseball]
             ,debating =[r8,r9,r10,r11]
             ,costT=5
             ,chancesT=0.85
             ])).

  
      


