% what about the negation of values?
io(X at T=Y,X,T,Y) :- !.
io(X,       X,_,t).

cache(X) :- io(X,_,_,_).

mine=yours + a(path,known).

mine(zero) -->
	mine(path <- []),
	yours(zero).

opt=fact+ opt(todo,  % things to prove
	      tried, % things we tried
	      size,  % length of items
	      order, % random or l2r
	      max,   % max # of things to want to prove
	      min,   % min # of things you have to prove
	      isSome, % true if this is a some.
	      %%%%
	      done,  % n things proved to date
	      failed% number of faileds seen to date
	      
	      ).

% all,

opt((resetSome)) --> reset_some.
opt((reset))      -->
	opt((failed <- 0, done <- 0,tried=T, todo <- T,resetSome)).

reset_some --> opt((isSome=t,!,want(some))).
reset_some --> [].

opt((random))     --> opt((order <- random)).
opt((l2r))        --> opt((order <- l2r)).
opt((need(some))) --> opt((size = S,{Todo is random(S) + 1},min <- Todo)).
opt((need(one)))  --> opt((min <- 1)).
opt((need(all)))  --> opt((size = S, min <- S)).
 
opt((want(all)))  -->  opt((size=S, max <- S)).
opt((want(some))) --> opt((isSome <- t, size=S,
	                  {Todo is random(S) + 1},
			  max <- Todo)).
opt((want(one)))  --> opt((max <- 1)).

opt((fresh(L)))   --> opt((fresh,
	                   {length(L,N)},
	                   done   <- 0,
			   failed <- 0,
			   todo  <- L,
			   tried <- [],
			   size   <- N,
			   l2r,
			   isSome <- f,
			   need(one),
			   want(one))).

opt((one  * L))   --> opt((fresh(L))).
opt((and  * L))   --> opt((fresh(L),  want(all),  need(all))).
opt((or   * L))   --> opt((fresh(L),  want(one),  need(one))).
opt((ors  * L))   --> opt((or*L,      want(all),  need(one))). 
opt((any  * L))   --> opt((fresh(L),  want(some), need(one))).

opt((rand * L))   --> opt((and*L,     random)).
opt((rors * L))   --> opt((ors*L,     random)).
opt((rany * L))   --> opt((any*L,     random)).
opt((rand * L))   --> opt((or *L,     random)).

pop_opt(random,Old,    I,New) --> {rone(Old,I,New)}.
pop_opt(l2r,   [I|New],I,New).

opt((pop(I))) -->
	opt(todo,Old,New),
	opt((order=O)),
	{pop_opt(O,Old,I,New)},
	opt(tried,Old,[I|New]).

run --> opt((done=D,  max=M)), {M >= D},!.
run --> opt((size=S, failed=F, min=M)),{F > S - M,!,fail}.
run --> opt(pop(I)),
	({prove(I)} -> opt(+done),{run} ; opt(+failed),{run}).


	     
%