:- [shell].

phase(1,requirements).
phase(2,design).
phase(3,programming).
phase(4,integration).
phase(5,deployment).

%---------------------------------------------------------


ivv(fullPhase,   [1,2,3,4,5]).
ivv(development, [1,2,3]).
ivv(early,       [1,2]).
%ivv(requirements,[1]).
ivv(design,      [2]).
ivv(programming, [3]).
ivv(integration, [4]). 
ivv(deployment,  [5]). 

%---------------------------------------------------------

reworkByPhase(coyle99,10, 100, 1000 ).
reworkByPhase(remus83 ,1,  20,   82 ).
reworkByPhase(kan89,   1,  13,   92 ).

%---------------------------------------------------------

% per KSLOC
defectDensity(akiyama72, 20).
defectDensity(rbey75,     4).
defectDensity(endres75,   5).
defectDensity(thayer78,  26).
%defectDensity(belford79, 57).
defectDensity(hatton94,   6).
defectDensity(sunazuka83,    16  ). 
defectDensity(capersjonesAda,  17  ).
defectDensity(capersjonesC,   13.7).

%---------------------------------------------------------

%cmm(1).
%cmm(2).
cmm(3).
%cmm(4).
%cmm(5).

%reworkSaved(_,1).

reworkSaved(X,X) :- X is max(0,normal(0.2,0.1)).
%reworkSaved(ken,0.15).
%reworkSaved(warren,1).
%reworkSaved(pessimist,0.05).
%reworkSaved(optimist,0.3).

ksloc(10).
budget(100000).

leakages(    %requirements
             %   %design
             %   %   %programming
         [[ 49,  681,    0 ] % design
         ,[ 39, 113,  2004 ] % programming 
         ,[ 26,  49,   418 ] % integration
         ,[  8,  16,    56 ] % deployment
         ]).

doubts(0.1). 

cmmRework(1,0.55).
cmmRework(2,0.45).
cmmRework(3,0.35).
cmmRework(4,0.20).
cmmRework(5,0.06). 




costToFix(_,1).
 
