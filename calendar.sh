BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Calendar (vulnerable if present)
calendar=$(grep "EKEventStore\|EKCalendar" $FILE)

    if [ -n "$calendar" ]
    then
        echo "The binary contains references to the EKEventStore class, which represents the calendar database."
        echo "$calendar\n"
        
    else
        echo "not using calendar"
    fi