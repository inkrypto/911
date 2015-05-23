BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Unencrypted URLs
urls=$(grep -oE "\bhttp://[^<>[:space:]]*[^\"[:space:]<>']" $FILE |grep -v "^http://$\| http\|www.apple.com/appleca\|www.apple.com/DTDs\|phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware\|ns.adobe.com"|sort -u)
  if [ -n "$urls" ]
    then
      echo "$urls\n"
    else
      echo "No Unencrypted URLs found"
  fi
  
