
#=head1 Support code for site

#Make sure we have somewhere to talk to.

 if [ ! -d tmp ]
 then mkdir tmp
 fi

#=head2 Header, Footer

 heading() {
     echo "<p><b>$1:</b><br>"
 }
 footer()  {
     echo ""
 }
 section() {
     footer
     heading $1
 }

#=head2 Main

#Catch the case where there is only one thing to update.

 ones() {
	 if   	[ $# -eq 1 ]
	 then 	one=$1
      		map > /dev/null
      		echo "."
      		exit
 	fi
 }

#Make the site map

 get() {
     if [  -f "$1" ]
     then cat $1
     else echo "missing $1"
	  exit
     fi
 }

 makesitemap() {
	(get $TXT/mypod_contents_header.txt
	echo "<p><nobr>"
	map
	echo "</table>"
	get $TXT/mypod_contents_footer.txt) > tmp/mypods_contents.html
	chmod a+rx . 
	chmod a+r *
 }

 go() {
    if   [   -n "$one"   ]
    then if [  "$one" != "$1"  ]
         then return 0
         fi
    fi
    $SH/mypod $SIZE $STRINGS $1  $2 
    file=${1%.*}
    file=`basename $file`
    echo "<a target=Content href="../${file}.html">$2</a><br 
             clear=all>"
  }

#=head2 Start-up code

 main() {
    ones $1; makesitemap; echo "."
 }
