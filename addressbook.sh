BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Address Book (vulnerable if present)
add=$(strings -a - < $FILE |grep "ABAddressBookCopyArrayOfAllPeople\|ABAddressBook")
  if [ "$add" ]
    then
      echo "The application accesses contacts. This type of functionality should only be used if the application has need for that data. Otherwise, using this data or sending it to third parties constitutes a privacy violation."
      echo $add
    else
      echo "Not using AddressBook"
  fi