%%%% programmer settings for statem.bat
% you MUST define go/0, defaults/1, undefaults/1, com('A0')


% default coms to call at start up
defaults([ +hello
	 , +time
         ]).

% actions to reverse the default actions
undefaults([ -hello
           , -time
           ]).

% your own command line options.
% all the built-in commands are upper case, so if your use 
% lower case, you won't clash with the system stuff
com('A0') = 'show (brief) about text' :- 
        write('STATEM v0.1'),
        write('- a little language for state transistion diagrams.'),
	nl,write('Copyright (C) 1999 tim@menzies.com'),nl.

