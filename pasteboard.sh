BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Pasteboard (vulnerable if present)
pboard=$(grep -i "generalpasteboard" $FILE)
  if [ "$pboard" ]
  then
      echo "The binary contains references to the generalPasteboard method."
      echo "$pboard\n"
  else
      echo "Application is not using Pasteboard"
  fi