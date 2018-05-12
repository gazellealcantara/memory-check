#!/bin/bash

# Get the % usage
PERCENTAGE_USED=$(free -m | grep "Mem:" | awk '{print $3/$2 * 100}')

cr=90
wa=50
em=email@mine.com

# Checking in the param
while getopts ":c:w:e:" opt
  do
    case $opt in
      c)
	cr=${OPTARG}
	;;
      w)
	wa=${OPTARG}
	;;
      e)
	em=${OPTARG}
	;;
    esac
done


# Sending mail if it has a warning or if it is critical
if [ "$wa" -ge "$cr" ]
	then
		echo "Critical should be more than warning percentage"
		exit 4
fi

if [ $( printf "%.0f" $PERCENTAGE_USED ) -ge $cr ]
	then
		echo | mail -s "$(date '+%Y%m%d %H:%M') memory check - critical" $em
		exit 2
elif [ $( printf "%.0f" $PERCENTAGE_USED ) -ge "$wa" ]
	then
		echo | mail -s "$(date '+%Y%m%d %H:%M') memory check - warning" $em
		exit 1
else
	exit 0
fi
