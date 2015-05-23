BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Binary Protection – Stack Protection (vulnerable if absent)
stack=$(otool -Ivm $BIN |grep stack_chk)
  if [ "$stack" ] 
    then
      echo "Stack Protection Present:"
      echo $stack
    else
      echo "The application does not utilize a stack canary value to deter buffer overflow attacks. This protection is known as \"Stack Smashing\" protection. Stack Smashing protection can be added to iOS binaries by adding the -fstack-protector-all compiler flag."
  fi