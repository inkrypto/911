BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Push Notifications (vulnerable if present)
pushnotreg=$(grep -i "registerForRemoteNotificationTypes\|registerForRemoteNotifications" $FILE)
pushnottok=$(grep -i "didRegisterForRemoteNotificationsWithDeviceToken" $FILE)
    if [ "$pushnotreg" ] && [ "$pushnottok" ]
      then
        echo "This app is using Push Notifications. The binary contains references to methods used to register a device for push notifications, registerForRemoteNotificationTypes and didRegisterForRemoteNotificationsWithDeviceToken."
        echo "$pushnotreg\n"
        echo "$pushnottok\n"
      else
        echo "noalert for push notifications"
      fi