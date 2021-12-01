*[tighten,loosen,push,pull,
  tapFlow,tub,plugFlow].

*tighten  --  tapFlow .
*loosen   ++  tapFlow. 
*tapFlow  +-+ tub .
*plugFlow +-- tub .
*push     ++  plugFlow .
*pull     --  plugFlow. 

*rx      = [[], [tighten,push]].
*tub     = [20,          15].
*tapFlow = [20,          15].

*done.