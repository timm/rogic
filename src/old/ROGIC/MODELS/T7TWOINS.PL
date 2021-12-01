:- [usual].

*model is '2causes
#1: 1-[c=1]'.

%vars
* uds : a,b,c.

%rules
*c + b.
*c + a.

%obs
*rx   = [[], [a,b]]
,
[c    = [2,   3]
].

*end.



