%name =  '015. buckets (disabler)'.

*[switch,bucket,tank,spoutFlow].

*bucket ++ tank.
*if no switch then tank ++ spoutFlow.

*rx       =[[], [switch,bucket], [bucket], [switch]].
*spoutFlow=[10,              20,       10,       5].

*done.