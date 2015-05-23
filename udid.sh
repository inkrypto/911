BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#UDID transfer, including over HTTPS (vulnerable if present)
udid=$(strings -a - < $FILE |grep ://| grep -i "udid")
  if [ -n "$dir" ]
    then
      echo "The Application is transfer the UDID as a parameter"
      echo "$udid\n"
    else
      echo "Not transfering the UDID"
  fi