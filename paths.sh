BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Binary Protection – Path Disclosure (vulnerable if present) need unecrypted
  paths=$(strings -a - $FILE |grep "/Users/" |cut –d/ -f3| sort –u) #this one needs an unnecrypted binary
    if [[ -n $paths ]]
      then
        echo "This application includes file paths to source code files in debug information stored within the app's executable. These file paths often include usernames or other information related to the developer of the app. This information could be used to assist in targeting the app developer or development company. Below are user names parsed from the application binary:"
        echo "$paths\n"
      else
        echo "No usernames discovered in the binary."
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
