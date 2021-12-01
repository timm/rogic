cat $1 | tr A-Z a-z > lc.tmp
(echo 'tokens(['
sed -f prep.sed lc.tmp
echo 'eof]).' )> lc.tok
