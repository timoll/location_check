#!/bin/bash
ids=("9f735294-0193-4203-b5f0-83fc5c166511" "a33f3eb8-7b9a-44ed-aa5d-dd2410de45bf" "ab971449-b056-4760-ac61-720f0e367ed4" "ef3463d6-a3fd-4738-a775-002e8db743c7" "d1a6647b-8a4d-4e91-9aeb-fcb228d2b727" "0397455c-3693-4189-af97-e07551f262f7" "de2415a7-5eb6-4187-9233-556b01bbc892" "bec7963e-8072-4b1e-aa8a-556c2ce0e453" "1ae59180-3cc8-4b5c-845f-5531a110cfbf" "4f9397a4-4b33-42f8-bf40-f4cf9af2d89a" "f26a97ce-5cbb-4cf1-9939-02a54cbc2d2c" "9847e4f9-9e1c-40c7-804b-2c49ce42ae10" "4b957b33-457c-47de-9ed9-836d5e24d99c")
places=("aarberg" "bernexpo" "biel" "burgdorf" "gantrisch" "insel" "interlaken" "langenthal" "langnau" "tavannes" "thun" "wankdorf" "zollikofen")

XSRF_TOKEN="enter token here"
VWR="some part here"

for i in ${!ids[*]}
do
	free_date=$(curl -s "https://be.vacme.ch/api/v1/reg/dossier/termine/nextfrei/${ids[$i]}/ERSTE_IMPFUNG" -H 'User-Agent: Opera/9.63 (Macintosh; Intel Mac OS X; U; en) Presto/2.1.1' -H 'Accept: application/json' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: https://be.vacme.ch/' -H 'Content-Type: application/json' -H "X-XSRF-TOKEN: $XSRF_TOKEN" -H "$1" -H 'Origin: https://be.vacme.ch' -H 'DNT: 1' -H 'Connection: keep-alive' -H "Cookie: XSRF-TOKEN=$XSRF_TOKEN; $VWR" -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' --data-raw '' | jq .nextDate 2>/dev/null)
	if [ -z "$free_date" ]
	then 
		echo "no slots in ${places[$i]}"
	else
	    	sum=0
	    	free_date=$(date -d "${free_date//\"}")
	    	for j in {0..14}
	    	do
			test_date=$(date -d "$free_date + $j days" +%Y-%m-%dT01:00:00.000)
			part_sum=$(curl -s  "https://be.vacme.ch/api/v1/reg/dossier/termine/frei/${ids[$i]}/ERSTE_IMPFUNG" -H 'User-Agent: Opera/9.63 (Macintosh; Intel Mac OS X; U; en) Presto/2.1.1' -H 'Accept: application/json' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Referer: https://be.vacme.ch/' -H 'Content-Type: application/json' -H "X-XSRF-TOKEN: $XSRF_TOKEN" -H "$1" -H 'Origin: https://be.vacme.ch' -H 'DNT: 1' -H 'Connection: keep-alive' -H "Cookie: XSRF-TOKEN=$XSRF_TOKEN; $VWR" -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' --data-raw "{\"nextDate\":\"$test_date\"}" | jq '. | .[] | .kapazitaetErsteImpfung' 2>/dev/null | awk '{sum+=$0} END{print sum}')
			sum=$((sum + part_sum))
	    done
	    echo "$sum free in ${places[$i]}"
	fi
done
