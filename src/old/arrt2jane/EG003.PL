/*

Tim,
I think I owe you a reminder of the ARRT/DDP risk calculations.
Here's a hurried message along those lines. Hope it makes sense.
Do you need me to re-mail the small example in Prolog-like syntax?

Sorry, I will miss the teleconference this week - got lured into another
off-lab meeting.
I will be back in the office Thu morning.
Martin



Requirements
- unique internal ID (a string)
- title (a string)
- weight (a non-negative number; higher = more important)

Failure Modes ("FMs")
- unique internal ID (a string)
- title (a string)
- a-priori likelihood (a number in the range [0-1], the probability of
this FM occurring if nothing were done to inhibit it. Usually, but not
always, this is 1 for the FMs we tend to define).

PACTs
- unique internal ID (a string)
- title (a string)
- cost (a non-negative number; higher = more costly)

plus all of the above can be organized into trees.


between these there are

Impacts
- the ID of the impacted Requirement
- the ID of the FM that's impacting the aforementioned Requirement
- the strength of the impact ( a number in the range [0-1], where 0 = no
impact whatsoever, and 1 = total loss of requirement should the FM occur;
the lack of any info defaults to an impact of 0)

Effects
- the ID of the PACT that's inhibiting the FM
- the ID of the inhibited FM
- the strenght of the effect (a number in the range [0-1], where 0 = no
effect whatsoever, and 1 = totally inhibits the FM from occurring; the lack
of any info defaults to an effect of 0)


The ways these things combine are as follows:

FM impacts on Requirements simply ADD (note: it is therefore possible that
a requirement is impacted by more than unity - bizarre as this sounds, this
is not too bad if you think of the total impact as an indication of how
much work you have to do to inhibit those pesky FMs and thereby get your
requirement). 

PACT effects on FMs multiply, sort of. Think of a PACT as a filter. The
effectiveness indicates what proportion of the FM it filters out. Multiple
PACTs on the same FM act as filters in series. E.g., if you've got two
PACTs, with effectivness 0.9 and 0.6 (say) on the same FM, then doing them
both has the net effect of a single PACT of effectiveness (1 - (1 - 0.9) *
(1 - 0.6)) = (1 - 0.1 * 0.4) = (1 - 0.04) = 0.96

EXAMPLE:

Requirement R1 with weight 10
FMs F1, with a-priori likelihood 1, and F2, with a-priori-likelihood .4
F1 impacts R1 by 0.3, F2 impacts R1 by 0.2
PACT P1
P1 effects F1 by 0.8 and effects F2 by 0.6

If you do NOT choose to do P1, then:
Loss of R1 = R1's weight * (F1's a-priori likelihood * F1's impact on R1 +
F2's a-priori likelihood * F2's impact) 
= 10 * (1 * 0.3 + .4 * 0.2)

If you DO choose to do P1, then:
Loss of R1 = R1's weight * (F1's a-priori likelihood * F1's impact on R1 *
F1's reduced effectiveness because of P1 +  F2's a-priori likelihood * F2's
impact on R1 * F2's reduced effectiveness because of P1)
= 10 * (1 * 0.3 * (1 - 0.8) + .4 * 0.2 * (1 - 0.6))
= 10 * (1 * 0.3 * 0.2 + .4 * 0.2 * 0.4)
NOTE the need to do the "one minus" of the PACT effectiveness on the FM to
calculate just how damaging the FM ends up being, e.g., a perfect PACT of
effect 1 would lead to a factor of (1-1) i.e., 0, which makes sense - the
FM has been completely inhibited. Likewise, a useless PACT of effect 0
would lead to a factor of (1-0), i.e., 1, which makes sense - the FM has
been left uninhibited.

If you had another PACT, P2 say, that had a non-zero effect on only F1 in
the amount of 0.6, then:

If you choose to do BOTH P1 and P2:
Loss of R1 = R1's weight * (F1's a-priori likelihood * F1's impact on R1 *
F1's reduced effectivness because of P1 & P2 +  F2's a-priori likelihood *
F2's impact on R1 * F2's reduced effectiveness because of P1 [and P2 makes
no difference to F2])
= 10 * (1 * 0.3 * (1 - 0.8)*(1 - 0.6) + .4 * 0.2 * (1 - 0.6))
= 10 * (1 * 0.3 * 0.08 + .4 * 0.2 * 0.4)


Martin

*/
%:- load_files([arrt],[if(changed),silent(true)]).

+source(v1,u0,when(2001,4,6,17,45,32)).
+aka(goal,"goal",v1).
+aka(u0,"Baseline",v1).
+aka(r1,"Top Level Requirement 1",v1).
+aka(f1,"Failure Mode 1",v1).
+aka(f2,"Failure Mode 2",v1).
+aka(p1,"PACT 1",v1).
+aka(p2,"PACT 2",v1).

+r(goal,1,  0,0,v1) :- r1.
+r(r1,  10, 0,0,v1).

+f(f2,  0.4,0,0,v1).
+f(f1,  1,  0,0,v1).

+p(p2,  1,  0,0,v1).
+p(p1,  1,  0,0,v1).

+impact(f1,r1,0.3,v1).
+impact(f2,r1,0.2,v1).

+effect(f1,p1,0.8,v1).
+effect(f2,p1,0.6,v1).
%+effect(f1,p2,0.6,v1).
