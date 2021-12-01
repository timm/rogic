foil_predicates([ list/1, null/1, components/3 ]).
foil_cwa(true).   		  
foil_use_negations(false).        % Don't use negations of foil_predicates
foil_det_lit_bound(0).            % Don't add any determinate literals
                                  % In general, this is a depth limit on
			          %   the search for determinate literals

% Definitions of background predicates
null([]).

components([a], a, []).
components([b, [a], d], b, [[a], d]).
components([[a],d], [a], [d]).
components([d], d, []).
components([e|f], e, f).

list([]).
list([a]).
list([b, [a], d]).
list([[a], d]).
list([d]).
