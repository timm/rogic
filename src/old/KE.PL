accepts(State,[]):-
   final(State).
accepts(State,[X|Rest]):-
   trans(State,X,State1),
   accepts(State1,Rest).
accepts(State,String):-
   silent(State,State1),
   accepts(State1,String).

final(s3).
trans(s1,a,s1).
trans(s1,a,s2). 
trans(s1,b,s1).
trans(s2,b,s3). 
trans(s3,b,s4).
silent(s2,s4).
silent(s3,s1).