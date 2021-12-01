% types have ranges
* nums      = [low,      high,medium].
* rType     = [xz100,    kl23].
* pType     = [hercules, fa18,f111,concorde].
* bool      = [-1,1].

% things have types
* bool      : a,b,c,d,e.
* nums      : alt.
* rType     : radar.
* pType     : platform.

%facts
* a.
* radar   =kl23.

%rules
* platform=fa18     if radar=xz100 and e and not d and a.
* platform=concorde if not (alt=low and a=1) and radar=kl23.
* platform=f111     if alt=low.
* platform=f111     if radar=xz100.
* platform=f111     if alt=high.

* a if b.
* b if c. 

%goals


* end.

