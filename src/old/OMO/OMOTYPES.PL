
%=head1 Data dictionary for COCOMO

%=head2 Types

 sym      !X :- rysm(X).
 cocomoP  !X :- X in [2000,1983,ga].
 vlvh     !X :- X in [n,l,h,vl,vh].
 lvh      !X :- X in [n,l,h,vh].
 vlxh     !X :- X in [n,l,h,vl,vh,xh].
 lxh      !X :- X in [n,l,h,vh,xh].
 nxh      !X :- X in [n,h,vh,xh].

 language !X :- X in ['ada 83', 'ada 95', 'ai shells', basic,
	               cobol,c, 'c++', clos, eiffel, forth,
		       fortran, java, jovial, lisp, pascal,
		       prolog, rexx, simula, smalltalk].
 onezero  !X :- X from 0 to   1 by 0.2, number(X).
 percent  !X :- X from 0 to 100 by   1, integer(X).
 posint   !X :- X from 0 to 65536,      integer(X).
 posnum   !X :- X from 0 to inf,        number(X).
 num10    !X :- X from 0 to  10,        number(X).

%=head2 Variables

 cocomo       of cocomoP.   label        of sym.
 language     of language.  revl         of percent.
 newKsloc     of percent.   adaptedKsloc of posint.
 cm           of percent.   dm           of percent.
 im           of percent.   aa           of percent.
 unfm         of onezero.   su           of percent.
 at           of percent.   atKprod      of posnum.
 scedPercent  of percent.

 prec of vlvh.  flex of vlvh.  arch of vlvh.
 team of vlvh.  pmat of vlvh.  rely of vlvh.
 data of lvh.   cplx of vlxh.  ruse of lxh.
 docu of vlvh.  time of nxh.   stor of nxh.
 pvol of lvh.   acap of vlvh.  pcap of vlvh.
 pcon of vlvh.  aexp of vlvh.  pexp of vlvh.
 ltex of vlvh.  tool of vlvh.  site of vlxh.
 sced of vlvh.

