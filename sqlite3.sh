BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#sqlite3_prepare (vulnerable if present) 
sqlite3=$(grep "sqlite3_prepare$" $FILE)
  if [ "$sqlite3" ]
    then
      echo "The applications uses the 'sqlite3_prepare' function for database calls. This function has been deprecated and is known to contain security weaknesses. Use 'sqlite3_prepare_v2' as an alternative."
      echo "$sqlite3\n"
    else
      echo "no sqlite3 detected"
  fi