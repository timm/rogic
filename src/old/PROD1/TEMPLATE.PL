/*\documentclass[twocolumn,global]{svjour}
\usepackage{prod}\begin{document}

\theprogram{_NAME} 
\thetocdepth{2} % e.g. 2
\thewp{_PATHNAME}
\thepapers{_REF_FILE}
\thetitle{_TITLE}
\theauthor{_AUTHOR1\inst{1},_AUTHOR2\inst{2}}
\theinstitute{_WHERE_AUTHOR1_WORKS;\\
          \url{author1@email1.com},
          \url{http://where.to.find.author1}
             \and
             _WHERE_AUTHOR2_WORKS}
\thereference{_REFERENCE \url{_DOWNLOAD_SITE}}
\theacknowledgement{_ACKNOWLEDGEMENTS}}
\theabstract{_ONE_PARAGRAPH_SUMMARY}
*/

%%%% Installation %<
:- load_files([lib % grab standard stuff
              ,cfg % options controller
              ,gpl % GPL-2 license stuff
              ,xx0 % pre-load actions
              ,xx1 % predicates
              ,xx2 % start-up commands
              ],[silent(yes),if(changed)]).
%>
%\input{xx0}
%\input{xx1}
%\input{xx2}
%%%% Bugs 
%None known but many suspected.


/*
\theend
\end{document}
*/
