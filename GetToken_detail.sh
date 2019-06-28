#!/bin/bash

[ -e /root/Query_detail.sh ] && rm -f /root/Query_detail.sh

token=`curl --insecure -d '{"auth":{"tenantName":"admin","passwordCredentials":{"username": "admin","password": "F0xconn!23"}}}' \
-H "Content-Type: application/json" https://10.67.44.66:5000/v2.0/tokens \
| python -m json.tool \
|jq .access.token.id `

addr_srv="https://10.67.44.66:5000/v3/services"
addr_endpoint="https://10.67.44.66:5000/v3/endpoints"
addr_inst_dtl="https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/servers/detail"

cat >>/root/Query_detail.sh <<EOF
#!/bin/bash

echo "#################list services################"
curl --insecure -s -H "X-Auth-Token:$token" $addr_srv | python -m json.tool

echo "#################list endpoints################"
curl --insecure -s -H "X-Auth-Token:$token" $addr_endpoint | python -m json.tool

echo "#################list instances detail ######"
curl --insecure -s -H "X-Auth-Token:$token" $addr_inst_dtl | python -m json.tool | jq '.servers[] | {id,name,addresses,key_name,security_groups,status}'

EOF
chmod +x /root/Query_detail.sh
