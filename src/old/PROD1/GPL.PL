/*\documentclass[twocolumn,global]{svjour}
\usepackage{prod}\begin{document}

\theprogram{GPL} 
\thetocdepth{2} % e.g. 2
\thewp{~menzies/src/pl/prod/gpl.pl}
\thepapers{refs.bib}
\thetitle{Including GPL-2 in Prod}
\theauthor{Tim Menzies}
\thereference{memo8@.ai.wvu.2003. 
            Available from 
            \url{http://tim.menzies.com/pdf/03gpl.pdf}}
\theinstitute{Lane Department of Computer Science,
             West Virginia University,
             PO Box 6109, Morgantown,
             WV, 26506-6109, USA;\\
             \url{http://tim.menzies.us};
             \url{tim@menzies.us} 
             }
\theacknowledgement{his research was conducted at West Virginia
  University under NASA contract
  NCC2-0979 and NCC5-685.
  The work was sponsored by
  the NASA Office of Safety and Mission Assurance under the Software
  Assurance Research Program led by the NASA IV\&V Facility.  Reference
  herein to any specific commercial product, process, or service by
  trade name, trademark, manufacturer, or otherwise, does not constitute
  or imply its endorsement by the
United States Government.}
\theabstract{Adding the dreaded ``viral'' copyright
notice to PROD code. Open source rules!}
*/
%%%% Configuration
/*The files {\tt defaults.gpl} in \fig{defaults.gpl}
and {\tt config.gpl} in \fig{config.gpl} show
the usual congifuration settings of a PROD GPL file.
Those options are:
\bd
\item[program]: name of program;
\item[version]: version number;
\item[copyright]: 2002;
\item[copywho]: copyright owner;
\item[motto]: trice cliche.
\item[verbose]: verbose mode. If ``0'', then
other code might elect to supress certain standard
strings.
\ed
*/
%\SRC{defaults.gpl}{Standard defaults.}
%\SRC{config.gpl}{User preferences.}
%%%% Installation %<
:- load_files([lib  % grab standard stuff
              ,cfg  % need the config stuff
              ,gpl0 % pre-load actions
              ,gpl1 % load predicates
              ,gpl2 % start-up commands
              ],[silent(yes),if(changed)]).
%>
%\input{gpl0}
%\input{gpl1}
%\input{gpl2}
%%%% Bugs 
%None known but many suspected.


/*
\theend
\end{document}
*/
