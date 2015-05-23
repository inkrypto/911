BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Unencrypted Photo Storage (vulnerable if present)
photostore=$(grep "UIImageWriteToSavedPhotosAlbum\|sharedPhotoLibrary" $FILE)
    if [ "$photostore" ]
      then
        echo "The binary contains references to the UIImageWriteToSavedPhotosAlbum method."
        echo "$photostore\n"
      else
        echo "no unecrypted photo Storage"
    fi