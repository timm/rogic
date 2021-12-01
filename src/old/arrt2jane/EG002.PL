:- [arrt].

+source(v1,u0,when(2001,4,6,17,45,32)).
+aka(goal,"goal",v1).
+aka(u0,"Baseline",v1).
+aka(r9,"Top Level Requirement 1",v1).
+aka(r11,"Subsidiary Requirment 1.1",v1).
+aka(r12,"Subsisiary Requirement 2.1",v1).
+aka(r10,"Top Level Requirement 2",v1).
+aka(f13,"Failure Mode 1",v1).
+aka(f14,"Failure Mode 2",v1).
+aka(f15,"Failure Mode 3",v1).
+aka(p16,"PACT 1",v1).
+aka(p17,"PACT 2",v1).
+aka(p18,"PACT 3",v1).
+r(r10,10,1,0,v1).
+r(r12,1,1,0,v1).
+r(r11,1,1,0,v1).
+r(goal,1,0,0,v1) :- r9.
+r(r9,  1,0,0,v1) :- r11,r12,r10.
+f(f15,0,1,0,v1).
+f(f14,0,1,0,v1).
+f(f13,0,1,0,v1).
+p(p18,0,0.5,100,v1).
+p(p17,0,0.5,10,v1).
+p(p16,0,0.5,1,v1).
+impact(f13,r11,0.1,v1).
+impact(f14,r11,0.2,v1).
+impact(f15,r11,0.3,v1).
+impact(f13,r12,0.4,v1).
+impact(f14,r12,0.5,v1).
+impact(f15,r12,0.6,v1).
%+impact(f13,r10,0.7,v1).
%+impact(f14,r10,0.8,v1).
%+impact(f15,r10,0.9,v1).
%+effect(f13,p16,0.11,v1).
+effect(f14,p16,0.22,v1).
+effect(f15,p16,0.33,v1).
%+effect(f13,p17,0.44,v1).
+effect(f14,p17,0.55,v1).
+effect(f15,p17,0.66,v1).
%+effect(f13,p18,0.77,v1).
+effect(f14,p18,0.88,v1).
+effect(f15,p18,0.99,v1).




