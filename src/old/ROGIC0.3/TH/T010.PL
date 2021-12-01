tapFlow  <- - tighten.
tapFlow  <- loosen.
tub     <- ++ tapFlow.
tub     <- +- plugFlow.
plugFlow <- ++ push.
plugFlow <- -- pull.

[rx      = [[], [tighten,push]]
,tub     = [20,          15]
,tapFlow = [20,          15]
].