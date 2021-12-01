% this file is necessary for certain low-level Prolog reasons.
% ?? automatically generate it in future versions from the link/3 fact?


:- labels([++,  --,  +-+,  --+,  +--,  ---,
	   +~+, -~-, +~-+, -~-+, +~--, -~--]).

defEdge(++,   A ++ B,   A, B).
defEdge(--,   A -- B,   A, B).
defEdge(+-+,  A +-+ B,  A, B).
defEdge(--+,  A --+ B,  A, B).
defEdge(+--,  A +-- B,  A, B).
defEdge(---,  A --- B,  A, B).

defEdge(+~+,   A +~+ B,   A, B).
defEdge(-~-,   A -~- B,   A, B).
defEdge(+~-+,  A +~-+ B,  A, B).
defEdge(-~-+,  A -~-+ B,  A, B).
defEdge(+~--,  A +~-- B,  A, B).
defEdge(-~--,  A -~-- B,  A, B).
