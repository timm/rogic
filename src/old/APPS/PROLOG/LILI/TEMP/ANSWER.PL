

ask(X,Y) :- 
	wmeGet(answer(X,Z)),
	!, 
	Y=Z.
ask(X,Y) :- 
	nl, 
	write(X), 
	write(' y/n/? [y] ?'), 
	get_single_char(Char), 
	(member(Char-Y,[10-y,121-y,110-n,63-'?'])
	->	assert(answer(X,Y))
	;	print(unknown(Char)),
		ask(X,Y)).

