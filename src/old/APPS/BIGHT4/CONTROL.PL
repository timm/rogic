

:-  
	[bin/system],
	unix(argv(Args0)),
	append(_,['-d',N|_],Args0),
	demo(N),
	halt.
