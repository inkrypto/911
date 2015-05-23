#!/bin/bash

echo "Enter the path to the binary you wish to test. For instance, /var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/UberClient.app/UberClient "
echo -n "Paste path here: "

read BIN

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

echo ""
echo "Checking for vulnerabilities"
echo "1. Binary Protection ARC (vulnerable if absent)"
arc=$(strings -a - < $FILE |grep "_objc_release\|_objc_autoreleaseReturnValue\|_objc_retain")
  if [ "$arc" ]
    then 
      echo "Application is using ARC protection. Not vulnerable"
      echo ""
    else
      echo "VULN NAME: ARC"
      echo "The application does not use the provided iOS memory management framework, ARC. ARC stands for Automatic Reference Counting and builds in intelligent \"Garbage Collection\" and memory deallocations. While not using ARC is not a vulnerability per se, it is highly recommended. Manual memory management in iOS requires a lot of overhead in Objective-C and if not done right can lead to performance losses and security vulnerabilities."
      echo ""
  fi

echo "2. Bluetooth (vulnerable if present)"
bluetooth=$(grep "GKSession\|MCSession\|CBCentralManager" $FILE)
  if [ "$bluetooth" ]
    then
      echo "VULN NAME: Bluetooth"
      echo "The binary contains references to either GKSession or the  Multipeer Connection or Core Bluetooth frameworks, which provide Bluetooth capabilities to the application."
      echo "" 
      echo "VULN LOCATIONS: "
      echo "$bluetooth\n"
      echo "" 
    else
      echo "no bluetooth vulnerability"
      echo ""
  fi

echo "3. Calendar (vulnerable if present)"
calendar=$(grep "EKEventStore\|EKCalendar" $FILE)
  if [ "$calendar" ]
    then
      echo "VULN NAME: Calendar"
      echo "The binary contains references to the EKEventStore class, which represents the calendar database."
      echo "" 
      echo "VULN LOCATIONS: "
      echo "$calendar\n"
      echo ""     
    else
      echo "not using calendar"
      echo ""
  fi

echo "4. Weak Crypto (vulnerable if present)"
crypto=$(grep "CC_MD2\|CC_MD4\|CC_MD5\|CC_SHA1\|kCCAlgorithmDES" "$FILE")
  if [ "$crypto" ] 
    then
      echo "VULN NAME: Weak Crypto"
      echo "The app is using the following deprecated crypto:"
      echo "VULN Crypto: "
      echo "$crypto/n"
      echo "" 
    else
      echo "Wow, no deprecated crypto"
      echo "" 
  fi

echo "5. Data Protection API Use (vulnerable if absent)"
dpi=$(strings -a - < $FILE |grep “NSDataWritingFileProtectionComplete$\|NSFileProtectionComplete$\|NSDataWritingFileProtectionCompleteUnlessOpen$\|NSFileProtectionCompleteUnlessOpen$\|NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication$\|NSFileProtectionCompleteUntilFirstUserAuthentication$”)
  if [ -n "$dpi"] 
    then
      echo "VULN NAME: Data Protection API Not Used" 
      echo "The application does not protect on-disk data with the iOS Data Protection API. The Data Protection API can be used in iOS 4 and later to use the built-in encryption hardware on the device to encrypt files on disk."
      echo "" 
      echo "VULN FILES: "
      echo "$dpi\n" #This not working like it is in Mobius
      echo "" 
    else
      echo "Application uses the Data protection API"
      echo ""
  fi

echo "6. Geolocation (vulnerable if present)"
loc=$(grep -i "cllocation" $FILE)
  if [ "$loc" ]
    then
      echo "VULN NAME: Geolocation"
      echo "The application uses geolocation data. This data, while valuable for some functions of mobile applications, can also constitute a privacy leak should the application store or send it unencrypted or to a 3rd party not authorized by the phone's owner."
      echo "" 
      echo "VULN LOCATIONS: " 
      echo "$loc\n"
      echo "" 
    else
      echo "no GEO used. Not vulnerable."
      echo "" 
  fi  

echo "7. Jailbreak Detection (vulnerable if absent)"
jail=$(strings -a - < $FILE |grep "^/bin/bash$\|^/Applications/Cydia.app$\|/cydia.log$\|cydia://")
  if [ -n "$jail" ] 
    then
      echo "Jailbreak Proection:"
      echo ""  
      echo "$jail\n"
      echo "" 
    else
      echo "VULN: Mising Jailbreak Detection"
      echo "The application does not attempt to detect the presence of jailbreak on devices."
      echo "" 
  fi

