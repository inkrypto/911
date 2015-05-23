BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Data Protection API Use (vulnerable if absent)
dpi=$(strings -a - < $FILE |grep “NSDataWritingFileProtectionComplete$\|NSFileProtectionComplete$\|NSDataWritingFileProtectionCompleteUnlessOpen$\|NSFileProtectionCompleteUnlessOpen$\|NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication$\|NSFileProtectionCompleteUntilFirstUserAuthentication$”)
    if [ -n "$dpi"] 
      then
        echo "The application does not protect on-disk data with the iOS Data Protection API. The Data Protection API can be used in iOS 4 and later to use the built-in encryption hardware on the device to encrypt files on disk."
      else
        echo "$dpi\n"
    fi