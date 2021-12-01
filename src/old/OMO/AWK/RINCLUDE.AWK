 BEGIN {depthLimit=10}

 pass==1 && /^::/        { sub(/::/,""); this=$1; next}
 pass==1 && this != prev { known[this]=0; prev=this}
 pass==1                 { str[this,++known[this]]=$0}

 pass==2                 {eat(0,$0)} 

 function eat(depth, line,    x,a,i) {
  if ( ++depth  > depthLimit  ) { 
    print "include depth exceeded" > "/dev/tty";
    exit}
  else {sub(/^\#/,"",line);
        sub(/^\%/,"",line);
        split(line,a,/ /);
        if ( a[1] ~ /^\=include/ ) {
           if ( a[2] in known ) {
	     for(i=1;i<=known[a[2]];i++) {
	       eat(depth,str[a[2],i]);
	     }
	   }
	   else {
	     while ( ( getline x < a[2] ) > 0) { 
	       eat(depth,x);
	     };
	     close(a[2])}
	} else  { 
	  print line}
  }
 }
