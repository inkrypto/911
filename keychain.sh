BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Shared Keychain (vulnerable if present)
keychain=$(grep "_kSecAttrAccessGroup$" $FILE)
  if [ -n "$keychain" ]
    then
      echo "The binary contains references to kSecAttrAccessGroup, which is used to set up shared keychain access."
      echo "$keychain/n"
    else
      echo "The Application is not using Shared Keychain"
  fi