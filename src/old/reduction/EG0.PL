:- [dd].

+source(v2,timm,when(2000,9,4,10,10,10)).

+r(1,1,_,_,v2).
+r(2,2,_,_,v2).

+f(3,_,1,_,v2).
+f(4,_,1,_,v2).

+p(5,_,_,1,v2).
+p(6,_,_,1,v2).

+aka(timm,"Nice guy",v2).
+aka(r(1),happiness,v2).
+aka(r(2),wealth,v2).
+aka(f(3),sickness,v2).
+aka(f(4),marketCrash,v2).
+aka(p(5),vitamins,v2).
+aka(p(6),diversement,v2).

+impact(f(3),r(1),0.1,v2).
+impact(f(4),r(1),0.2,v2).

+impact(f(3),r(2),0.3,v2).
+impact(f(4),r(2),0.4,v2).

+effect(f(3),p(5),0.8,v2).
+effect(f(4),p(5),0.1,v2).

+effect(f(3),p(6),0.3,v2).
+effect(f(4),p(6),0.5,v2).
