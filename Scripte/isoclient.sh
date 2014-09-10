#!/bin/bash
# ISO level switch with gphoto2, controlled over serial/usb device Arduino

# delay for start at boottime
echo "5 Seconds delay ..."
sleep 5
echo "over"

# config serial communication
echo "config USB/serial interface ..."
#stty -F /dev/ttyACM0 raw ispeed 9600 ospeed 9600 -ignpar cs8 -cstopb -echo
stty -F /dev/ttyACM0 ispeed 9600 ospeed 9600 -ignpar cs8 -cstopb -echo -hupcl
#stty -F /dev/ttyACM0 cs8 9600 ignbrk -brkint -icrnl -imaxbel -opost -onlcr -isig -icanon -iexten -echo -echoe echok -echoctl -echoke noflsh -ixon -crtscts -hupcl


# let's go ...
echo "wait ... (communicate with photocamera)"
# first, get current ISO step
ISOstep="$(gphoto2 --get-config iso | grep -o 'Current: [0-9]\{3,4\}'| grep -o '[0-9]\{3,4\}')"
# clear
oldISO=0
ISOlvl=0

echo "start ISO level remote control"

while read line 
	do
		
	case "$line" in
		ISO) ISOstep="$(gphoto2 --get-config iso | grep -o 'Current: [0-9]\{3,4\}'| grep -o '[0-9]\{3,4\}')"
		   ISOcode="$(./encodeisolevel.sh $ISOstep)"
		   echo "current ISO: $ISOstep"
		   echo "$ISOcode" > /dev/ttyACM0
		   oldISO=$ISOstep
		;;
		
		0) ISOlvl="$(./setiso.sh '50' $oldISO)"
		   ./encodeisolevel.sh $ISOlvl > /dev/ttyACM0
		   echo "set ISO:50"
		   oldISO=$ISOlvl
		;;		
		1) ISOlvl="$(./setiso.sh '100' $oldISO)"
		   ./encodeisolevel.sh $ISOlvl > /dev/ttyACM0
		   echo "set ISO:100"
		   oldISO=$ISOlvl
		;;

		4) ISOlvl="$(./setiso.sh '200' $oldISO)"
		   ./encodeisolevel.sh $ISOlvl > /dev/ttyACM0
		   echo "set ISO:200"
		   oldISO=$ISOlvl
		;;

		7) ISOlvl="$(./setiso.sh 400 $oldISO)"
		   ./encodeisolevel.sh $ISOlvl > /dev/ttyACM0
		   echo "set ISO:400"
		   oldISO=$ISOlvl
		;;

		A) ISOlvl="$(./setiso.sh 800 $oldISO)"
		   ./encodeisolevel.sh $ISOlvl > /dev/ttyACM0
		   echo "set ISO:800"
		   oldISO=$ISOlvl
		;;

		D) ISOlvl="$(./setiso.sh 1600 $oldISO)"
		   ./encodeisolevel.sh $ISOlvl > /dev/ttyACM0
		   echo "set ISO:1600"
		   oldISO=$ISOlvl
		;;

		E) ISOlvl="$(./setiso.sh 3200 $oldISO)"
		   ./encodeisolevel.sh $ISOlvl > /dev/ttyACM0
		   echo "set ISO:3200"
		   oldISO=$ISOlvl
		;;
		
		"FototimerNG serial communication started") echo -e "\033[32mcommunication with Fototimer estabilshed\033[0m"
		   ISOcode="$(./encodeisolevel.sh $ISOstep)"
		   echo "$ISOcode" > /dev/ttyACM0
		   oldISO=$ISOstep						
		   echo "current ISO: $ISOstep"
		;;
		Debug:*) echo -e "\033[34m$line\033[0m"
		;;
		poweroff) echo "power off now ..."
		sleep 3		
		# return 'para' ASCII 182 to set ISO level to zero		
		echo "¶" > /dev/ttyACM0
		sudo poweroff
		break
		;;
		*) echo -e "\033[31mreceived and ignored unknown command: \033[1m»$line«\033[0m"
		;;
	esac
done < /dev/ttyACM0

# ... til the end
echo "end"
sleep 3
#end


