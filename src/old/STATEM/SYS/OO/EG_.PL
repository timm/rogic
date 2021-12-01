date is t + [year,month,day].
person is t + [fname,lname,age].
eg is t + [dob,name,weight,rank] 
with stuff <-- fred with a <-- b.
with otherstuff <-- xx .
with happy(t).
with stuff <-- 
	(aa|ll),
	= VVV,
	{print(VVV),nl},
	not ff 
         -> bb=45,
	    mm@hello(X),
	    X@die ,
	    up@hello,!,
	    me@soemthing,
	    oo(X,hello)
         ; {cc},
	   ll:= 23\25.
with init <--
	{get_time(Time), 
	convert_time(Time,Y,Mn,D,_,_,_,_)},
	dob  := date@[year := Y, month:=Mn, day:=D],
	name:=person@[fname:='Menzies', lname:='Tim'],
	dob ~> Dob,
        weight:=23,
        rank := fred,
	rank := fred\john,
	=Me,
	{write(Me-Dob),nl}.
with this(1,2,3,4).
with this(A,1,B,y) <--
        {A=B,
        b(a,5,A),
        c},!,
        ({d} ->
                {e},
                fred + 1,
                fred > 10,
                tom = 23
         ;      Z is 1 + 1,
                f(Z,B)
         ),
        \+ ({a(a),
             l(1)},
             z + 1
            ),
         a + -1 ,
         {l(h)}.

db:person1 is t + [name,age,shoesize]. 

db:emp is person1 + [jobClass := 12].       
with init <-- up@init, 
           me@age := 23,
	   age@[a,v,d].


% tests oo(new(eg),init)
%       oo(new(db)





