min=$1
max=$2
rand=$(mysql -s -e "select rand()" | sed '/rand/d; /^.$/ d;')
echo "($max-$min)*$rand+$min" | bc