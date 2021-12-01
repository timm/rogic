happy(helen).
sad(lucy) :- sad(helen).
sad(X) :- not(happy(X)).
