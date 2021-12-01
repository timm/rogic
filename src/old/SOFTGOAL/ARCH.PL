:- ensure_loaded(softgoal).

domain('Software architectures').
author('Tim Menzies (tim@menzies.com)').
creation('July 4, 2000').

define([abstractDataType
       ,coherence
       ,comprehensibility
       ,deliverability
       ,extensibility
       ,implicitInvocation
       ,modifiability
       ,performance
       ,pipeAndFilter
       ,reusability
       ,sharedData
       ,simplicity
       ,spacePerformance
       ,timePerformance
       ,updatability
       ]).

critical     deliverability of function.
critical     extensibility of function.
critical     modifiability of process.
critical     modifibaility of system.
critical     performance of system.
critical     reuabililty of system.
critical     spacePerformance of system.
critical     timePerformance of system.
critical     updatability of function.
veryCritical modifiability of dataRep.

rule1 says modifiability of system if
	claim of c1
	and modifiability of processes
	and modifiability of dataRep
	and modifiability of function.

rule2 says comprehensibility of system if
       coherence of system
       and simplicity of system.

rule3 says performance of system if
         claim of c1
         and spacePerformance of system
         and  timePerformance of system.

rule4 says modifiability of function if
         extensibility      of function
         and deliverability of function
         and updatability   of fuction.

rule5 says coherence of system if
     helped by sharedData of targetSystem.

rule6 says extensibility of function if
     made by implicitInvocation of targetSystem
     or helped by sharedData of targetSystem
     or helped by abstractDataType of targetSystem
        and not claim of c1.

rule7 says modifiability of dataRep if
     unbroken by pipeAndFilter of targetSystems.

rule8 says modifiability of processes if
     unhurt by abstractDataType of targetSystems
     or unbroken by sharedData of targetSystems
        and claim of c2. 

rule9 says modifiability of dataRep if
     unhurt by implicitInvocation of targetSystem
     or helped by abstractDataType of targetSystems
     or unhurt by sharedData of targetSystems
        and claim of c2.

rule10 says reusability of system if
     helped by pipeAndFilter of targetSystems
     or helped by implicitInvocation of targetSystem
     or unhurt by sharedData of targetSystem
     or helped by abstractDataType of targetSystem
        and claim of c3.

rule11 says simplicity of system if
     made by pipeAndFilter of targetSystems.

rule12 says spacePerformance of system if
     unhurt by implicitInvocation of targetSystem
     or made by sharedData of targetSystem
     or unbroken by pipeAndFilter of targetSystems
        and claim of c4.

rule13 says timePerformance of system if
     unhurt by implicitInvocation of targetSystem
     or unhurt by abstractDataType of targetSystems.

rule14 says updatability of function if
      helped by pipeAndFilter of targetSystems
      or helped by abstractDataType of targetSystems.
