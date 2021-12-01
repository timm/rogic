:- load_files([arrt],[if(changed),silent(true)]).

+source(v1,u0,when(2001,4,6,17,45,32)).
+aka(goal,"goal",v1).
+aka(u0,"Baseline",v1).
+aka(r1,"Top Level Requirement 1",v1).
+aka(f1,"Failure Mode 1",v1).
+aka(f2,"Failure Mode 2",v1).
+aka(p1,"PACT 1",v1).
+aka(p2,"PACT 2",v1).

+r(goal,1,  0,0,v1) :- r1.
+r(r1,  10, 0,0,v1).

+f(f2,  0.4,0,0,v1).
+f(f1,  1,  0,0,v1).

+p(p2,  1,  0,0,v1).
+p(p1,  1,  0,0,v1).

+impact(f1,r1,0.3,v1).
+impact(f2,r1,0.2,v1).

+effect(f1,p1,0.8,v1).
+effect(f2,p1,0.6,v1).
+effect(f1,p2,0.6,v1).
