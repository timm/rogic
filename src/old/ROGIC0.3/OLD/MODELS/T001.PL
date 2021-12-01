:- [usual].

*model is 'simple
#1: 2-[c=1, a=1]
#2: 0-[]
#3: 2-[a= -1, c= -1]
 ]'.


%vars
* bool : a,b,e,c,d.

%rules
*e + d.
*d + a.
*a + b.
*c + b. 
%obs
*rx   = [[], [b], [d]]
,
[a    = [0,  1,  -1]
,c    = [0,  1,  -1]
,e    = [0,  1,  -1]
].


*end.



