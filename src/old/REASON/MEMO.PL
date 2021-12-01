/*

=head1 Memos 

Memoing with inconsistency checking. 

Each memo is a pair C<Key=Value>.
If the program generates a completely new C<Value> for
C<Key>, then it is stored.

If the program stumbles on another C<Value> for C<Key>,
then this code will reject the new C<Value> if contradicts
the older known C<Value>.

At anytime, the program can ask for the current C<value>.

Internally, the C<Key=Value> pairs are stored as
C<assumption>s since if the program backtracks over
memo creation, the C<Value> is thrown away.
That is, all memos are tentative and can be discarded
if that proves useful.


=head1 Header

=head2 Loads */

 :- [ecg] . /*

=head2 Flags */

 :- dynamic       assumption/4. 
 :- dynamic       keyValue/3.
 :- discontiguous keyValue/3.
 :- multifile     keyValue/3.  
 :- index(assumption(1,1,1,0)). /*

=head1 Body

=head2 Assumptions

Assumptions are stored as C<assumption(Hash,Key,Value,How)> where:

=over 8

=item C<Hash>

Allows for fast
access to C<assumption>s with complex terms for C<Key>.

=item C<Key>

The I<name> of the thing assumed.

=item C<Value>

The I<value> of the thing assumed.

=item C<How>

Some comment  on how we got to this C<assumption>.

=back

*/

 reset :- retractall(assumption(_,_,_,_)). /*

=head2 C<keyValue>

In order to allow C<assumption>s on arbitrary terms,
the C<keyValue(Term,Index,Key,Value)> predicate inputs some C<Term>
and pulls it apart into its C<Key> and C<Value>. Then
it hashes on the C<Key> to find the C<Index>. */

 keyValue(Term,Hash,Key,Value) :- 
    once(keyValue(Term,Key,Value)), hash_term(Key,Hash). /*

To customize its behavior, add C<keyValue/3> facts: */

 keyValue(Key=Value,Key,Value).
 keyValue(Term,Term,t). /*

=head2 Assume 

With all that defined, now we can assume things: */

 assume(X,_)   :- keyValue(X,H,In,Out), assumption(H,In,Old,_),!,Out=Old.
 assume(X,How) :- keyValue(X,H,In,Out), bassert(assumption(H,In,Out,How)). /*

=head2 Memo

That's all under-the-hood stuff. The main driver of the memo system is
C<memo(Goal,Results)>. */

 memo(Goal,Memos) :-
    status(Memos,New), 
    (New=0 -> true; Goal, ok(Memos,byRule)).

 def(status,[contradictions,agreements, new]).

 status(Memos,New) :- status(Memos,New,_,_).

 status(L,Flag) --> in status, 
    statusReset, 
    statusRun(L),
    the new=Flag.

 statusReset--> in status, the contradictions:=0, the agreements:=0, the new:=0.

 statusRun([]) -->[].
 statusRun([Term|Terms]) -->  in status,
    {keyValue(Term,Hash,Key,Value)},
    statusStep(Hash,Key,Value),
    the contradictions < 1,
    statusRun(Terms). /*

Three cases:

=over 8

=item 1

Old C<Key> is missing: we have a new key to find. */

 statusStep(H,K,_) --> in status, {\+ assumption(H,K,_,_)   },  +the new. /*

=item 1

Old C<Key> is present, new value is bound: check that old=new,  otherwise we 
should note a contradiction. */

 statusStep(H,K,V) --> in status, {ground(V), assumption(H,K,V,_ )},          +the agreements. 
 statusStep(H,K,V) --> in status, {ground(V), assumption(H,K,V0,_), V0 \= V}, +the contradictions. /*

=item 1

Old C<Key> is present, new value is unbound: bind new value to old value.*/

 statusStep(H,K,V) --> in status, {var(V), assumption(H,K,V,_)}  , +the agreements. /*

=back 

 */

 ok([],_).
 ok([H|T],How) :- assume(H,How),ok(T,How). /*

=head2 Utils 

Ye olde backtrackable assert. Good for recording information
about assumptions, then forgetting about them if that don't
pan out.
*/

 bassert(X) :- assert(X).
 bassert(X) :- retract(X),fail.

