happy    :- rich , healthy( .
happy    :- tranquillity( hi).
healthy  :- \+ diet(fatty).
rich     :- income(I), I > 100000.
income(5000).
tranquillity(hi).
diet(fatty).
diet(light).


