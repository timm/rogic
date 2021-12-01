:- load_files([utils
	      ,dcgplus
	      ,accessor
	      ,demos
	      ],[silent(true)]).

% define the v record
wine = [brand,cost,maturity,bought].

% shell tricks
o(X,Y) :- o(X,Y,Y).

o(X=Y)       --> wine(X,Y,Y).
o(X is Y)    --> wine(X,_,Y).
o(init)      --> o(bought is n).
o(mature)    --> o(maturity=Y), Y > 100.
o(expensive) --> o(cost=Y),     Y > 10000.
o(buy)       --> o(bought is y).
o(show(Header))--> 
	format('\n--| ~w |------------\n',[Header]),
	o(X=Y),
	format('\t~w = ~w\n',[X,Y]),
	fail.
o(show(_)) --> [].

buyWine -->  
	o(mature), 
	\+ o(expensive),
	o(buy).

