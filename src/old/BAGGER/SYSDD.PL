
@boolean(f).
@boolean(t).
@list(L,N) :- 
	rnum(0,20,N),length(L,N).
@posint(A) :- 
	rnum(1,65535,A).
@string(A) :- rstring(A).
@sym(A) :- 
	rsym(A).

