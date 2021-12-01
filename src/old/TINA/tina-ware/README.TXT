To start TinA do.

> Start SWI-prolog (pl)
?- [load].
?- go.

After the welcome, you will see three options. Option 2 runs out of
local stack.  The other options work.

To interrupt the program type control-C, and then a (abort). To start
the program again, type "go." e (exit) after the control-C, will exit
Prolog.

This version of TinA (Tool in Acquisition) is a simplified version. If
you look at the source code in ker_construct.pl, you can see that
several options are commented (not loaded). Originally, these options
seemed promising support for knowledge engineer, but they were taken
away because they were too complex (out of global stack). I had no
time to optimize the program. 

TinA uses Prolog's Definite Clause Grammar. It represents the PSM
library as a context-free grammar (added with normal Prolog code to
verify the assumptions). Option 2 might run out of stack because of
recursion. 

Have a look at the file "hint.txt" to see what happens with the
various options.

Files beginning with "ker_" are supposed to be kernel files that make
up the system. They are not related to diagnosis.

Files beginning with "know_" contain diagnosis related knowledge.
(E.g., I used the same ker_ files to generate strategies for planning
instead of diagnosis.)

TinA is developed for experimentation. It is not supposed to be
foolproof and user-friendly. TinA can be modified and adapted as you
like, as long as the basic idea of TinA is acknowledged.

For more information:

email: richard@iiia.csic.es
or     richard@swi.psy.uva.nl

-- Richard 
Amsterdam, Thu Dec 19 16:21:06 1996

Dr. V.R. (Richard) Benjamins, University of Amsterdam, SWI,
Roetersstraat 15, NL-1018 WB Amsterdam, The Netherlands, Tel:
+31-20-5256791, Fax: +31-20-5256896, E-mail: richard@swi.psy.uva.nl,
WWW: http://www.swi.psy.uva.nl/usr/richard/home.html
