:- [timedd].

@boolean(B) % not- ehader msut always be var
      :- member(B,[f,t]).

@list(L,N) :- rnum(0,20,N),length(L,N).

@posint(A) :- 
	rnum(1,65535,A).

@string(A) :- rstring(A).
@sysArg(In=in, Name=name,Key=key,
        noop(In,Out)=filter,Out=out) :-
	var(In),
	var(Out),
	rsym(Name),
	@sysIndexList(Key).
@sysIndexList(L) :- 
	@sysList(L,4).
@sym(A) :- 
	rsym(A).

