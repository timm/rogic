% mutate.pl

% Contains an (E)QCM model mutator.  There is an inherent assumption that
% there is not more than one link/line.

%-----------------------------------------------------------------------------
% Mutate a model by flipping varying numbers of links.  Requires the dialect,
% the IO file stems and the number of links to be modified.
%-----------------------------------------------------------------------------
mutateModel(Dialect, File1, File2, Del-Add-Change) :-
	% Load model into source predicate.
	load_dialect(Dialect),
	theory_file(Dialect, File1, '.the', InitName),
	see(InitName),
	current_stream(InitName,_,Stream),
	compileTheoryFile(Stream, 1, Dialect, 0, 10),
	seen, !,

	% perform mutations
	delLinks(Del),
	addLinks(Add),
	modifyLinks(Change),
	!,

	% Save model to new theory file.
	theory_file(Dialect, File2, '.the', FinalName),
	tell(FinalName),
	setof(LNum-L, source(LNum, L), Pairings),
	writeSource(Pairings),
	told.


%-----------------------------------------------------------------------------
% Delete the given number of links
%-----------------------------------------------------------------------------
delLinks(Number) :-
	setof(Link, separateLink(Link), Links),
	length(Links, Total),
	urandoms(Number, Total, Lines),
	delLinks1(Lines, Links).

% Given a list of line numbers, retract those links.
delLinks1([], _).
delLinks1([N|LineIndices], Links) :-
	nth1(N, Links, Line-Link),
	retract(source(Line, Link)),
	delLinks1(LineIndices, Links).


%-----------------------------------------------------------------------------
% Add given number of random links
%-----------------------------------------------------------------------------
addLinks(Number) :-
	setof(Line, Source^source(Line, Source), Lines),
	setof(Feat, separateFeature(Feat), Features),
	setof(Link, Edge^A^B^defEdge(Link,Edge,A,B), Links),
	last(Last, Lines),
	addLinks1(Number, Last, Features, Links).

% Given number of links to create, plus possible features and links to use,
% generate that number of random links (stored in db).
addLinks1(0, _, _, _).
addLinks1(Number0, Last, Features, Links) :-
	randomSelect(Features, 2, [_-ClassA-A, _-ClassB-B]),
	A \= B,
	checkFeatures(ClassA, ClassB),
	randomSelect(Links, 1, [LinkStyle]),
	defEdge(LinkStyle, Link, A, B),
	Line is Last + 1,
	assert(source(Line, Link)),
	Number is Number0 - 1,
	addLinks1(Number, Line, Features, Links).	


%-----------------------------------------------------------------------------
% Modify link values
%-----------------------------------------------------------------------------
% Select links, generate which are to be modified and modify them.
modifyLinks(Number) :- Number =< 0, !.
modifyLinks(Number) :-
	setof(Link, separateLink(Link), Links),
	length(Links, Total),
	urandoms(Number, Total, Lines),
	modifyLinks1(Lines, Links).

% Perform modifications to the links by swapping connections to opposite.
modifyLinks1([], _).
modifyLinks1([N|LineIndices], Links) :-
	nth1(N, Links, Line-Link0),
	retract(source(Line, Link0)),
	defEdge(Edge0, Link0, A, B),
	(oppEdge(Edge0, Edge); oppEdge(Edge, Edge0)),
	defEdge(Edge,  Link,  A, B),
	assert(source(Line, Link)),
	modifyLinks1(LineIndices, Links).


%-----------------------------------------------------------------------------
% Utilities for model mutation
%-----------------------------------------------------------------------------
writeSource([]).
writeSource([_-L|Rest]) :-
	print(L), write('.'), nl,
	writeSource(Rest).

% Separate a link from the rest of the model information.  Assuming only
% receiving allowable edges.
separateLink(Line-Link) :-
	source(Line, Link),
	defEdge(_, Link, _, _).

% Separate a feature from the rest of the model information.
separateFeature(Line-Class-Feat) :-
	source(Line, objects(Class) = List),
	member(Feat, List).

% Check that the first feature can effect the second
checkFeatures(Class1, Class2) :-
	class(FullClass1, Class1, _, _, _, _),
	class(FullClass2, Class2, _, _, _, _),
	can_effect(FullClass1, FullClass2).
checkFeatures(Class1, Class2) :-
	can_effect(Class1, Class2).
checkFeatures(Class1, Class2) :-
	class(FullClass1, Class1, _, _, _, _),
	can_effect(FullClass1, Class2).
checkFeatures(Class1, Class2) :-
	class(FullClass2, Class2, _, _, _, _),
	can_effect(Class1, FullClass2).
