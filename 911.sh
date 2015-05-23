BIN="/private/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Binary Protection - ARC (vulnerable if absent)
arc=$(strings -a - < $FILE |grep “_objc_release\|_objc_autoreleaseReturnValue\|_objc_retain”)
  if [ $? -gt 0 ] # $? exit code of last execute command
    then 
      echo "Application is not using ARC protection"
    else
      echo $arc
  fi

#Binary Protection – Stack Protection (vulnerable if absent)
stack=$(otool -Ivm $BIN |grep stack_chk)
  if [ $? -gt 0 ] 
    then
      echo "Stack Protection not present"
    else
      echo $stack
  fi

#Binary Protection – Path Disclosure (vulnerable if present) need unecrypted
  path=$(strings -a - $UnencryptedFile |grep "/Users/" |cut –d/ -f3| sort –u) #remember needs unnecrypted binary and grep returns usernames associated with Mac
    fi [ $? -gt 0 ]
      then
        echo "No usernames found"
      else
        echo $path
    fi

# #Binary Protection – PIE (vulnerable if PIE is absent)
pie=$(otool -hvm $BIN)
  if [ $? -gt 0 ] 
    then
      echo "Stack Protection not present"
    else
      echo $pie
  fi

#Weak Crypto (vulnerable if present)
crypto=$(strings -a - < $FILE |grep “CC_MD2\|CC_MD4\|CC_MD5\|CC_SHA1\|kCCAlgorithmDES”)
  if [ $? -gt 0 ] 
    then
      echo "Sweet no old crypto!"
    else
      echo $crypto
  fi

#Data Protection API Use (vulnerable if absent)
dpi=$(strings -a - < $FILE |grep “NSDataWritingFileProtectionComplete$\|NSFileProtectionComplete$\|NSDataWritingFileProtectionCompleteUnlessOpen$\|NSFileProtectionCompleteUnlessOpen$\|NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication$\|NSFileProtectionCompleteUntilFirstUserAuthentication$”)
    if [ $? -gt 0 ] 
      then
        echo "The app is not using the Data Protection API"
      else
        echo $dpi
    fi

#Unencrypted URLs
urls=$(grep -oE "\bhttp://[^<>[:space:]]*[^\"[:space:]<>']" $FILE |grep -v "^http://$\| http\|www.apple.com/appleca\|www.apple.com/DTDs\|phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware\|ns.adobe.com"|sort -u)
  echo urls

#Jailbreak Detection (vulnerable if absent)
jail=$(strings -a - < $FILE |grep "^/bin/bash$\|^/Applications/Cydia.app$\|/cydia.log$\|cydia://")
  if [ $? -gt 0 ] 
    then
      echo "No Jailbreak Proection"
    else
      echo $jail
  fi


# #Shared Keychain (vulnerable if present)
keychain=$(grep "_kSecAttrAccessGroup$" $FILE)
        if [ $? -gt 0 ]
    then
      echo "Not using shared keychain"
    else
        echo $keychain
        fi


#Logging (vulnerable if present)
nslog=$(grep "_NSLog$" $FILE)
  if [ $? -gt 0 ]
    then
      echo $nslog
    else
      echo "Not Logging"
  fi

#Pasteboard (vulnerable if present)
pboard=$(grep -i "generalpasteboard" $FILE)
  if [ -n "$pboard" ]
  then
      echo "The binary contains references to the generalPasteboard method."
  else
      echo "noalert for Pasteboard"
  fi

#Bluetooth (vulnerable if present)
bluetooth=$(grep "GKSession\|MCSession\|CBCentralManager" $FILE)
  if [ -n "$bluetooth" ]
  then
      
      echo "The binary contains references to either GKSession or the  Multipeer Connection or Core Bluetooth frameworks, which provide Bluetooth capabilities to the application."

  else
      echo "noalert bluetooth"
  fi

