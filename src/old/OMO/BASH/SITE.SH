
#=head1 Support code for site


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
      		sitemap > /dev/null
      		echo "."
      		exit
 	fi
 }

#Make the site map

 makesitemap() {
	(cat $TXT/mypod_contents_header.txt
	echo "<p><nobr>"
	sitemap
	echo "</table>"
	cat $TXT/mypod_contents_footer.txt) > html/mypods_contents.html
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
    echo "<a target=Content href="../${file}.html">$2</a><br 
             clear=all>"
  }

#=head2 Start-up code

 main() {
    ones $1; makesitemap; echo "."
 }
