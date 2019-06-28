#!/bin/bash

[ -e /root/upload.sh ] && rm -f /root/upload.sh

token=`curl --insecure -d '{"auth":{"tenantName":"admin","passwordCredentials":{"username": "admin","password": "F0xconn!23"}}}' \
-H "Content-Type: application/json" https://10.67.44.66:5000/v2.0/tokens \
| python -m json.tool \
|jq .access.token.id `

addr_containers="https://10.67.44.66:8080/swift/v1/"
addr_cont_Linux="https://10.67.44.66:8080/swift/v1/Linux/"
addr_cont_picture="https://10.67.44.66:8080/swift/v1/picture"


cat >>/root/upload.sh <<EOF
#!/bin/bash

echo "######upload file \$2 to swift #########"
curl --insecure -s -X PUT -H "X-Auth-Token:$token" ${addr_containers}\$1/\$2 -T \$2
echo "######upload finished########"


EOF
chmod +x /root/upload.sh
