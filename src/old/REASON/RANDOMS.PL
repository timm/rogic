/* 

=head1 Random Predicates 

Lets thrash around a little.

=head1 Header 

=head2 Flags */

 :- arithmetic_function(inf/0).
 :- arithmetic_function(rand/0).
 :- arithmetic_function(rand/2).
 :- arithmetic_function(rand/3).
 :- arithmetic_function(normal/2).
 :- arithmetic_function(beta/1). 
 :- arithmetic_function(gamma/2).  /*

=head1 Any  Random Solution  */

 any(X) :- 
	setof(One,X^any1(X,One),All), 
	member(_/X,All).

 any1(X,Score/X) :- 
	X, 
	Score is rand. /*

=head1 Best

Same code as above, but with some assessment criteria thrown in. */

 best(X) :- 
	setof(One,X^best1(X,One),All0), 
	beam(X,All0,All), 
	member(_/X,All).

 best1(X,Score/X) :- 
	X, 
	score(X,Score0), 
	bound(X,Score0), 
	Score is -1 * Score0. /*

If we have no knowledge of C<X>, give it a random number. */

 score(_,N) :- 
	N is  rand(2147483647). /*

If we have knowledge of minimum values for a score,  test it here. */

 bound(_,Score) :- 
	Score > 0. /*

Sometimes, we may just want to select the top I<N> values:
makes this a beam search. The default
case is that there is no selection knowledge. */

 beam(_,L,L).  /*

=head1 Rand  */

 rand(X)         :- X is random(inf)/inf.
 rand(Min,Max,X) :-  X is Min + (Max-Min)*rand. /*

=head2 Beta */

 rand(Min,Max,B,X) :-
    X is Min + (Max-Min)*beta(B).

 beta(B,X) :- beta1(B,X),!.
 beta(B,X) :- beta1(0.5,X),print(user,badBeta(B)).

 beta1(0,0).
 beta1(0.1,X)  :- X is 1- rand^(1/9).
 beta1(0.20,X) :- X is 1- rand^0.25.
 beta1(0.25,X) :- X is 1- rand^0.33.
 beta1(0.33,X) :- X is 1- rand^0.5.
 beta1(0.4,X)  :- X is 1- rand^0.67.
 beta1(0.50,X) :- X is rand.
 beta1(0.60,X) :- X is rand^0.67.
 beta1(0.67,X) :- X is rand^0.5.
 beta1(0.75,X) :- X is rand^0.33.
 beta1(0.80,X) :- X is rand^0.25.
 beta1(0.9,X)  :- X is rand^(1/9).
 beta1(1,1). /*

=head2 Normal  */

 normal(M,S,N) :- box_muller(M,S,N).

 box_muller(M,S,N) :-
    wloop(W0,X),
    W is sqrt((-2.0 * log(W0))/W0),
    Y1 is X * W,
    N is M + Y1*S.

 wloop(W,X) :-
    X1 is 2.0 * rand - 1,
    X2 is 2.0 * rand - 1,
    W0 is X1*X1 + X2*X2,
    (W0  >= 1.0 -> wloop(W,X) ; W0=W, X = X1). /*

=head2 Gamma 

(Only works for integer Alphas.) 

A standard random I<gamma> distribution has 
I<mean=alpha/beta>.
The I<alpha> value is the ``spread'' of the 
distribution and controls the
clustering of  the distribution
around the mean. As
I<alpha> increases,
the I<gamma> distribution evens out to become 
more evenly-distributed about the mean. That is, for large
I<alpha> (i.e. above 20), I<gamma> can be modeled as a noraml
function.
The standard I<alpha,beta> terminology can be confusing
to some audiences. Hence, I define a
(slightly) more-intuitive I<gamma>
distribution where:

I<myGamma(mean,alpha) = standardGamma(alpha,alpha/mean)> */

 gamma(Mean,Alpha,Out) :-
    Beta is Mean/Alpha,
    (Alpha > 20
    ->  Mean is Alpha * Beta,
        Sd is sqrt(Alpha*Beta*Beta),
        Out is normal(Mean,Sd)
    ;   gamma(Alpha,Beta,0,Out)).

 gamma(0,_,X,X) :- !.
 gamma(Alpha,Beta, In, Gamma) :-
    Temp is In + ( -1 * Beta * log(1-rand)),
    Alpha1 is Alpha - 1,
    gamma(Alpha1,Beta,Temp,Gamma). /*

=head2 Random Strings */

 rstring(_,X)  :- nonvar(X),!.
 rstring(A,X)  :- gensym(A,X). /*

=head2 Random Symbols */

 rsym(X) :- rsym(g,X).

 rsym(_,X)  :- nonvar(X),!, atom(X).
 rsym(A,X)  :- gensym(A,X). /*

=head2 Random Members of a List */

 rin(X,L) :- number(X),!, member(Y,L), X =:= Y. 
 rin(X,L) :- nonvar(X),!, member(X,L). 
 rin(X,L) :- any(member(X,L)).	/*

=head2 Random Numeric Taken From Some Range 

The default case is that we step from some C<Min>
to C<Max> number in incremets of one. */

 rin(Min,Max,X) :- rin(Min,Max,1,X). /*

The usual case is that we step from some C<Min>
to C<Max> number in incremets of C<I>. */

 rin(Min,Max,_,X) :- nonvar(X),!, number(X),Min =< X, X =< Max.
 rin(Min,Max,I,X) :- any(rin1(Min,Max,I,X)).

 rin1(Min,Max,I,X) :-
	Steps is integer((Max-Min)/I),
        between(0,Steps,Step), 
	Num is Min + Step*I,
	X is min(Num,Max).  /*

=head1 Footer

=head2 Start-ups */

 :- current_prolog_flag(max_integer,X), 
    X1 is X - 1, 
    retractall(inf(_)),
    assert(inf(X1)). 


