BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt
#URL Schemes (vulnerable if present)
url_schemes=$(strings -a - $FILE |grep -oE "[a-zA-Z][a-zA-Z0-9\+\-\.]*://[^[:space:]\<\>\#\"\']+"|grep -v "http://\|https://\|radr://"| sort –u)
  if [ "url_schemes" ]
    then
      echo "The application uses custom URL Schemes (protocol handlers) to communicate with other iOS apps on the phone. When registering a custom URL scheme it is important to apply input validation to that receiver. The use of regular expressions to whitelist input characters and maximum length from other applications is recommended."
      echo "$url_schemes\n"
    else
      echo "clear"
  fi