echo "8. Shared Keychain (vulnerable if present)"
keychain=$(grep "_kSecAttrAccessGroup$" $FILE)
  if [ "$keychain" ]
    then
      echo "VULN NAME: Shared Keychain"
      echo "The binary contains references to kSecAttrAccessGroup, which is used to set up shared keychain access."
      echo "" 
      echo "VULN LOCATIONS: "
      echo "$keychain/n"
      echo "" 
    else
      echo "The Application is not using Shared Keychain"
      echo "" 
  fi

echo "9. Logging (vulnerable if present)"
nslog=$(grep "_NSLog$" $FILE)
  if [ "$nslog" ]
    then 
      echo "VULN NAME: Logging"
      echo "The application has logging enabled. Ensure this logging doesn't reveal sensitive data. It is good practice to only use logging in the DEBUG/Development phases of design."
      echo "" 
      echo "VULN LOCATIONS: "
      echo "$nslog\n"
      echo "" 
    else
      echo "Not Logging"
      echo "" 
  fi

echo "10. Pasteboard (vulnerable if present)"
pboard=$(grep -i "generalpasteboard" $FILE)
  if [ "$pboard" ]
  then
      echo "VULN NAME: Pasteboard"
      echo "The binary contains references to the generalPasteboard method."
      echo "" 
      echo "VULN LOCATIONS: "
      echo "$pboard\n"
      echo "" 
  else
      echo "Application is not using Pasteboard"
      echo "" 
  fi

echo "11. Binary Protection Path Disclosure (vulnerable if present) need unecrypted"
paths=$(strings -a - $FILE |grep "/Users/" |cut –d/ -f3| sort –u) #this one needs an unnecrypted binary
  if [[ -n $paths ]]
    then
      echo "VULN NAME: Path Disclosure" 
      echo "This application includes file paths to source code files in debug information stored within the app's executable. These file paths often include usernames or other information related to the developer of the app. This information could be used to assist in targeting the app developer or development company. Below are user names parsed from the application binary:"
      echo "" 
      echo "VULN LOCATIONS: "
      echo "$paths\n"
      echo "" 
    else
      echo "No usernames discovered in the binary."
      echo "" 
  fi

      #brent-morriss-iPhone:~/Analyzed/com.publix.main-2.0.1.11111400 root# strings -a - decryptedBinary |grep "/Users/" |cut -d/ -f3| sort -u
      # Nuzzi
      # benjamin
      # bizmosis1
      # jalter
      # max
      # nderzhak
      # sabilrahim
      # vduggal

echo "12. Unencrypted Photo Storage (vulnerable if present)"
photostore=$(grep "UIImageWriteToSavedPhotosAlbum\|sharedPhotoLibrary" $FILE)
  if [ "$photostore" ]
    then
      echo "VULN NAME: Unencrypted Photo Storage"
      echo "The binary contains references to the UIImageWriteToSavedPhotosAlbum method."
      echo "" 
      echo "VULN LOCATIONS: " 
      echo "$photostore\n"
      echo "" 
    else
      echo "no Unecrypted Photo Storage"
      echo "" 
  fi

echo "13 Binary Protection PIE (vulnerable if PIE is absent)"
pie=$(otool -hvm $BIN)
  if [ "$pie" ] 
    then
      echo "The application is using PIE:"
      echo "" 
      echo "LOCATION: " 
      echo "$pie\n"
      echo "" 
    else
      echo "VULN NAME: PIE"
      echo "The application does not utilize the Position Independent Executable compilation flag, which strengthens the ASLR protection of iOS applications. Without this protection attackers may be able to execute exploits against the application in an easier fashion than if the flag was enabled. PIE can be enabled in the compiler by adding the -fPIE flag."
      echo "" 
  fi

echo "14. Push Notifications (vulnerable if present)"
pushnotreg=$(grep -i "registerForRemoteNotificationTypes\|registerForRemoteNotifications" $FILE)
pushnottok=$(grep -i "didRegisterForRemoteNotificationsWithDeviceToken" $FILE)
  if [ "$pushnotreg" ] && [ "$pushnottok" ]
    then 
      echo "VULN NAME: "
      echo "This app is using Push Notifications. The binary contains references to methods used to register a device for push notifications, registerForRemoteNotificationTypes and didRegisterForRemoteNotificationsWithDeviceToken."
      echo ""
      echo "VULN LOCATIONS: "  
      echo "$pushnotreg\n"
      echo "$pushnottok\n"
      echo "" 
    else
      echo "noalert for push notifications"
      echo ""
    fi

