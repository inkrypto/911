BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Binary Protection - ARC (vulnerable if absent)
arc=$(strings -a - < $FILE |grep "_objc_release\|_objc_autoreleaseReturnValue\|_objc_retain")
  if [ "$arc" ]
    then
      echo "Application is using ARC protection.\n$arc"
    else
      echo "The application does not use the provided iOS memory management framework, ARC. ARC stands for Automatic Reference Counting and builds in intelligent \"Garbage Collection\" and memory deallocations. While not using ARC is not a vulnerability per se, it is highly recommended. Manual memory management in iOS requires a lot of overhead in Objective-C and if not done right can lead to performance losses and security vulnerabilities."
  fi