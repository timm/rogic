:- Stuff = ('#known'/2, oo/2, oo/3),
   (multifile     Stuff),
   (discontiguous Stuff).

:- index('#known'(1,1)).

% b_     = blank   = emp(A,B,C)
% f_     = fields  = [id:number,name:string,shoeSize:number]
% i_     = inits   = [id := 0, shoeSoze :=0
% self_  = class   = emp
% id_    = id      = A
% acc_     = type 
%          accessor = emp_
% p_     = parent
%          accessor  = person_
% nth_   = nth place = B
% x_     = nth name  = name
% xIs_   = nth name 
%          changeer  = name

pattern(oo(spread), (:- discontiguous acc_/3)).
%%
pattern(oo(query), acc_(Com,T)) :- acc_(Com,T,_).
%%
pattern(oo(bridge), oo(new(self_),M)) :-
	acc_('#init0',b_,Temp),
	acc_(M,Temp,_).
pattern(oo(bridge), oo(self_,M))  :- 
	acc_(get(_),_,In),
	oo(In,M,_).
pattern(oo(bridge), oo(b_,M)) :- acc_(M,b_,_).

pattern(oo(bridge), oo(new(self_),M,Out)) :-
	acc_('#init0',b_,Temp),
	acc_(M,Temp,Out).
pattern(oo(bridge), oo(self_,M,Out))  :- 
	acc_(get(_),_,In),
	acc_(M,In,Out).
pattern(oo(bridge), oo(b_,M,Out)) :- acc_(M,b_,Out).
%%
% optimisation: 
% leap straight to the top for these accessors
leap(_ := _).
leap(_ ~> _).
leap(_ @ _ ).
leap('#init0').
pattern(ooFirst(touch), acc_(Com,A,B)) :- leap(Com),!,t_(Com,A,B).
%%
pattern(oos(get),      '#known'(self_,x_(_))).
pattern(oos(get),    acc_(x_(V),X,X)) :- 
	arg(nth_,X,V).
pattern(oos(put),    '#known'(self_,xIs_(_,_))).
pattern(oos(put),    acc_(xIs_(Old,New),X,X)) :- 
	arg(nth_,X,Old),
	setarg(nth_,X,New). %swi
%%
%pattern(oo(print),     (portray(b_) :- write(self_/id_))).
%%
pattern(oo(get),    '#known'(self_,get(_))).
pattern(ooOnStack,     acc_(get(Id),X,X)) :- arg(1,X,Id).
pattern(ooAsAssertion, ((:- dynamic acc_/arity_))).
pattern(ooAsAssertion, acc_(get(Id),_,New)) :- 
	b_, New=b_, Id=id_
        ; acc_(child(C),_,_),oo(C,get(Id),New).
%%
pattern(oo(get),    '#known'(self_,put)).
pattern(ooOnStack,     acc_(put,X,X)) :- badput(self_).
pattern(ooAsAssertion, acc_(put,X,X)) :- 
	oo(X,identity(I),X),
	ignore(retract(I)),
	assert(X).
%%

pattern(ooClass(functor), '#known'(self_,functor(self_))).
pattern(ooClass(functor),  acc_(functor(self_),X,X)).

pattern(ooClass(arity), '#known'(self_,arity(arity_))).
pattern(ooClass(arity),acc_(arity(arity_),X,X)).
%%
pattern(oo(initsList),'#known'(self_,'#inits0'(i_))).
pattern(oo(initsList),acc_('#inits0'(i_),T,T)).

pattern(oo(fieldsList),'#known'(self_,'#fields'(f_))).
pattern(oo(fieldsList),acc_('#fields'(f_),T,T)).

pattern(oo(typesList),'#known'(self_,'#types'(types_))).
pattern(oo(fieldsList),acc_('#types'(types_),T,T)).
%%
pattern(ooClass(parent),'#known'(self_,parent(isa_))).
pattern(ooClass(parent), acc_(parent(isa_),X,X)).
%%
pattern(oo(super), '#known'(self_,super(_))).
pattern(oo(super),  acc_(super(M),In,Out)) :-
	p_(M,In,Out).
%%
pattern(ooLast(inheritance), acc_(var_,In,Out)) :- 
	not('#known'(self_,var_)), 
	p_(var_,In,Out).









