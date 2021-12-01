

oneLess([One|Less],One,Less).
oneLess([H|Tail],X,[H|Rest]) :- oneLess(Tail,X,Rest).
