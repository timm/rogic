%
switch(X) :- once(switch1(X)).
switch1([]).
switch1([-X|Rest]) :- applySwitch(X,Rest,After), switch(After).
switch1([X|_])     :- barph('switch error',X).

applySwitch(X,Rest,After) :- switchArgs(Rest,Args,After),
	                     (Args=[]
                             -> applyCom1(X)
                             ;  forall(member(Arg,Args),applyCom2(X,Arg))).

applyCom1(X)   :- clause(com(X),Y) -> Y ; barph(unknown,X).
applyCom2(X,Y) :- clause(com(X,_),_) -> com(X,Y) ; barph(unknown,X).
%
:- dynamic control/3.
:- swi(index,control(1,1,0)).

set(X,Y)     :- ok2Set(X,Y), 
	        retractall(control(X,_)), assert(control(X,Y)).
isSet(X,Y)   :- control(X,Y).
ok2Set(F,Y)  :- defVar(F,_,_,_,_,Y,Check)
                -> (Check -> true ; oops(not(F),Check))
                ;  barph(unknown,F).

defaults(L)   :- findall(On,defVar(_,_,_,On,_,_,_) ,L0),
                 flatten(L0,L).
undefaults(L) :- findall(Off,defVar(_,_,_,_,Off,_,_),L0),
	         flatten(L0,L).
%    
switchArgs(In,Args,After) :- once(switchArgs1(In,Args,After)).

switchArgs1([],     [], []).
switchArgs1([-H|T], [], [-H|T]).
switchArgs1([H|T],[H|Rest],Out) :-
	switchArgs(T,Rest,Out).
%
switches :- 
    swi(args,Args0),
    append(_,[--|Args1],Args0),
    maplist(asTerm,Args1,Args),
    switch(Args).

asTerm(S,T) :- atom_to_term(S,T,[]),!.
asTerm(S,-String) :- atom_to_term(S,-V,[String=V]),!.
asTerm(S,_) :- barph('syntax error',S).
%
:- Stuff = (defVar/7,com/2, com/1,aboutText/2),
   (multifile Stuff),
   (discontiguous Stuff).

term_expansion((com(X) = Text0 :- Body),
	       [(com(X) :- Body),aboutText(X,Text)]) :-
	makeHelpText(Text0,Text).
term_expansion((com(X,Y) = Text0 :- Body),
	      [(com(X,Y) :- Body),aboutText(X,Text)]) :-
	makeHelpText(Text0,Text).
term_expansion((F/Flag is Type - String :- On;Off),[One,Two]) :-
	asString('~wp',[Type],IsType),
        Check =.. [IsType,X],
        One=defVar(F,Flag,String,On,Off,X,Check),
        term_expansion((com(F,Thing) = Type/String :- set(F,Thing)),Two).

makeHelpText(Args0/Text,Out) :- !,
	sizedAtom(Args0,8,r,Args),
	asString(' ~w ~w',[Args,Text],Out).
makeHelpText(Text,Out) :-
	makeHelpText(''/Text,Out).
%
com([]).
com([H|T]) :- com(H), com(T).
com('MAIN') = 'file'/'change the start-up file (default = ''main'')' :- true.
com('EXE') = 'exe'/'change the prolog interpreter' :- true.
com('A') = 'about this program' :-
	com('A0'), copyLeft(X), write(X).
com('D') = 'show default start-up settings' :- 
	defaults(D), say(defaults,D).
com('H') = 'show help text' :- 
	com('A0'),nl,
	setof(A-B,aboutText(A,B),L), 
	forall(member(A-B,L),(
	          sizedAtom(A,4,A1),
                  format(' -~w ~w~n',[A1,B]))).
com('I') = 'interactive mode' :- 
	prolog.
com('L',F) = 'f1,f2,..'/'load f1,f2,..' :- 
	load_files(F,[silent(true)]).
com('O',X) = 'x'/'remember to output ''x''' :-
	set(show(X),t).
com('S') = 'show control settings' :- 
	forall(isSet(X,Y),say(X,Y)).
com('U') = 'undo the default start-up settings' :- 
	undefaults(U), switch(U).
%
groundp(X) :- ground(X).
atomicp(X) :- atomic(X).
numberp(X) :- number(X).
boolp(X)   :- atomicp(X), member(X,[t,f]).
posIntp(X) :- atomicp(X), numberp(X), X>=0.
filep(X,X) :- atomicp(X), exists_file(X).
filep(X)   :- filep(X,X).
filesp(X)  :- maplist(filep,X,_).
%
:- style_check(-atom), style_check(+string). % swi

copyLeft("
  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.
").

:- style_check(+atom), style_check(-string). %swi







