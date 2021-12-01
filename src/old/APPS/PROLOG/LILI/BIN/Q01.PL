% asume that the term has a unique read only i
% in arg1

term_expansion(def(Spec),All) :- dd(Spec,All).

% e.g. dd(emp(name,age,shoesize)).
dd(Spec, All) :-
	Spec =.. [Functor|Args],
	length(Args,Arity),
	About=about(Functor,Arity,Args),
        bagof(One,About^dd1(About,One),All). 

dd1(about(Functor,Arity,Args), Out) :-
	Inits=[name is Functor,arity is Arity,fields is Args],
	new0(class,Id,Inits,Class0,Id2Class),
	member(Out,[Class0,Class]).
	
dd1(about(Functor,Arity,_), classId2Term(Functor,Id,Term)) :-
	functor(Term,Functor,Arity),
	arg(1,Term,Id).
dd1(about(Functor,Arity,_), 
	(touch(Term0,Arg,Value0,Term,Value) :- Touch)) :-
	accessorPrimitive(Functor,Arity,Arg,Term0,Value0,
                                   Term, Value, Touch).
dd1(about(Functor,Arity,Args),Touch) :-
        nth1(Pos,Args,Arg),
	accessorPrimitive(Functor,Arity,Arg,Term0,Value0,
                                   Term, Value, Touch),
        copyArgs(Term0,Pos,Value0,Value,Term).
      
accessorPrimitive(Functor,Arity,Arg,Term0,Value0,Term,Value,Out) :-
	functor(Term0,Functor,Arity),
	functor(Term,Functor,Arity),
	internalPredicate(Functor,IName),
	Out =.. [IName,Arg,Value0,Value,Term0,Term].

internalPredicate(X,Y) :- concat(X,'_Wme',Y).

copyArgs(T0,Except,Old,New,T) :-
        T0 =.. [Functor|Args0],
        copyArgs1(Args0,1,Except,Old,New,Args),
        T  =.. [Functor|Args].

copyArgs1([],_,_,_,_,[]).
copyArgs1([Old|Args],Pos,Pos,Old,New,[New|Args]) :- !.
copyArgs1([Arg|Args0],Pos0,Except,Old,New,[Arg|Args]) :-
        Pos is Pos0+1,
        copyArgs1(Args0,Pos,Except,Old,New,Args).

classId2Term(Class,Id,Term) :-
	var(Term)
	->	classId2Term0(Class,Id,Term)
	;	functor(Term,Class,_),
		arg(1,Term,Id).

new(Class,Id,Inits) :-
	newTerm(Class,Id,One,Two),
	assert(One),
	assert(Two).

newTerm(Class,Inits,New) :-
	newTerm(Class,_,Inits, New,_).
newTerm(Class,Id,Inits, New,id1Class(Id,Class)) :-
	classId2Blank(Class,Id,New0),
	gensym(object,Id),
	o(Inits,New0,New).
	
describe(X) :-
	all
	o([class=X,self=S]),
	o(arity=Arity,Fields),
	functor(Term,X,Arity),
	accessorPrimitive(X,Arity,_,_,_,_,_,Accessor),
	member(Thing,	[blank(X,_)
			,object(X,_)
			,touch(Term,_,_,_,_)
			,Accessor
			]), nl,
	clause(Thing,Body),
	portray_clause(Thing :- Body).


% query system that uses the above

:- op(800,xfy,@).
:- op(850,xfx,has).
  
o(ToDo)    :- o(ToDo,_,_,_).
o(ToDo,In) :- o(ToDo,In,_,_).

% what about when we have it already?

query(Q)    :- query(Q,_).
query(Q,In) :- o(Q,In,_,_).

transaction(Q)    :- transaction(Q,_,_).
transaction(Q,In) :- transaction(Q,In,_).
transaction(Q,In,Out) :-
	o(Q,In,_,Terms),
	commit(Terms).

o(Class=Id has Actions,In,Terms,Out) :-
	classId2Term(Class,Id,In),	
	o1(Action,In,Out,[Id=In],Terms).

o1([],Term,Term, Wme,Wme).
o1([Action|Actions], Term0, Term,  Wme0, Wme) :- 
	o1(Action,   Term0, Term1, Wme0, Wme1), 
	o1(Actions,  Term1, Term,  Wme1, Wme).

o1(This is New,Term0, Term, Terms0, Terms) :-
	(This = (X=Old) 
	-> 	Field=X 
	;  	Field=This),
	touch(Term0,Field,Old,Term,New),
	arg(1,Term,Id),
	touch(Terms0,Id,_,Terms,New).
o1(Field@Actions,Term0,Term, Terms0,Terms) :-
	touch(Term0,Field,Old,Term,New),
	id2Object(Old,Class)
	->	Old=New,
		getJoinedTerm(Class,Old,Term1,Terms0,Terms1),
		o1(Actions,Term1,_,Terms1,Terms)
	;	o1(Actions,Old,New,Terms0,Terms).
o1(Field = X,Term, Term, Terms, Terms) :- 
	Field=self
	->	X = Term
	;	touch(Term,Field,Value,Term,Value).

getJoinedTerm(Class,Id,Term,Terms0,Terms) :-
	touch(Terms0,Id,Term,Terms,Term), !.
getJoinedTerm(Class,Id,Term,Terms0,[Id=Term|Terms0]) :-	
	classId2Term(Class,Id,Term).

commit(Terms) :-
	all
	member(Id=Term,Terms),
	\+ Term,
	functor(Term,F,A),
	functor(Doomed,F,A),
	arg(1,Doomed,Id),
	forget(Doomed),
	assert(Term).

% demo
def(emp(name,showsize,job)).
def(job(name,salary)).

demo(dd,asserts) :- 
	describe(emp), 
	describe(job),
	blank(emp,B),
	blank(job,J),
	forget(B),
	forget(J),
	new(job,manager,[name is manager, salary is 1000]),
	new(job,cook,[name is cook, salary is 200]),
	new(emp,timm,[name is timm, job is goto(manager)]),
	listing(job),
	listing(emp),
	o(timm@[job@name=N,name=Who]),
	print(timmJob(N)),
	print(timmName(Who)).


	

