#!/bin/bash

# GET http://localhost:8080/alpha?input=hello
# Accept-Encoding: gzip, deflate
# Accept: */*
# Accept-Language: en-us

## OPTIONS
## -v   verbose   
# curl "https://shoe...&invoiceid=${line}&sEcho=1&iCo...table_7=true"
#curl 'https://shoe...&invoiceid='"$line"'&sEcho=1&iCo...table_7=true'
##     ^------ fixed part ------^  ^var^  ^------- fixed part ------^

## 
printf '\n'
printf '#####################\n'
printf '## Leaf Templating ##\n'
printf '#####################'

printf '\n\n%s\n' "pages with open in default browser"

open 'http://localhost:8080/template1'

open 'http://localhost:8080/template2/Roger'

open 'http://localhost:8080/template2/27'

open 'http://localhost:8080/template3a'

open 'http://localhost:8080/template3b'

open 'http://localhost:8080/template4a'

open 'http://localhost:8080/template4b'

open 'http://localhost:8080/template5a?sayHello=true'

open 'http://localhost:8080/template5a?sayHello=false'

open 'http://localhost:8080/template5b?sayHello=true'

open 'http://localhost:8080/template5b?sayHello=false'



printf '\n\n'
printf '###############################\n'
printf '###############################\n\n'



