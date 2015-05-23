BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Binary Protection – PIE (vulnerable if PIE is absent)
pie=$(otool -hvm $BIN)
  if [ "$pie" ] 
    then
      echo "The application is using PIE:"
      echo "$pie\n"
    else
      echo "The application does not utilize the Position Independent Executable compilation flag, which strengthens the ASLR protection of iOS applications. Without this protection attackers may be able to execute exploits against the application in an easier fashion than if the flag was enabled. PIE can be enabled in the compiler by adding the -fPIE flag."
  fi
