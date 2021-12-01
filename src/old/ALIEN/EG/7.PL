:- +[lib/lists, lib/btree, lib/timer, lib/io].

main1 :- main2, fail.
main1.
main2 :- randomList(10,X),
	maplist(kv,X,Y),
	bfinds(Y,T),
	bprint(T).

main2 :- randomList(10,X),
	sort(X,Y),
	maplist(kv,Y,Z),
	l2t(Z,_,T),
	bprint(T).
kv(X,X=x(X)).
	
go :- watch(main1).
