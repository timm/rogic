/*

=head1 Template

Standard Prolog file structure */

/*

=head1 Header */

/*

=head2 Loads 

Load some code using "ensure_loaded". e.g.: */

 :- ensure_loaded([xx]).


/*

(Warning: there is some quirk in the Prolog loader
 when doing C<goal_expansion>s. If you are using C<ecg>s
 or C<defs>, then DON'T C<ensure_loaded> those files;
rather, load them the old-fashioned way: */

 :- [ecg]. */


=head2 Operators 

Change the Prolog parser using C<op/3>x. e.g.: */

 :- op(700,xfx,and).

/*

=head2 Flags 

Index predicates (with C<index/1>)
or make some dynamic (with C<dynamic/1>)
or discontiguous (with C<discontiguous/1>)
or .... e.g.: */

 :- index(myemp(1,1,0,1,00)).
 :- discontiguous defs/2.
 :- mulitfile defs/2.
 :- dynamic defs/2.

/*

=head2  Hooks 

Change the Prolog parser using C<term_expansion/2> and
C<goal_expansion/2>. e.g. */

 term_expansion(X and Y,Z) :- xpands(X and Y, Z).

 goal_expansion(L with M and N,Z) :- tupleCompile(L with M and N,Z).

/*

=head2 Hacks 

We won't talk about these. I didn't not write these.
You did not see them. */

 goal_expansion(true(X,X),true).

/*

=head1 Body 

Insert your applciation code here. 

=head2 Utils 

Finally, add any general utilities last.  e.g. */

 barph(X) :- format('W> ~w\n',X), fail. /*


=head1 Footer */

/*

=head2 Start-ups 

After all the above is loaded, how do we get this stuff started. */
