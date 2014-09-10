#!/bin/bash
# set iso with gphoto
# first argument is the new ISO level, given back on success
newiso=$1
# second the old ISO level or something else, which is given back, if switch fails
oldiso=$2
# counter initialise
count=0

# repeat the gphoto2 command several times until success
while [ $count -lt 5 ]
do
	count=$(( $count + 1))
	output="$((gphoto2 --set-config iso=$newiso) 2>&1)"
	error="$(echo $output | grep -o 'ISO Einstellung geändert')"
	echo -e "Try:$count\t\033[33moutput:$output\t\033[1m$error\033[0m" >&2
	# check for success
	if [ "$error" == "ISO Einstellung geändert" ]
		then 
			# when success, oldiso = newiso and break out the loop
			oldiso=$newiso
			break
	fi
done
# return back result
echo $oldiso