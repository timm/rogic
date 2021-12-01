:- [usual].

*model is 'two-x.
#2: 2-[e=1, k=1]'.
%vars
* uds : a,b,c,d,e,f,g,h,i,j,k,l,n,m.

%rules
*k + j.
*j + i.
*i + b.
*b + l.
*l + a.
*h + g.
*g + f.
*f + b.
*b + n.
*n + m.
*c + b.
*d + c.
*e + d.

%obs
*rx   = [[m], [a]]
,
[e    = [2,   3]
,k    = [2,   3]
,h    = [2,   1]
].

*end.



