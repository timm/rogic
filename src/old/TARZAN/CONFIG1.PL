:- [iwants].

+range(classt, X)   :- member(X,[t_lo,t_hi,t_md,t_vhi]).
+range(lvh,    X)   :- member(X,[1,2,3,4]).
+range(lxh,    X)   :- member(X,[0,1,2,3,4,5]).
+range(nxh,    X)   :- member(X,[2,3,4,5]).
+range(vlvh,   X)   :- member(X,[0,1,2,3,4]).
+range(vlxh,   X)   :- member(X,[0,1,2,3,4,5]).
+range(sloct,  X)   :- member(X,[100000,2000000]).
+range(sourcet,X) :- member(X,[bayes100k,ga100k,raw100k]).

means(0,vl). means(1,l).  means(2,n).
means(3,h).  means(4,vh). means(5,xh).

what(class,classt).
what(source,sourcet).
what(sloc,sloct).
+what(X,lvh)  :- member(X,[data,pvol]).
+what(X,lxh)  :- member(X,[ruse]).
+what(X,nxh)  :- member(X,[stor,time]).
+what(X,vlvh) :- member(X,[acap,aexp,docu,ltex,pcap,pcon,pexp,rely,sced,tool]).  
+what(X,vlxh) :- member(X,[cplx,flex,pmat,prec,resl,site,team]).

trans1(=,[H|T],=,[H|T]).
trans1(=<,0,=,vl) :- !.
trans1(=>,5,=,vh) :- !.
trans1(<,1,=,vl)  :- !.
trans1(>,4,=,vh) :- !.
trans1(<,1,=,vl) :- !.
trans1(X,0,X,vl).
trans1(X,1,X,l).
trans1(X,2,X,n).
trans1(X,3,X,h).
trans1(X,4,X,vh).

:- reload.
