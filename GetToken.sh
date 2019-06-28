#!/bin/bash

[ -e /root/Query.sh ] && rm -f /root/Query.sh

token=`curl --insecure -d '{"auth":{"tenantName":"admin","passwordCredentials":{"username": "admin","password": "F0xconn!23"}}}' \
-H "Content-Type: application/json" https://10.67.44.66:5000/v2.0/tokens \
| python -m json.tool \
|jq .access.token.id `

addr_flv="https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/flavors"
addr_img="https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/images"
addr_inst="https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/servers"
addr_vol="https://10.67.44.66:8776/v2/31e6d008df414104ac5e1d42beae316c/volumes"
addr_bk="https://10.67.44.66:8776/v2/31e6d008df414104ac5e1d42beae316c/backups/detail"
addr_snap="https://10.67.44.66:8776/v2/31e6d008df414104ac5e1d42beae316c/snapshots/detail"
addr_containers="https://10.67.44.66:8080/swift/v1/"
addr_cont_Linux="https://10.67.44.66:8080/swift/v1/Linux"
addr_cont_picture="https://10.67.44.66:8080/swift/v1/picture"


cat >>/root/Query.sh <<EOF
#!/bin/bash
echo "#################list flavors################"
curl --insecure -s -H "X-Auth-Token:$token" $addr_flv | python -m json.tool | jq '.flavors[] | {id,name}'

echo "#################list images#################"
curl --insecure -s -H "X-Auth-Token:$token" $addr_img | python -m json.tool | jq '.images[] | {id,name}'

echo "#################list instances##############"
curl --insecure -s -H "X-Auth-Token:$token" $addr_inst | python -m json.tool | jq '.servers[] | {id,name}'

echo "#################list volumes###############"
curl --insecure -s -H "X-Auth-Token:$token" $addr_vol |  python -m json.tool | jq '.volumes[] | {description,id,name}'

echo "#################list volume backups###############"
curl --insecure -s -H "X-Auth-Token:$token" $addr_bk |  python -m json.tool | jq '.backups[] | {description,id,is_incremental,size,status,volume_id,name}'

echo "#################list volume snapshots###############"
curl --insecure -s -H "X-Auth-Token:$token" $addr_snap |  python -m json.tool | jq '.snapshots[] | {description,id,name,size,status,volume_id}'

echo "#################list Object Store Containers########"
curl --insecure -s -H "X-Auth-Token:$token" $addr_containers

echo "#################list Containers Linux########"
curl --insecure -s -H "X-Auth-Token:$token" $addr_cont_Linux
echo

echo "#################list Containers picture########"
curl --insecure -s -H "X-Auth-Token:$token" $addr_cont_picture
echo

EOF
chmod +x /root/Query.sh
