BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Geolocation (vulnerable if present)
loc=$(grep -i "cllocation" $FILE)
  if [ -n "$loc" ]
    then
      echo "The application uses geolocation data. This data, while valuable for some functions of mobile applications, can also constitute a privacy leak should the application store or send it unencrypted or to a 3rd party not authorized by the phone's owner."
      echo "$loc\n"
    else
      echo "no GEO alert"
  fi