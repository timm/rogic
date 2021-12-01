+ 1 :- o new(ht0) o ht0(1,[val of nna = 1 ]).
+ 2 :- o new(ht0) o ht0(1,[val of temp = 1 ]).
+ 3 :- o new(ht0) o ht0(1,[val of nna =1,val of acth = 1,val of cortico=1 ]).
+ 4 :- o new(ht0) o ht0. 
+ 5 :- forall(o new(ht0) o ht0,true).
+ 6 :- profile(forall(between(1,10,_),+ 5), plain,50).
