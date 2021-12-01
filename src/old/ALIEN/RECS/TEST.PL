
term_expansion(publish(Term),Out) :-
    setof(One,publish1(Term,One),Out).