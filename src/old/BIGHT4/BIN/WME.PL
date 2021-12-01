% there are several categories of working memory elements (wme's),
% depending on when we should update them
% dialect  : change whenever the dialect changes
% names    : changes whenever the names of things are changed.
%            note that names refer to things from a modeling 'dialect'.
% theory   : change whenever the theory changes
%            note that theories connect 'name'd things.
% theoryDetail:
%            low level stuff deduced from the theory; e.g. any indexes.
% data     : change whenever the data  set changes
%            note that data measures 'model'led things.
% datum    : changed whenever the particular input-outpus are changed
%            note that data are sets of datum.
% run      : changed at inference time
% other    : changed at some other time.
 
% class........................class(name : string, shortName : string,
%				     positiveDomain : < list of string 
%                                               | lower : int - upper : int >,
%				     neutralDomain : < list of string 
%                                               | lower : int - upper : int >,
%				     negativeDomain : < list of string 
%                                               | lower : int - upper : int >,
%                                     kind   : <discrete  | continuous>).
wme(dialect, class(_,_,_,_,_,_)).

wme(dialect,link(_,_,_)).

wme(dialect,can_effect(_,_)).

wme(dialect,asymmetrical(_)).

wme(dialect,invariant(_)).

wme(dialect,ok2Fail(_)).

% classObjectIndex...............coi(class : string, objectId: posint)
wme(theoryDetail,   coi(_,_)). 

% depedancy graph..................d(name : string).
wme(theory,d(_)).

% edgeIndex.......................ei(parent,edgeId : posint).
wme(theoryDetail,ei(_,_)).

% edgeBackwardsIndex.............ebi(child,edgeId : posint).
wme(theoryDetail,ebi(_,_)).

wme(dialect,defEdge(_,_,_,_)).

% invariant violation report.......i(id1 : posint, id2 : posint).
wme(theory,i(_,_)).

% in..............................in(id : posint).
wme(datum,in(_)).

% data...........................data(exp : atom, list of actions, 
%                                     list of measurements).
wme(data,data(_,_,_)).

% kids...........................kids(vid: posint, kids: set of posint).
wme(theoryDetail,kids(_,_)).

% literalVertexIndex.............lvi(literalId, vertex : posint).
wme(theoryDetail, lvi(_,_)).

% object...........................o(id : posint, name : string, 
%                                    class : string). 
wme(names,o(_,_,_)).

% objectLiteralIndex.............oli(class: string, lid : posint)
wme(theoryDetail,oli(_,_)).

% out............................out(id : posint, ).
wme(datum,out(_)).

% parents....................parents(vid : posint, parents : set of posint)
wme(theoryDetail,parents(_,_)).

% proof............................p(id : symbol, what : posint, 
%                                    cost : posint,
%                                    edges, vertices, a, forbids, ab, roots,
%                                    type : < edges | isolated | easy >).

wme(theory,source(_,_)).

% edge.............................e(id,from,to,cost,source:  posint).
wme(theory,e(_,_,_,_,_)).

% vertex...........................v(id, literal : posint, 
%                                    andor : <and | or>).
wme(theory,v(_,_,_)).


% literal..........................l(id : posint, object: string, value).
wme(theory,l(_,_,_)).


% world............................w(id : posint ,causes0,covers0 : {posint},
%                                    cost: posint, sources,
%                                    edges,vertices : {posint}, 
%                                    proofs : [symbol], 
%                                    forbids, a,ab,x : {posint})

wme(run,a(_)). 
wme(run,ac(_)).
wme(run,aProof(_)).
wme(run,stopTime(_)).
%wme(datum,clumpAble(_,_,_,_)).
%wme(datum,clump_data(_,_,_,_,_,_,_)).
wme(datum,culled(_)).
wme(datum,inStar(_)).
wme(theoryDetail,noGoods(_,_)).

:- wmeSetUp.

