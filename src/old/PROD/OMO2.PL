%%%% Start-up actions
%Usual stuff.
%<
:- sneak(
        ['defaults.omo' % see \fig{defaults.omo}
        ,'config.omo'   % see \fig{config.omo}
        ,ufp2sloc       % see \tion{ufp2slow}
        ]).

:- commandLine.
:- ?verbose -> hello ; true.
%>