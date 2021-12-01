

%=head1 C<dist(+List,-Pairs)>: Simple collection of histogram data 


%=head2 Helper

%The list of C<key=frequency>
%pairs is sorted in decreasing C<key> order.

 dist(L0,L) :-  dist(L0,_,_,L,_).

%This variant also returns the largest frequency seen
%in any bucket.

 dist(L0,L,Most)    :- dist(L0,_,_,L,Most).

%This variant also returns the keys with the C<Min/Max>frequencies.

 dist(L0,Min,Max,L) :- dist(L0,Min,Max,L,_).


%=head2 Workers

%Preparing to the do the work. Sort the incoming symbols (keeping
%repeated symbols).

 dist(L0,Min,Max,L,Most) :-
    msort(L0,[Min|L1]), 
    dist([Min|L1],[],Min,Max,L,0,Most).

%Termination.

 dist([],X,Max,Max,X,Most,Most).

%If the same two symbols are found next
%to each other, increment the frequency count. 

 dist([H|T],[H=N0|Rest],_,Max,Out,Most0,Most) :- !,
    N is N0 + 1,
    Most1 is max(Most0,N),
    dist(T,[H=N|Rest],H,Max,Out,Most1,Most).

%Otherwise, start a new pair and set its frequency to I<1>.

 dist([H|T],In,Min,Max,Out,Most0,Most) :-
    Most1 is max(Most0,1),
    dist(T,[H=1|In],Min,Max,Out,Most1,Most).


%=head1 C<bars(+Num1,+Num2,+Num3,+Pairs)>: print a bar chart

/*Displays te frequency pairs from C<dist/2> as  a bar chart. Has
the following arguments:

=over 8

=item Num1

is the width of the first I<item> column
displaying the name of each bar;

=item Num2

is the width of the second 
I<frequency> column showing how many items
fall into that bar;

=item Num3

is the width of the last column showing
the population size.

=item Pairs

Symbol/frequency pairs (can be generated from
C<dist/2>.


=back 

=head2 Helper */

%In this helper, the I<item> column is 5 wide (C<Num1>),
%the I<frequency> column is 5 wide (C<Num2>),
%and the I<scale factor> is 3 (C<Num3>).

 bars(List) :-
    Num1=5,
    Num2=5,
    Num3=3,
    bars(Num1, Num2, Num3, List). /*

=head2 Worker

We use C<sformat> to build a string  that
stores the widths and scale factor
for our columns. Note the use of C<>> and C<S>
which are special format commands defined in C<strings.pl> */

 bars(Num1,Num2,Num3,List) :-
    sformat(S,' ~~~w>  ~~~w> ~~~wS\n',[Num1,Num2,Num3]),
    dist(List,Dist),
    nl,
    format(S,[item,frequency,0]),
    forall(member(What=N,Dist), format(S,[What,N,N])).

%=head1 Demos

%=head2 Known Demos

%Here's our list of known demos:

 distDemos :- Demos=[egdist,      egbarsNormal, egbarsBeta,
	             egbarsGamma1,egbarsGamma2, egbarsGamma3
                    ],
              forall(member(Demo,Demos),demo(Demo)).

%=head2 Demo: simple frequency counts

 egdist :- 
    List = [a,b,r,a,c,a,d,a,b,r,a],
    dist(List,Dist),
    format('The distribution of symbols\n~w is\n~w.\n',
          [List,Dist]).

%=include egdist.spy

%=head2 Bar Chart demo Support Code

%Need a little tool to generate distributions.
%The tool accepts some distribution function C<F> and
%samples it C<Repeats> number of times (rounding each
%result to the nearest C<Rounding> value0 we'll use I<1>).
%The results are then displayed using C<bars/4>.

 egbarDemos(Repeats,F) :-
    format(' ---| ~w * ~w |-------',[Repeats,F]),
    Rounding=1,
    findall(X,(between(1,Repeats,_),
	       X is round(F/Rounding)*Rounding),
	    L),
    bars(5,5,100,L).

%=head2 Demo of a normal distribution

 egbarsNormal :-
	egbarDemos(10000,normal(20,2)).

%=include egbarsNormal.spy

%=head2 Demo of a beta distribution

 egbarsBeta :-
	egbarDemos(10000,rand(10,20,0.2)).

%=include egbarsBeta.spy

%=head2 Demo of a gamma distribution

 egbarsGamma1 :-
	egbarDemos(10000,gamma(10,15)).

%=include egbarsGamma1.spy

%=head2 Demo of a skewed gamma distribution

 egbarsGamma2 :- 
    egbarDemos(10000,gamma(10,5)).

%=include egbarsGamma2.spy

%=head2 Demo of a very skewed gamma distribution

 egbarsGamma3 :-
	egbarDemos(10000,gamma(10,2)).

%=include egbarsGamma3.spy
