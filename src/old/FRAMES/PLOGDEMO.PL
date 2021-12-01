:- ensure_loaded(plog).

a=b(c,d,kk).


a o g --> {print(2)}.
a o f --> o g, {print(1)}.
a o 1 -->
	o [fresh,blah=40,c=2,
	   d := 23,+c,f,l,kk << 22,
	   kk >> 10,
	   kk has fred, fetch],
	l o  bbb,
	kk o asdas.

kk=k(a,b,c).

kk o asdas --> o init, o run.

/*
?- [plogdemo].
%   olog compiled 0.01 sec, 0 bytes
%  plog compiled 0.01 sec, 0 bytes
%HUH? 'a.blah' at 'plogdemo.pl', near line 7
%HUH? 'a.l' at 'plogdemo.pl', near line 7
%HUH? 'l.bbb' at 'plogdemo.pl', near line 7
%HUH? 'kk.asdas' at 'plogdemo.pl', near line 7
% plogdemo compiled 0.01 sec, 0 bytes

Yes

?- [plogdemo],listing(a).
a(A) :-
        a(A, B, C).

a(me(A), A, A).
a(g, A, B) :-
        print(2),
        B=A.
a(f, A, B) :-
        print(2),
        C=A,
        print(1),
        B=C.
a(1, A, b(B, C, D)) :-
        true,
        a(blah, 40, 40, b(E, F, G), H),
        a(c, 2, 2, H, I),
        a(d, J, 23, I, K),
        a(c, L, M, K, N),
        M is L+1,
        print(2),
        O=N,
        print(1),
        P=O,
        a(l, P, Q),
        a(kk, R, [22|R], Q, S),
        a(kk, [10|T], T, S, U),
        a(kk, V, V, U, b(B, C, D)),
        member(fred, V),
        b(B, C, D),
        l(bbb, W, X),
        kk(asdas, Y, Z).

a(c, A, B, b(A, C, D), b(B, C, D)).
a(d, A, B, b(C, A, D), b(C, B, D)).
a(kk, A, B, b(C, D, A), b(C, D, B)).

*/
