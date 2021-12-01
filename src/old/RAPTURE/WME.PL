wmes([names,theory,theory1,data,data1,datum,run]).

%oks(enabled, active).  % bigger accessors, testing all 
                        % values each access
oks(disabled,off).      % faster, smaller accessors 

ok(p,X) :- integer(X), X >=0.
ok(a,X) :- atom(X).
ok(n,bar(X)) :- w n(X).
ok(n,X) :- w n(X).
ok(v,X) :- w v(X,_,_).
ok(ao,and).
ok(ao,or).
ok(ao,bor).
ok(ao,band).
ok(e,X) :- w e(X,_,_,_).

name=
[ n(+tag: a)
].

theory=
[ e(+id  : p, upstream: v, downstream: v, weight: p)
, v(+id  : p, tag     : n, type      : ao)
, r(+root: v)
].

run=
[ d(vertex:      v, weight: p)
, tPrime(vertex: v)
, sPrime(vertex: v)
, cut(id:        v, edge: e).
, z(edge:        e)
].

/*
n(nn).
v(12,nn,and).
e(12,11).
*/

