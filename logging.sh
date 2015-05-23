BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Logging (vulnerable if present)
nslog=$(grep "_NSLog$" $FILE)
  if [ -n "$nslog" ]
    then
      echo "The application has logging enabled. Ensure this logging doesn't reveal sensitive data. It is good practice to only use logging in the DEBUG/Development phases of design."
      echo "$nslog\n"
    else
      echo "Not Logging"
  fi