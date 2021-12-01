
/*
 * Convex Hull (Graham's Scan)
 *   The convex hull of a set of points is the smallest convex region
 *   containing the points
 */

/* graham(Points, ConvexHullVertices) is true if Points is a list of points  */
/*   in the form p(X,Y), and ConvexHullVertices are the vertices in the form */
/*   p(X,Y) of the convex hull of the Points, in clockwise order, starting   */
/*   and ending at the smallest point (as determined by X-values, and by     */
/*   Y-values to resolve ties).                                              */
/* e.g. graham([p(0,6),p(3,7),p(4,6),p(4,5),p(3,4),p(2,4),p(5,0)],           */
/*             [p(0,6),p(3,7),p(4,6),p(5,0),p(0,6)]).                        */

eg1Graham :- graham([p(0,6),p(3,7),p(4,6),p(4,5),p(3,4),p(2,4),p(5,0)], 
                     X),
		     print(X),nl.

eg2Graham :-	rpoints(500,_L), profile(graham(_L,P),plain,20),print(P),nl.
eg3Graham :-
	forall(eg3Graham1(Y,T), 	format('~w takes ~w secs\n',[Y,T])).

eg3Graham1(Y,T) :-	between(1,10,X),
	        Y is 400*X,
		rpoints(Y,_L), 
	        T1 is cputime,
		graham(_L,_),
		T2 is cputime,
		T is T2- T1.
	

rpoint(p(X,Y)) :- X is random(10), Y is random(10000)/10000.

rpoints(N,L) :- length(L,N), checklist(rpoint,L).

graham(Ps, [P1|Qs]):-
  min(Ps, P1),              /* P1 is necessarily a vertex of the convex hull */
  delete(Ps, P1, Ps1),
  sort(Ps1, P1, Ps2, []),   /* Sort Ps1 anti-clockwise with respect to P1    */
  graham_1(Ps2, P1, Qs).

graham_1([], P1, [P1]).
graham_1([P2], P1, [P2,P1]):-!.
graham_1([P2|Ps2], P1, Qs):-
  end(Ps2, LastP),          /* In case a point adjacent to P1 is eliminated */
  graham_2(Ps2, LastP, [P2,P1], Qs), !.
graham_1([_|Ps2], P1, [LastP,P1]):- /* All points collinear */
  end(Ps2, LastP).
  
graham_2([], _, Qs, Qs):-!.
graham_2([P3|Ps], LastP, [P2], Qs):-
  strictly_to_left(P3, LastP, P2), !,
  /* Push latest point P3, and go forward */
  graham_2(Ps, LastP, [P3,P2], Qs).
graham_2([P3|Ps], LastP, Qs0, Qs):-
  Qs0=[P2,P1|_],
  strictly_to_left(P3, P1, P2), !,
  /* Push latest point P3, and go forward */
  graham_2(Ps, LastP, [P3|Qs0], Qs).
graham_2(Ps, LastP, [_|Qs0], Qs):-
  /* Pop previous point, and go back */
  graham_2(Ps, LastP, Qs0, Qs).

/* strictly_to_left(Pa, Pb, Pc) is true if Pa is strictly to the left of the */
/*   directed line from Pb to Pc.                                            */
strictly_to_left(p(Xa,Ya), p(Xb,Yb), p(Xc,Yc)):-
  (Xb-Xa) * (Yc-Ya) - (Xc-Xa) * (Yb-Ya) > 0.0.

/* strictly_to_right(Pa, Pb, Pc) is true if Pa is strictly to the right of   */
/*   the directed line from Pb to Pc.                                        */
strictly_to_right(p(Xa,Ya), p(Xb,Yb), p(Xc,Yc)):-
  (Xb-Xa) * (Yc-Ya) - (Xc-Xa) * (Yb-Ya) < 0.0.

/* last(Xs, X) is true if X is the last element of the list Xs.              */
%end(X,Y) :- last(Y,X).

end([X], X):-!.
end([_|Xs], X):-end(Xs, X).

/* min(List, Min) is true if Min is the smallest element in List as          */
/*   determined by lt/2.*/

min([X|Xs], Y):-min_1(Xs, X, Y).

min_1([], X, X).
min_1([Y|Ys], X, Z):-lt(Y, X), !, min_1(Ys, Y, Z).
min_1([_|Ys], X, Z):-min_1(Ys, X, Z).

lt(p(X,_), p(X1,_)):-X < X1, !.
lt(p(X,Y), p(X,Y1)):-Y < Y1.

/* delete(Xs, Y, Zs) is true if Zs is the result of removing all occurrences */
/*   of the element Y from the list Xs.                                      */
%delete([], _, []).
%delete([Y|Xs], Y, Zs):-!, delete(Xs, Y, Zs).
%delete([X|Xs], Y, [X|Zs]):-delete(Xs, Y, Zs).

/* sort(Xs, X0, Ys, []) is true if Ys is the result of sorting the points Xs */
/*   by polar angle (going anti-clockwise) and distance from X0. Duplicate   */
/*   points are removed.                                                     */
sort([], _, Ys, Ys).
sort([X|Xs], X0, Ys, Zs):-
  split(Xs, X, X0, Ms, Ns),
  sort(Ns, X0, Ws, Zs),
  sort(Ms, X0, Ys, [X|Ws]).

split([], _, _, [], []).
split([X|Xs], X, X0, Ms, Ns):-!,
  split(Xs, X, X0, Ms, Ns).
split([K|Xs], X, X0, [K|Ms], Ns):-
  less_than(X0, K, X), !,
  split(Xs, X, X0, Ms, Ns).
split([K|Xs], X, X0, Ms, [K|Ns]):-
  split(Xs, X, X0, Ms, Ns).

/* less_than(X0, K, X) is true if K is strictly to the right of the line     */
/*   from X0 to X, or if it is collinear with X0 and X but is nearer to X0   */
/*   than X is.                                                              */
less_than(X0, K, X):-
  strictly_to_right(K, X0, X), !.
less_than(X0, K, X):-
  \+ strictly_to_left(K, X0, X),
  is_nearer(K, X, X0).

/* is_nearer(Pa, Pb, Pc) is true if the distance from Pa to Pc is strictly   */
/*   less than the distance from Pb to Pc.                                   */
is_nearer(p(Xa,Ya), p(Xb,Yb), p(Xc,Yc)):-
  Xa_Xc is Xa - Xc,
  Ya_Yc is Ya - Yc,
  Xb_Xc is Xb - Xc,
  Yb_Yc is Yb - Yc,
  (Xa_Xc)*(Xa_Xc) + (Ya_Yc)*(Ya_Yc) < (Xb_Xc)*(Xb_Xc) + (Yb_Yc)*(Yb_Yc).

