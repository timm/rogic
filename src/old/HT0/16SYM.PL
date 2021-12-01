:- [main,runtime].

*[nna,acth,coldSwim,cortico,temp,dex].

*coldSwim ++ nna     .
*nna      ++ acth    .
*acth     ++ cortico .
*cortico  ++ temp    .
*temp     -- acth    .
*temp     -- nna     .
*dex      ++ temp    .

*true(dex).

go(P) :- nna(0,[],P1), 
         cortico(0,[],P2),
	 ok(P1,P2,P3),
         acth(0,[],P4),
	 ok(P3,P4,P).




