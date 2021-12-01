% martin- order dont matter
% last arg: f
% keys are not f=y
:- [dd].

+source(s2,timm,when(2000,9,4,10,10,10),meta(s2,f)).

+r(r1,1,_,_,[],meta(s2,f)).
+r(r2,2,_,_,[],meta(s2,f)).

+f(f3,_,1,_,[],meta(s2,f)).
+f(f4,_,1,_,[],meta(s2,f)).

+p(p5,_,_,1,[],meta(s2,f)).
+p(p6,_,_,1,[],meta(s2,f)).

+aka(timm,"Nice guy", meta(s2,f)).
+aka(r1,happiness,    meta(s2,f)).
+aka(r2,wealth,       meta(s2,f)).
+aka(f3,sickness,     meta(s2,f)).
+aka(f4,marketCrash,  meta(s2,f)).
+aka(p5,vitamins,     meta(s2,f)).
+aka(p6,diversement,  meta(s2,f)).

+impact(f3,r1,0.1,meta(s2,f)).
+impact(f4,r1,0.2,meta(s2,f)).

+impact(f3,r2,0.3,meta(s2,f)).
+impact(f4,r2,0.4,meta(s2,f)).

+effect(f3,p5,0.8,meta(s2,f)).
+effect(f4,p5,0.1,meta(s2,f)).

+effect(f3,p6,0.3,meta(s2,f)).
+effect(f4,p6,0.5,meta(s2,f)).

:- verify.