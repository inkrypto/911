BIN="/var/mobile/Containers/Bundle/Application/E3015218-A6C7-446E-A4CE-CB388DC245BF/Publix.app/Publix"

strings -a - $BIN > binary_strings.txt

FILE=binary_strings.txt

#Client-Side SQL Injection (vulnerable if present)
sql=$(strings -a - < $FILE |grep -i "^begin transaction\|^select .* from \|^update .* set \|^delete from \|^insert into " | grep "%@" | grep -v "SELECT id,access_token FROM test_account WHERE app_id")
  if [ "$sql" ]
    then
    echo "The inspected application uses SQL queries that are populated with dynamic input via format strings. If the dynamic input is derived from untrusted sources such as user input from the querystring, form fields, or HTTP headers, then SQL injection may be possible. To protect against SQL injection attacks, use parameterized queries whenever possible, in which inputs are bound to specific query parameters. The following statements containing format strings were detected:"
    echo "$sql\n"
  else
    echo "no sqli found"
  fi