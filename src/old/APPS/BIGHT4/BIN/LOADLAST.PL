:- wmeSetUp. 

:- dynamic option/2.

:- dynamic p/3, p/5, new_p/1, ps/2, ps/3.   

:- selectorShell(p,new_p,ps,     
	p(id,x,cost,edges,vertices,forbids,ab, roots, type)).	

:- dynamic rs/2, rs/5, new_rs/1, rss/2, rss/3.

:- selectorShell(rs,new_rs,rss,
       rs(pInStar,
	       pa,
	       pac,
	       proofs,
	       nWorlds,
	       nBestWorlds,
	       bestCovered,
	       time,
	       validataionTime,
		worldsSweepTime,
	      backSweepTime,
              forwardsSweepTime,
		prepTime,
		dataExtractionTime)).



:- tPrintOn.  



 

