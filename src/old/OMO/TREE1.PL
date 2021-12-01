

%=head1 Lookup trees

%Our trees have the form 

% t(Key,Value,Left,Right)

%where C<Left> and C<Right> are sub-trees.

%This tree system is naughty- it lets sub-trees be unbound.

%=head2 C<find(+K0,?V0,?V,?Tree0,?Tree)>: C<V0> in C<Tree0> becomes C<V> in C<Tree>.

%Can also be used to insert items if C<?Tree0> not ground.

 find(K, V0,V,t(K, V0,L, R),t(K, V, L,R)).
 find(K0,V0,V,t(K1,V1,L0,R),t(K1,V1,L,R)) :-
	K0 @< K1,
	find(K0,V0,V,L0,L).
 find(K0,V0,V,t(K1,V1,L,R0),t(K1,V1,L,R)) :-
	K0 @> K1,
	find(K0,V0,V,R0,R).

%=head2 C<find(+K0,?V,?Tree)>: Find C<V> in C<Tree> 

%Sometimes, we want to look up values without
%changing them.

 find(K,V,T,T) :- find(K,V,V,T,T).

%=head2 C<finds(+[K=V|KVs],?Tree)>: Call find on a list of Key/Values 

%It can be useful to have a batch tree accessor. If 

 finds(L,T) :- finds(L,t(_,_,_,_),T).

 finds([],T,T).
 finds([Key=Value|Rest]) --> find(Key,Value), finds(Rest).

%=head2 C<tprint(+Tree)>: display a tree

%Of course, we can't test anything unless we can
%print it.

 tprint(T) :- tprint(T,[],'|    '),!.

 tprint(X,_,_) :- var(X),!.
 tprint(t(K,V,L,R),Ins,B4) :-
	forall(member(In,Ins),write(In)),
	write(K=V),nl,
	tprint(L,[B4|Ins],B4),
	tprint(R,[B4|Ins],B4).

%=head1 Demo code

 egFind :- egFind(_).
 egFind(T) :-
	L0= [a=1,b=2,c=3,d=4,e=5,f=6
            ,g=7,h=8,i=9,j=10,k=11],
	inOrder(L0,L),
	once(finds(L,T)),
	tprint(T).


 egFinds :- demo(egFind).

%=include egfind.spy
