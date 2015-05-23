BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Bluetooth (vulnerable if present)
bluetooth=$(grep "GKSession\|MCSession\|CBCentralManager" $FILE)
  if [ -n "$bluetooth" ]
  then
      
      echo "The binary contains references to either GKSession or the  Multipeer Connection or Core Bluetooth frameworks, which provide Bluetooth capabilities to the application."
      echo "$bluetooth\n"

  else
      echo "no bluetooth"
  fi