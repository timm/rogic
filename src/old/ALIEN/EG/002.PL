%% another demo of the record system
:- + [records, types/v, lib/io, lib/lists]. 

main1 :-    showRecordSideEffects(v).

go :- watch(main1).