echo "15. Client-Side SQL Injection (vulnerable if present)"
sql=$(strings -a - < $FILE |grep -i "^begin transaction\|^select .* from \|^update .* set \|^delete from \|^insert into " | grep "%@" | grep -v "SELECT id,access_token FROM test_account WHERE app_id")
  if [ "$sql" ]
    then
      echo "VULN NAME: SQL Injection"
      echo "The inspected application uses SQL queries that are populated with dynamic input via format strings. If the dynamic input is derived from untrusted sources such as user input from the querystring, form fields, or HTTP headers, then SQL injection may be possible. To protect against SQL injection attacks, use parameterized queries whenever possible, in which inputs are bound to specific query parameters. The following statements containing format strings were detected:"
      echo ""
      echo "VULN LOCATIONS: " 
      echo "$sql\n"
      echo "" 
    else
     echo "no sqli found"
     echo "" 
  fi

echo "16. sqlite3_prepare (vulnerable if present)" 
sqlite3=$(grep "sqlite3_prepare$" $FILE)
  if [ "$sqlite3" ]
    then
      echo "VULN NAME: SQLite3"
      echo "The applications uses the 'sqlite3_prepare' function for database calls. This function has been deprecated and is known to contain security weaknesses. Use 'sqlite3_prepare_v2' as an alternative."
      echo ""
      echo "VULN LOCATIONS: " 
      echo "$sqlite3\n"
      echo "" 
    else
      echo "no sqlite3 detected"
      echo "" 
  fi

echo "17. Binary Protection – Stack Protection (vulnerable if absent)"
stack=$(otool -Ivm $BIN |grep stack_chk)
  if [ "$stack" ] 
    then
      echo "Stack Protection Present:"
      echo ""
      echo "LOCATION: " 
      echo "$stack\n"
      echo "" 
    else
      echo "VULN NAME: Missing Stack Protection"
      echo "The application does not utilize a stack canary value to deter buffer overflow attacks. This protection is known as \"Stack Smashing\" protection. Stack Smashing protection can be added to iOS binaries by adding the -fstack-protector-all compiler flag."
      echo "" 
  fi

echo "18. Shared Directories (vulnerable if present)"
tmpdir=$(strings -a - < $FILE |grep "^/private/var/tmp\|^/var/tmp" | grep -v "\.m\|xcode")
  if [ "$tmpdir" ]
    then
      echo "VULN NAME: Shared Temp Directory" 
      echo "The application accesses a shared directory, such as '/tmp'. If application files are created in a shared directory, anyone else with access to those files can modify or replace them. If temporary files are necessary, ensure they are stored in a directory that is restricted to the application, such as <Application_Home>/tmp/."
      echo "" 
      echo "VULN LOCATIONS: "
      echo "$tmpdir\n"
      echo "" 
  else
    echo "Not sharing tmp directories"
    echo "" 
  fi

echo "19. UDID transfer, including over HTTPS (vulnerable if present)"
udid=$(strings -a - < $FILE |grep ://| grep -i "udid")
  if [ -n "$dir" ]
    then
      echo "VULN NAME: UDID discovered" 
      echo "The Application is transfer the UDID as a parameter"
      echo ""
      echo "VULN LOCATIONS: " 
      echo "$udid\n"
    else
      echo "Not transfering the UDID"
      echo "" 
  fi

echo "20. Unencrypted URLs"
urls=$(grep -oE "\bhttp://[^<>[:space:]]*[^\"[:space:]<>']" $FILE |grep -v "^http://$\| http\|www.apple.com/appleca\|www.apple.com/DTDs\|phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware\|ns.adobe.com"|sort -u)
  if [ -n "$urls" ]
    then
      echo "No Unencrypted URLs found"
      echo "" 

    else
      echo "VULN NAME: Unencrypted URLs" 
      echo "VULN LOCATIONS: " 
      echo "$urls\n"
      echo ""
  fi
                                
echo "21. URL Schemes (vulnerable if present)"
url_schemes=$(strings -a - $FILE |grep -oE "[a-zA-Z][a-zA-Z0-9\+\-\.]*://[^[:space:]\<\>\#\"\']+"|grep -v "http://\|https://\|radr://"| sort –u)
  if [ "url_schemes" ]
    then
      echo "VULN NAME: URL Schemes"
      echo "The application uses custom URL Schemes (protocol handlers) to communicate with other iOS apps on the phone. When registering a custom URL scheme it is important to apply input validation to that receiver. The use of regular expressions to whitelist input characters and maximum length from other applications is recommended."
      echo ""
      echo "VULN LOCATIONS: " 
      echo "$url_schemes\n"
      echo "" 
    else
      echo "clear"
      echo "" 
  fi