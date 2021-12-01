/* file: inout.pl 1.0.0 (USP LSI) Wed Mar 16 20:42:50 1994

    Copyright (c) 1994 Richard Victor Benjamins. All rights reserved.
    richard@lsi.usp.br

    Purpose: procedures for communicating with the user
*/

/* :- module(io_prolog, [
		writeln/1,	
		ask_question/3
	      ]
	 ). */
%---------------------------------------
% Write user feedback to appropriate window
%---------------------------------------

writeln(List):-
	io_writelnt(List),
	nl, !.
io_writelnt([]).
io_writelnt([nl|T]):-
 	 nl,
  	io_writelnt(T).
io_writelnt([H|T]):-
  	io_writelnt2(H),
  	io_writelnt(T).

io_writelnt2(Item):-
  	atomic(Item),!,
  	write(Item),
  	write(' ').
% io_writelnt2(A-B):- !,
% 	io_writelnt2(A),
% 	io_writelnt(B).
io_writelnt2(List):-
	is_list(List),
	!,
  	io_writelnt(List).
io_writelnt2(Term):-
	term_to_atom(Term, Atom),
	io_writelnt2(Atom).

ask_question(Question,Options,[Option]):-
	writeln(Question),
	seeing(Old),see(user),
  	io_ask_questiont(Options,Option),!,
  	see(Old).

io_ask_questiont( Options,Option ) :-
  !,
  io_write_options( Options ) ,
  io_select( Options, Selection), !,
  Selection = Option.

io_write_options( Options ) :-
  io_write_options2( Options,1 ) .

io_write_options2( [],_ ) .
io_write_options2( [Option|Tail],Index ) :-
  write( Index ) ,
  write( '  ' ) ,
  write( Option ) , nl ,
  NewIndex is Index + 1 ,
  io_write_options2( Tail,NewIndex ) .

io_select( Options,Option ) :-
  nl ,
  write( 'Select option : ' ) ,
  nl ,
  read( Input ) , !,
  io_select2( Options,Options,Input,1,Option ) ,
  nl .

io_select2( _,[Option|_],Index,Index,Option ) :-
  !.
io_select2( Options,[],_,_,Option ) :-
  !,
  nl,
  write( '[7mIllegal value selected.[0m' ) ,
%  audit_feedback('playsound laugh &'),
  nl ,
  io_ask_questiont( Options,Option ) .
io_select2( Options,[_|Tail],Input,Index,Option ) :-
  !,
  NewIndex is Index + 1 ,
  io_select2( Options,Tail,Input,NewIndex,Option ) .
