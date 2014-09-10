#!/bin/bash
# encode ISO level

ISOlevel=$1

case "$ISOlevel" in
	50) echo "0"
	;;
	100) echo "1"
	;;
	200) echo "4"
	;;
	400) echo "7"
	;;
	800) echo "A"
	;;
	1600) echo "D"
	;;
	3200) echo "E"
	;;
	Debug:*) echo -e "\033[34mDebuging ...\033[0m"
	;;
esac	

