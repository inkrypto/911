BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Insecure SSL Handling (vulnerable if present)
ssl=$(strings -a - < $FILE |grep "setAllowsAnyHTTPSCertificate\|kCFStreamSSLAllowsExpiredRoots\|kCFStreamSSLAllowsExpiredCertificates\|kCFStreamSSLAllowsAnyRoot")
  if [ -n "$ssl" ]
    then
    echo "The application uses HTTPS or SSL connections that allow for vulnerabilities in certificates. These vulnerabilities include using any HTTPS certificate for a host, using expired certificates for a host, using any root domain in the certificate path, or having no authentication challenge with a HTTPS/SSL connection. Most of these calls stem from the CFNetwork class and can be mitigated by using NSUrl. In the situation where you need to use CFNetwork, please use strong and secure certificate enforcement. See the output below:"
    echo "$ssl\n"
  else
    echo "No vulnerable SSL connections detected"
  fi