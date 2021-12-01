aboutme(
 "ROCKY"           % name
 ,"0.3"            % version number
 ,"2002"           % year
 ,"Tim Menzies"    % who
 ,"'Horses for your courses.'" % mantra
).

% license
hello :- 
   aboutme(Name,Ver,Year,Creator,Mantra),
   format('~s version ~s',[Name,Ver]),nl,
   format('Copyright (C) ~s by ~s',[Year,Creator]),
   nl,format('~s',[Mantra]),
   nl,nl,format('~s ',[Name]),
   chars('nowarranty.txt'). 
   
warranty :-
    aboutme(Name,_,Year,Creator,_),
    format('~s by ~s',[Name,Creator]),nl,
    format('Copyright (C) ~s\n\n',[Year]),
    chars('warranty.txt'),nl. 

conditions :- chars('conditions.txt'),nl. 

wave :- 
   aboutme(Name,Ver,_,_,_),
   format('~s version ~s',[Name,Ver]),nl.


chars(F) :- see(F), get_byte(X), ignore(chars1(X)), seen.
    
chars1(-1) :- !.
chars1(X)  :- put(X), get_byte(Y), chars1(Y).
