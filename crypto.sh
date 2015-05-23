BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Weak Crypto (vulnerable if present)
crypto=$(grep "CC_MD2\|CC_MD4\|CC_MD5\|CC_SHA1\|kCCAlgorithmDES" "$FILE")
  if [ "$crypto" ] 
    then
      echo "The app is using the following deprecated crypto:"
      echo "$crypto/n"
    else
      echo "Wow, no deprecated crypto"
  fi