BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Shared Directories (vulnerable if present)
tmpdir=$(strings -a - < $FILE |grep "^/private/var/tmp\|^/var/tmp" | grep -v "\.m\|xcode")
  if [ "$tmpdir" ]
    then
      echo "The application accesses a shared directory, such as '/tmp'. If application files are created in a shared directory, anyone else with access to those files can modify or replace them. If temporary files are necessary, ensure they are stored in a directory that is restricted to the application, such as <Application_Home>/tmp/."
      echo "$tmpdir\n"
  else
    echo "Not sharing tmp directories"
  fi