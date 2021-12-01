% Static links
link(++,X1,X2)  :- pos(X1), pos(X2). % direct
link(++,X1,X2)  :- neg(X1), neg(X2). % direct
link(--,X1,X2)  :- pos(X1), neg(X2). % inverse
link(--,X1,X2)  :- neg(X1), pos(X2). % inverse
link(+-+,X1,X2) :- pos(X1), pos(X2). % creator
link(--+,X1,X2) :- neg(X1), pos(X2). % inverse creator
link(+--,X1,X2) :- pos(X1), neg(X2). % destroyer
link(---,X1,X2) :- neg(X1), neg(X2). % inverse destroyer

% Time links
link(+~+,X1,X2)  :- pos(X1), pos(X2). % direct
link(+~+,X1,X2)  :- neg(X1), neg(X2). % direct
link(-~-,X1,X2)  :- pos(X1), neg(X2). % inverse
link(-~-,X1,X2)  :- neg(X1), pos(X2). % inverse
link(+~-+,X1,X2) :- pos(X1), pos(X2). % creator
link(-~-+,X1,X2) :- neg(X1), pos(X2). % inverse creator
link(+~--,X1,X2) :- pos(X1), neg(X2). % destroyer
link(-~--,X1,X2) :- neg(X1), neg(X2). % inverse destroyer

oppEdge(++,--).
oppEdge(+-+,--+).
oppEdge(+--,---).

oppEdge(+~+,-~-).
oppEdge(+~-+,-~-+).
oppEdge(+~--,-~--).

asymmetrical(+-+).
asymmetrical(+--).
asymmetrical(--+).
asymmetrical(---).

asymmetrical(+~-+).
asymmetrical(+~--).
asymmetrical(-~-+).
asymmetrical(-~--).

timeLink(+~+).
timeLink(-~-).
timeLink(+~-+).
timeLink(-~-+).
timeLink(+~--).
timeLink(-~--).
