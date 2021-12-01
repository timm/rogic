hello :- 
   `[myName,myVersion,myYear,myMantra,myAuthor]=
    [Name,  Ver,      Year,  Mantra,  Creator],
   format('\n~w version ~w',[Name,Ver]),nl,
   format('Copyright (C) ~w by ~w',[Year,Creator]),
   nl,format('~w',[Mantra]),
   nl,nl,format('~w ',[Name]),
   chars('nowarranty.txt'). % see \tion{nowar}
   
warranty :-
    `[myName,myYear,myAuthor]=[Name, Year,Creator],
    format('~w by ~w',[Name,Creator]),nl,
    format('Copyright (C) ~w',[Year]),nl, 
    chars('warranty.txt'),nl. % see \tion{war}

conditions :-
    chars('conditions.txt'),nl. % see \tion{cond}

wave :- 
   `[myName,myVersion]=[Name,Ver],
   format('~w version ~w',[Name,Ver]),nl.
