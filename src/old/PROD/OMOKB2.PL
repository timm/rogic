%%%% Knowledge base
%%% Sample project %<

scores(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_).
	
project is [label('eg#1')
           ,language(prolog)
           ,revl(10)
           ,newKsloc(100)
           ,adaptedKsloc(0)
           ,cm(0)     % new code
           ,dm(0)     % new code
           ,im(0)     % new code
           ,aa(2)     % basic module search + docu \cite[p24]{boehm00b}
           ,unfm(0.4) % somewhat familiar
           ,su(30)    % nominal value \cite[p23]{boehm00b}
           ,at(0)
           ,atKprod(2.4)
           ,scedPercent(100)
           ].



%>
%%% LOC per Function points
/* Also loaded, but not shown due to size,
are tables showing producitivity in different 482 different
programming systems.
It tables a {\em lot} of code to get anything done in
binary, but less code as the language matures. So:

\begin{LISTING}
upf2sloc('1st generation default',320).
upf2sloc('2nd generation default',107).
upf2sloc('3rd generation default',80).
upf2sloc('4th generation default',20).
upf2sloc('5th generation default',5).
\end{LISTING}

The units here are lines of code per function point. For more details,
	see Boehm.
*/


