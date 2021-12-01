foil_predicates([ null/1, components/3, membertest/2]).
foil_cwa(true).
foil_use_negations(false).        % Don't use negations of foil_predicates
foil_det_lit_bound(0).            % Don't add any determinate literals
                                  % In general, this is a depth limit on
			          %   the search for determinate literals

% Note that this example is due to Quinlan 90, but it cannot be
% processed correctly ! On the other hand the example foil_4.pl works
% as expected !

% Definitions of background predicates
null([]).

components([[a]], [a], []).
components([b, [a], d], b, [[a], d]).
components([[a],d], [a], [d]).
components([d], d, []).
components([e|f], e, f).

membertest(a,[a, b, [c]]).
membertest(b,[a, b, [c]]).
membertest([c],[a, b, [c]]).
membertest(b,[b, [c]]).
membertest([c],[b, [c]]).
membertest([c],[[c]]).
