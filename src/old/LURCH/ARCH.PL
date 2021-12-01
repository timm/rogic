:- [arch_shell].

critical     is deletability     of function.
critical     is extensibility    of function.
critical     is modifiability    of process.
critical     is modifiability    of system.
critical     is modifiability    of function.
critical     is performance      of system.
critical     is reusability      of system.
critical     is spacePerformance of system.
critical     is timePerformance  of system.
critical     is updatability     of function.
veryCritical is modifiability    of dataRep.

rule0 says acceptance of system if 
        modifiability of system 
	and comprehensibility of system
	and performance of system
	and reusability of system .
	
rule1 says modifiability of system if
	helped by claim of c1
	and modifiability of process
	and modifiability of dataRep
	and modifiability of function.

rule2 says comprehensibility of system if
	coherence of system
	and simplicity of system.

rule3 says performance of system if
	helped by claim of c1
	and spacePerformance of system
	and  timePerformance of system.

rule4 says modifiability of function if
	extensibility of function
	%and deletability of function
	and updatability of function.

rule5 says coherence of system if
	helped by sharedData of targetSystem.

rule6 says extensibility of function if
	made by implicitInvocation of targetSystem
	or helped by sharedData of targetSystem
	or unhurt by abstractDataType of targetSystem
	   and unhurt by claim of c5.

rule7 says simplicity of system if
	made by pipeAndFilter of targetSystem.

rule8 says modifiability of process if
	unhurt by abstractDataType of targetSystem
	or unbroken by sharedData of targetSystem
		and helped by claim of c2. 

rule9 says modifiability of dataRep if
	unhurt by implicitInvocation of targetSystem
	or helped by abstractDataType of targetSystem
	or unbroken by pipeAndFilter of targetSystem
	or unhurt by sharedData of targetSystem
		and helped by claim of c2.

rule10 says reusability of system if
	helped by pipeAndFilter of targetSystem
	or helped by implicitInvocation of targetSystem
	or unhurt by sharedData of targetSystem
	or helped by abstractDataType of targetSystem
		and  helped by claim of c3.

rule11 says spacePerformance of system if
	unhurt by implicitInvocation of targetSystem
	or made by sharedData of targetSystem
	or unbroken by pipeAndFilter of targetSystem
		and helped by claim of c4.

rule12 says timePerformance of system if
	unbroken by implicitInvocation of targetSystem
	or unhurt by abstractDataType of targetSystem.

rule13 says updatability of function if
	helped by pipeAndFilter of targetSystem
	or helped by abstractDataType of targetSystem.

 