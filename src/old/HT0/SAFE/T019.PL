%name = '19.  buckets (ablers)'.

*[tank1,tank2,spoutFlow,switch,bucket].

*bucket ++ tank1.
*if switch then tank1 ++ spoutFlow.
*spoutFlow ++ tank2.

/**rx        = [[], [switch,bucket], [bucket], [switch]].
*spoutFlow = [10,              _,       _,       5].
*tank2     = [10,              _,         _,      10].
*/

*rx        = [[], [switch,bucket], [bucket], [switch]].
*spoutFlow = [10,              20,       10,       5].
*tank2     = [10,              _,         _,      10].

*done.

