foil_predicates([ null/1, cons/3, membertest/2]).
foil_cwa(true).
foil_use_negations(false).        % Don't use negations of foil_predicates
foil_det_lit_bound(0).            % Don't add any determinate literals
                                  % In general, this is a depth limit on
			          %   the search for determinate literals

% Definitions of background predicates
null([]).

cons(a, [b, c],[a, b, c]).
cons(b, [c], [b,c]).
cons(c, [], [c]).

membertest(a,[a, b, c]).
membertest(b,[a, b, c]).
membertest(c,[a, b, c]).
membertest(b,[b, c]).
membertest(c,[b, c]).
membertest(c,[c]).
