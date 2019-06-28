#!/bin/bash

echo "######upload file $2 to swift #########"
curl --insecure -s -X PUT -H "X-Auth-Token:"gAAAAABYoVwgMcY5wXQHq0r7T0uHOlYMKEiSsFUUvqIxhm0b5pWZtvm23Fk_DM1uKY5vPKI9tkZsFgCWoFp-HdogKwZ86nL41uN_L2WFB4n05ViMdTo4Xp7t6Lo3D2btAYtecCKboYAYghNzOo__B_G5iMXvP7tLlIpVyGsDQQjclVGFrkoDV48"" https://10.67.44.66:8080/swift/v1/$1/$2 -T $2
echo "######upload finished########"


