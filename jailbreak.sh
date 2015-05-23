BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Jailbreak Detection (vulnerable if absent)
jail=$(strings -a - < $FILE |grep "^/bin/bash$\|^/Applications/Cydia.app$\|/cydia.log$\|cydia://")
  if [ "$jail" ] 
    then
      echo "Jailbreak Proection:"
      echo "$jail\n"
    else
      echo "The application does not attempt to detect the presence of jailbreak on devices."
  fi