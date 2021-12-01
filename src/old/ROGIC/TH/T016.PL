nna     <- coldSwim | -temp.
cortico <- acth.
temp    <- cortico | dex.
acth    <- -temp | nna.

[rx     = [     [],   [dex],  [coldSwim],  [dex,coldSwim]]
,nna    = [  0.122,  0.105,       0.210,       0.246]
,cortico= [129,     11.3,      1232.0,        32.8]
,acth   = [ 89,      0.0,       240.0,         0.0]
].
