{printf("upf2sloc(\"");
 sep="";
 for(i=1;i<=NF-2;i++) {
      printf("%s,%s",sep,$i)
      sep=" "}
 printf(",%s).",$NF)
}