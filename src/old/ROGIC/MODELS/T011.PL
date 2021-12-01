:- [usual].

*model is 'ablers'.

*uds : tank1,tank2,spoutFlow,switch,bucket

*tank1 + bucket.
*if switch then spoutFlow + tank1.
*tank2 + spoutFlow.

*rx        =[ [],  [switch,bucket],[bucket],[switch]]
,
[spoutFlow =[ 10,              20,       10,       5]
,tank2     =[ 10,              _,         _,      10]
].

*end.
