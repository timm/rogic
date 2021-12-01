pics('..\\pics\').
root('/~timm').

page(T) --> head, tit(T),foot.

head :- 
	all(html,
	all(body,bgcolor=white,
	table('#FFFF66',1,100,row([

body(X) :- tag(body,bgcolor=X).

tit(X) :- f('<title>~w</title>',[X]).


table(Col,Bord,Wid,Rows) :- 
     all(table,[bgcolor=Col,border=Bord,width=Wid],Rows).


img(A,X0,Y) :- file(F0,F),tag(img,[src=X, width=~w height=>
file(X,Y) :- root(Z), string_append(Z,X,Y).
jpg(X,Y) :- file(X,Z), string_append(Z,'.jpg',Y).
gif(X,Y) :- gif(X0,X), pics(P), string_append(Z,'.gif',Y).
cell(X) :- all(td,X).
row(X) :- all(tr,X).
href(X) :- format('<a href="~w">~w</a>',[X,X]).
href(X,Y) :- format('<a href="~w">~w</a>',[X,Y]).
mailto(X) :- format('<a href="mailto:~w">~w</a>',[X,X]).
mailto(X,Y) :- format('<a href="mailto:~w">~w</a>',[X,Y]).
small(X) :- all(small,X).

all(X,Y) :- format('<~w>',[X]),f(Y),format('</~w>',[X])
all(X,Y,Z) :- format('<~w ',[X]),f(Y),write('>'),f(Z),format('</~w>',[X]).

gif0(eyean,72,37).

<tr><td rowspan=2 align=center valign=center  width=72><small>
<img src="../icons/eyean.gif" width=72 height=37>
<td>
<small><a href="./index.htm">Timm's World</a>
<img src="../icons/arrow_yellow.gif" width=13 height=9>
<tr><td><font face="Verdana, Lucida Sans, Arial, Helvetica, Geneva, sans-serif"><small>row2</table><h1></h1><hr><small><em>A <a href=""></a>
page.<br><img src="../icons/mailto.gif" width=14 height=10> <a href="mailto:"></a>

b(X) :- write('<'),f(X),write('>').

tag(X,L) :- b((X,' ',L)).
f((X,Y)) :- !, f(X), f(Y).
f([]) :- !.
f([X|Y]) :- !,write(' '),f(X), f(Y).
f(X=Y) :- !,format(' ~w="~w"',[X,Y]).
f(X) :- write(X).
f(X,Y) :- format(X,Y).
f(X,Y,Z) :- format(X,[Y,Z]).
f(X,A,B,C) :- format(X,[A,B,C]).
f(X,A,B,C,D) :- format(X,[A,B,C,D]).
f(X,A,B,C,D,E) :- format(X,[A,B,C,D,E]).

