:-  % stuff everyone may have to touch
   [ops
   
    % sys: stuff only the supplies need to touch
   ,sys/swi          % most of the swi-specific stuff is here.
   ,sys/magic    
   ,sys/utils       
   ,sys/oo/classes
   ,sys/oo/methods
   ,sys/oo/patterns
   ,sys/oo/t_
   ,sys/oo/eg_
 % ,sys/switches 
  
   % dev: stuff only the developers need to touch
   % the following files must be supplied by the developer

   %,dev/globals
   ,dev/coms

   % the next files are added at the developer's whim
   % ...

   % usr: stuff only the expert users need to touch
   ,usr/state_
   % ...

   % must be last
 % ,dev/go    
   

   ].

:- prolog.