gawk -F, 'BEGIN {
name[1]="orsCostCombine"
name[2]="r8cost"
name[3]="r8chances"
name[4]="r9cost"
name[5]="r9chances"
name[6]="r10cost"
name[7]="r10chances"
name[8]="r11cost"
name[9]="r11chances"
name[10]="true"
name[11]="baseball"
name[12]="content"
name[13]="enthusiasm"
name[14]="exercise"
name[15]="football"
name[16]="happy"
name[17]="healthy"
name[18]="likesSweat"
name[19]="class"
}


{
printf("[domain=eg,dataset=1]= [")
one(1,"")
for(i=2;i<=18;i++) one(i,",")
print classes($19)
}

function classes(c) {
  if ( c ~ /cch/ ) return "] -> [cost=lo,chances=lo]."
  if ( c ~ /cCH/ ) return "] -> [cost=lo,chances=hi]."
  if ( c ~ /Cch/ ) return "] -> [cost=hi,chances=lo]."
  if ( c ~ /CCH/ ) return "] -> [cost=hi,chances=hi]."
}

function one(i,s) {
    if (  $i !~ /xx/ ) {
      printf("%s%s=%s",s,name[i],$i,s)
   }
}' eg.data > eg.pl 


