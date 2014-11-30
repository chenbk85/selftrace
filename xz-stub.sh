o=/tmp/I;sed 1d $0|xz -d>$o;chmod +x $o;$o $@;exec rm $o
