src('/mnt/win98/src/pl/tar2/').

srcFile(X) :-  
	src(Path),
	sformat(S,'~w/~w.pl',[Path,X]),
	load_files([S],[silent(true)]).

:- Src=[utils
       ,accessor
       ,comline
       ,comline1
       ,expand
       ],
   forall(member(F,Src),
          srcFile(F)).

ver :-
        format('~s\n',["Welcome to TARZAN (Version 2.0);
Copyright (c) 2001 Tim Menzies (tim@menzies.com).
Copy policy: GPL-2 (see www.gnu.org)
Guessing control strategies."]).

