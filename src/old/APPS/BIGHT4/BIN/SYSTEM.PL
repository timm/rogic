% this file should be all we need to change when we port

% change this fact to store the root load directory.
my_root('/usr/tim/src/pl/apps/bight4').

% change this fact to store the operating system dependent
% seperator character
my_sep_char('/').

% change this fact to store the files to load, and the order
% in which to load them.

my_system([   
         [bin, ops],
	 [bin, ram],
	 [bin, shimport],
	 [bin, shbehav],
	 [bin, shdilect],
         [bin, io],
	 [bin, strings],
	 [bin, lists],
	 [bin, shcompar],
	 [bin, misc],
	 [bin, shmain],
	 [bin, maths],
	 [bin, sets],
	 [bin, shfeatur],
	 [bin, shclump],
	 [bin, shabduct],
	 [bin, sh1world],
	 [bin, shvalid],
	 [bin, shresult],
	 [bin, shdemos],
	 [bin, shmutate],
	 [bin, wme],
	 [bin, loadlast]
]).

% change this fact to store the start up actions.
% (or put them into [bin, loadlast])

my_main :-
	my_system(Files),
%	write('loaded: '),
	my_main1(Files,1,8).

my_main1([],_,_).
my_main1([File|Files],N,NewLine) :-
/*	last(F,File),
	write(F), 
%	(0 is N mod NewLine
%	->   %nl 
%	|    %write(' '), 
%             %flush_output(user)), */
%	write(N), write(' '),flush_output(user),
	my_file(File,'.pl',Path),
	my_consult(Path),
	N1 is N + 1,
	my_main1(Files,N1,NewLine).

%-------------------------------------------
% from here down, there should be no changes.

my_consult(P) :- load_files([P],[silent(true)]).
%my_consult(P) :-
%	'$consult_file'(P,[]).
	
my_file(Path,F) :-  my_file(Path,'',F).

my_file(Path0,Extension,F) :-
	path_list(Path0,Path),
	my_root(Root), 
	my_sep_char(S0),
	name(S0,[S]),
	my_file1([Root|Path],S,[],F0),
	name(Extension,Temp),
	append(F0,Temp,F1),
	name(F,F1).
	
my_file1([Dir], _, F0, F) :-
	name(Dir,Temp), 
	append(F0,Temp,F).
my_file1([Dir|Dirs], S, F0, F) :- 
	name(Dir,Temp), 
	append(F0,Temp,F1),
	append(F1,[S],F2),
	my_file1(Dirs,S,F2,F).

path_list([Dir|Dirs],[Dir|Dirs]) :- !.
path_list(File,[File]).

loads :- my_main.

sys :- [system].

:- loads.
