#!/bin/bash

### Productions URLs
PRODURL1='bpi-dcg-prod.azurewebsites.net'
PRODURL2='bpi-dcg-prod-bpidcgrdphub-ns.servicebus.windows.net'

### SIT / UAT URLs
SITURL1='bpi-dcg-situat.azurewebsites.net'
SITURL2='bpi-dcg-situat-bpidcgrdphub-ns.servicebus.windows.net'

echo -e "\n *** EXPIRY CHECK ***"

for URL in $SITURL1 $SITURL2 $PRODURL1 $PRODURL2
do
	if [[ "$URL" ==  *situat* ]];
	then
		echo -e "\nSIT-UAT URL  - https://$URL" 
		echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate
		
		MM=`echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate | awk {'print $1'} | awk -F "=" {'print $2'}`
		DD=`echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate | awk {'print $2'}`
		YY=`echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate | awk {'print $4'}`

		M=1
		for X in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
			do
        		[ "$MM" = "$X" ] && break
        		M=`expr $M + 1`
			done

		python -c "from datetime import date as d; print('DAYS LEFT TO EXPIRE'); print(d($YY, $M, $DD) - d.today())"
		left_day=`python -c "from datetime import date as d; print(d($YY, $M, $DD) - d.today())"`
		left_day=`echo $left_day | awk {'print $1'}`
		
		#left_day='29'
		if [[ 'left_day' -le '30' ]]; then
			echo -e "\n******* BELOW CERTIFICATE  ABOUT  TO EXPIRED ********\n"
			echo -e "\nSIT-UAT URL  - https://$URL"
			echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate
			python -c "from datetime import date as d; print('DAYS LEFT TO EXPIRE'); print(d($YY, $M, $DD) - d.today())"
			exit 1
		fi
			


	else 
		echo -e "\nProductions URL - https://$URL" 
		echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate

		MM=`echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate | awk {'print $1'} | awk -F "=" {'print $2'}`
		DD=`echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate | awk {'print $2'}`
		YY=`echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate | awk {'print $4'}`

		M=1
		for X in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
			do
        		[ "$MM" = "$X" ] && break
        		M=`expr $M + 1`
			done

		python -c "from datetime import date as d; print('DAYS LEFT TO EXPIRE'); print(d($YY, $M, $DD) - d.today())"
		left_day=`python -c "from datetime import date as d; print(d($YY, $M, $DD) - d.today())"`
		left_day=`echo $left_day | awk {'print $1'}`
		
		#left_day='29'
		if [[ 'left_day' -le '30' ]]; then
			echo -e "\n******* BELOW CERTIFICATE  ABOUT  TO EXPIRED ********\n"
			echo -e "\nSIT-UAT URL  - https://$URL"
			echo | openssl s_client -servername $URL -connect $URL:443 2>/dev/null | openssl x509 -noout -enddate
			python -c "from datetime import date as d; print('DAYS LEFT TO EXPIRE'); print(d($YY, $M, $DD) - d.today())"
			exit 1
		fi
	fi
done
echo -e "\n"