#Calendar (vulnerable if present)
calendar=$(grep "EKEventStore\|EKCalendar" $FILE)

    if [ -n "$calendar" ]
    then
        echo "The binary contains references to the EKEventStore class, which represents the calendar database."
        
    else
        echo "noalert calendar"
    fi

#Geolocation (vulnerable if present)
  loc=$(grep -i "cllocation" $FILE)
  log "Geolocation check returns:\n$loc"
  if [ -n "$loc" ]
  then
      echo "Geolocation check returned"
  else
      echo "no GEO alert"
  fi

#Unencrypted Photo Storage (vulnerable if present)
photostore=$(grep "UIImageWriteToSavedPhotosAlbum\|sharedPhotoLibrary" $FILE)
  
    if [ "$photostore" ]
    then
        
        echo "The binary contains references to the UIImageWriteToSavedPhotosAlbum method."
    
    else
        echo "no unecrypted photo Storage"
    fi

#Address Book (vulnerable if present)
add=$(strings -a - < $FILE |grep "ABAddressBookCopyArrayOfAllPeople\|ABAddressBook")
  if [ "$add" ]
    then
      echo $add
    else
      echo "Not using AddressBook"
  fi

#Push Notifications (vulnerable if present)
pushnotreg=$(grep -i "registerForRemoteNotificationTypes\|registerForRemoteNotifications" $FILE)
pushnottok=$(grep -i "didRegisterForRemoteNotificationsWithDeviceToken" $FILE)

if [ "$pushnotreg" ] && [ "$pushnottok" ]
then
    
    echo "This app is using Push Notifications. The binary contains references to methods used to register a device for push notifications, registerForRemoteNotificationTypes and didRegisterForRemoteNotificationsWithDeviceToken."

else
    echo "noalert for push notifications"
fi

#Client-Side SQL Injection (vulnerable if present)
sql=$(strings -a - < $FILE |grep -i "^begin transaction\|^select .* from \|^update .* set \|^delete from \|^insert into " | grep "%@" | grep -v "SELECT id,access_token FROM test_account WHERE app_id")
  if [ $sql ]
    then
    echo $sql
  else
    echo "no sqli"
  fi

# #sqlite3_prepare (vulnerable if present) 
sqlite3=$(grep "sqlite3_prepare$" $FILE)

if [ "$sqlite3" ]
then
        
        echo "The binary contains references to the deprecated function sqlite3_prepare."
else
        echo "no sqli3 alert"
fi

#Insecure SSL Handling (vulnerable if present)
ssl=$(strings -a - < $FILE |grep "setAllowsAnyHTTPSCertificate\|kCFStreamSSLAllowsExpiredRoots\|kCFStreamSSLAllowsExpiredCertificates\|kCFStreamSSLAllowsAnyRoot")
  if [ -n "$ssl" ]
    then
    echo "The binary contains references to methods that may result in vulnerable SSL connections"
  else
    echo "No vulnerable SSL connections"
  fi
#Shared Directories (vulnerable if present)
dir=$(strings -a - < $FILE |grep "^/private/var/tmp\|^/var/tmp" | grep -v "\.m\|xcode")
  if [ -n "$dir" ]
    then
    echo "This binary is using shared Directories"
  else
    echo "No worries about shared Directories"
  fi

#UDID transfer, including over HTTPS (vulnerable if present)
udid=$(strings -a - < $FILE |grep ://| grep -i "udid")
if [ -n "$dir" ]
  then
  echo "This binary is using shared Directories"
else
  echo $udid
fi

#URL Schemes (vulnerable if present)
url_schemes=$(strings -a - < $FILE |grep -oE "[a-zA-Z][a-zA-Z0-9\+\-\.]*://[^[:space:]\<\>\#\"\']+"|grep -v "http://\|https://\|radr://"| sort –u)
if [ "url_schemes" ]
  then
  echo "The application uses custom URL Schemes (protocol handlers) to communicate with other iOS apps on the phone. When registering a custom URL scheme it is important to apply input validation to that receiver. The use of regular expressions to whitelist input characters and maximum length from other applications is recommended."
else
  echo "clear"
fi
