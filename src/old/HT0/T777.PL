
*[
fs ,
pc ,
inf ,
wr ,
cab ,
cs , 
cp ,
ds ,
td ,
ic 
].
*fs ++ pc.
*ds ++ cp.
*fs ++ cp.
*pc -- inf.
*inf -- wr.
*cp  ++ cs.
*cs -- wr.
*cs ++ ic.
*cs ++ cab.
*td -- cab.
*td -- ic.
*rx                 = [[ds],[fs]].
*cp     = [0,               10].
*ic = [0,               10].
*wr     = [0,               10].

*done.
