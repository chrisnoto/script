#!/bin/bash

echo "#################list services################"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYwPHs4ZN5Y40bi0yidNTa7RpCBHFU2k8gHW1_4XnF8_5aHZtmGW7Heo25ChrmvZtrzzUujj8esG5LPLKL1QvejPC9tS-dvvkKa9L7Iaptz3nDJrOB4AMfyUXPB8s-yA5EIUmydtr0K1ev9AwS6mtT192strgi4pvtcvQiiIAzolNHHhs"" https://10.67.44.66:5000/v3/services | python -m json.tool

echo "#################list endpoints################"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYwPHs4ZN5Y40bi0yidNTa7RpCBHFU2k8gHW1_4XnF8_5aHZtmGW7Heo25ChrmvZtrzzUujj8esG5LPLKL1QvejPC9tS-dvvkKa9L7Iaptz3nDJrOB4AMfyUXPB8s-yA5EIUmydtr0K1ev9AwS6mtT192strgi4pvtcvQiiIAzolNHHhs"" https://10.67.44.66:5000/v3/endpoints | python -m json.tool

echo "#################list instances detail ######"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYwPHs4ZN5Y40bi0yidNTa7RpCBHFU2k8gHW1_4XnF8_5aHZtmGW7Heo25ChrmvZtrzzUujj8esG5LPLKL1QvejPC9tS-dvvkKa9L7Iaptz3nDJrOB4AMfyUXPB8s-yA5EIUmydtr0K1ev9AwS6mtT192strgi4pvtcvQiiIAzolNHHhs"" https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/servers/detail | python -m json.tool | jq '.servers[] | {id,name,addresses,key_name,security_groups,status}'

