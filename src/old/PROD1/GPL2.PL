%%%% Start-up actions
%Usual stuff.
%<
:- sneak(
        ['defaults.gpl' % see \fig{defaults.gpl}
        ,'config.gpl'   % see \fig{config.gpl}
        ]).

:- commandLine.
:- ?verbose -> hello ; true.
%>