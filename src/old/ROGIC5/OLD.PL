term_expansion([rx=_|_],[]).

term_expansion((*if no X then Y  ++ Z), T):- !,xpand((-X,(Z <-   Y)),T).
term_expansion((*if no X then Y  -- Z), T):- !,xpand((-X,(Z <-  -Y)),T).
term_expansion((*if no X then Y +-+ Z), T):- !,xpand((-X,(Z <- ++Y)),T).

term_expansion((*if no X then Y +-- Z), T):- !,xpand((-X,(Z <- +-Y)),T).
term_expansion((*if no X then Y --+ Z), T):- !,xpand((-X,(Z <- -+Y)),T).
term_expansion((*if no X then Y --- Z), T):- !,xpand((-X,(Z <- --Y)),T).
term_expansion((*if    X then Y  ++ Z), T):- !,xpand(( X,(Z <-   Y)),T).
term_expansion((*if    X then Y  -- Z), T):- !,xpand(( X,(Z <-  -Y)),T).
term_expansion((*if    X then Y +-+ Z), T):- !,xpand(( X,(Z <- ++Y)),T).
term_expansion((*if    X then Y +-- Z), T):- !,xpand(( X,(Z <- +-Y)),T).
term_expansion((*if    X then Y --+ Z), T):- !,xpand(( X,(Z <- -+Y)),T).
term_expansion((*if    X then Y --- Z), T):- !,xpand(( X,(Z <- --Y)),T).
term_expansion((*             Y  ++ Z), T):- !,xpand((   Z <-   Y),T).
term_expansion((*             Y  -- Z), T):- !,xpand((   Z <-  -Y),T).
term_expansion((*             Y +-+ Z), T):- !,xpand((   Z <- ++Y),T).
term_expansion((*             Y +-- Z), T):- !,xpand((   Z <- +-Y),T).
term_expansion((*             Y --+ Z), T):- !,xpand((   Z <- -+Y),T).
term_expansion((*             Y --- Z), T):- !,xpand((   Z <- --Y),T).
