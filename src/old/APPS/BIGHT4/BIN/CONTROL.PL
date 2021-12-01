

go :-  
	[bin/system],
	unix(argv(Args0)),
	append(_,[--,'-d',N],Args0),
	demo(N).
