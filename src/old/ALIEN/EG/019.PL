%% testing the vulcan1 compiler
:- +[law/vulcan1].

go :- watch(go1).

go1 :- optimise('eg/16.out').


