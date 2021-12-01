% o - stuff to define the stats ADT

% define the stats record
stats = [min,max,bins,sum,sumSquares,size].

% shell tricks: should work for every applicatio
o(X,Y) :- o(X,Y,Y).
o(X=Y)        --> stats(X,Y,Y).
o(X is Y)     --> stats(X,_,Y).
o(X+ Inc)     --> o(X=Y), Z is Y + Inc, o(X is Z).
o(+X)         --> o(X+1).
o(show(Header))--> 
	format('\n--| ~w |------------\n',[Header]),
	o(X=Y),
	format('\t~w = ~w\n',[X,Y]),
	fail.
o(show(_)) --> [].

% stuff specific to the stats application
o(binAdd(X)) -->
	o(bins = Bin0), 
	{binAdd(X,Bin0,Bin)}, 
	o(bins is Bin).

o(init(N))      --> 
	o(sum is N),
        Ns is N * N,
	o(sumSquares is Ns), 
	o(min is N), 
	o(max is N), 
	o(bins is [N-1]), 
	o(size is 1).

o(average(A)) -->
	o(sum = Sum),
	o(size=Size),
	A is Sum/Size.

o(add(X)) -->
	o(min = Min0),
	Min is min(Min0,X),
	o(min is Min),
	o(binAdd(X)),
	o(+size),
	o(sum+X).

o(silly) --> o(sizesss=X),0 is X mod 2.

% some support code
binAdd(X,Bin0,[X-N|Bin]) :- oneLess(Bin0,X-N0,Bin),!,N is N0 + 1.
binAdd(X,Bin,[X-1|Bin]).


/*

1) In the current version, "add" is broken; e.g. "max", "sum", 
   "sumSquated" not updated everytime a new number is added. fix it

2) Add operation for  "variance" and "standard deviation":

   if size =1 
   then var=0, sd=0
   else	var is ((size * sumsquared) - (sum*sum))/(size*(size-1)),
        sd is sqrt(var)

3) Add an "adds" operation so we can bulk load data (e.g. so eg(1) can work

4) Give the current mean and stand deviation, add an operation to 
   return a value from that distribution (hint- see demo(3)). 

5) Add an operation "ok" to test the class invariant; 
   i.e. the current stats knowledge is ok. 

6) Add an operation to print the histogram (hint- see demo(1)) of the "bins".

7) Add code to ensure that all arguments passed in and stored are
   valid values

8,9) (Hardish) Add comments in the code for accessor.pl. Try to convince me that
    you know what this code does. your comments could use examples to show the 
    steps in the sub-goals.

10) (Harder- bonus marks) Generate a file containing a call graph 
    showing what operations inside
   "stats" call other operations. 

    The format of file:
    
    digraph G {
      "sd" -> "dssda";
      "dssda" -> "sasa";
      ...
    }

   Note that the nodes are any string you like surrounded by double rabbit ears.

   Hint: 
 
   % note- this code is incomplete
   calls(X) :-
        clause(X,Y),
        walk(Y,X).
  
   walk((A,B),Parent) :- !,
       walk(A,Parent),
       walk(B,Parent).
   walk(A,Parent) :- format('   "~w" -> "~w";\n',[Parent,A]).

11,12) (impossibly hard- but earns super bonus marks) 
   The following _should_ work but darn if I can get it to work:
  
   % super-optimization magic
   goal_expansion(stats(A,B,C,D,E),true) :-	
	optimizing,
        stats(A,B,C,D,E).

    Get it working! Check if it speeds things up (hint: demo(2))

*/
