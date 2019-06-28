#!/bin/bash
echo "#################list flavors################"
curl --insecure -s -H "X-Auth-Token:"gAAAAABaZYq0_EFOHTO-OK7lkA-2wo4oWT5h2KjWdROi5hM29eivB09fa7TznT-0YF8_7tlCCIfyh4gBI21n-KARGFCYYJHunhriuqRRpm4xbQylBtsbv64f-qK1T9n0RpqBN4AwVmngyFxYXqW-rjWJserHyGnhUNflMz-ldMvHu5eICfxggX0"" https://10.67.36.80:8774/v2/3def5a869d0b4e5abd04c55ad3962bfb/flavors | python -m json.tool | jq '.flavors[] | {id,name}'

echo "#################list images#################"
curl --insecure -s -H "X-Auth-Token:"gAAAAABaZYq0_EFOHTO-OK7lkA-2wo4oWT5h2KjWdROi5hM29eivB09fa7TznT-0YF8_7tlCCIfyh4gBI21n-KARGFCYYJHunhriuqRRpm4xbQylBtsbv64f-qK1T9n0RpqBN4AwVmngyFxYXqW-rjWJserHyGnhUNflMz-ldMvHu5eICfxggX0"" https://10.67.36.80:8774/v2/3def5a869d0b4e5abd04c55ad3962bfb/images | python -m json.tool | jq '.images[] | {id,name}'

echo "#################list instances##############"
curl --insecure -s -H "X-Auth-Token:"gAAAAABaZYq0_EFOHTO-OK7lkA-2wo4oWT5h2KjWdROi5hM29eivB09fa7TznT-0YF8_7tlCCIfyh4gBI21n-KARGFCYYJHunhriuqRRpm4xbQylBtsbv64f-qK1T9n0RpqBN4AwVmngyFxYXqW-rjWJserHyGnhUNflMz-ldMvHu5eICfxggX0"" https://10.67.36.80:8774/v2/3def5a869d0b4e5abd04c55ad3962bfb/servers | python -m json.tool | jq '.servers[] | {id,name}'

echo "#################list volumes###############"
curl --insecure -s -H "X-Auth-Token:"gAAAAABaZYq0_EFOHTO-OK7lkA-2wo4oWT5h2KjWdROi5hM29eivB09fa7TznT-0YF8_7tlCCIfyh4gBI21n-KARGFCYYJHunhriuqRRpm4xbQylBtsbv64f-qK1T9n0RpqBN4AwVmngyFxYXqW-rjWJserHyGnhUNflMz-ldMvHu5eICfxggX0"" https://10.67.36.80:8776/v2/3def5a869d0b4e5abd04c55ad3962bfb/volumes |  python -m json.tool | jq '.volumes[] | {description,id,name}'

echo "#################list volume backups###############"
curl --insecure -s -H "X-Auth-Token:"gAAAAABaZYq0_EFOHTO-OK7lkA-2wo4oWT5h2KjWdROi5hM29eivB09fa7TznT-0YF8_7tlCCIfyh4gBI21n-KARGFCYYJHunhriuqRRpm4xbQylBtsbv64f-qK1T9n0RpqBN4AwVmngyFxYXqW-rjWJserHyGnhUNflMz-ldMvHu5eICfxggX0"" https://10.67.36.80:8776/v2/3def5a869d0b4e5abd04c55ad3962bfb/backups/detail |  python -m json.tool | jq '.backups[] | {description,id,is_incremental,size,status,volume_id,name}'

echo "#################list volume snapshots###############"
curl --insecure -s -H "X-Auth-Token:"gAAAAABaZYq0_EFOHTO-OK7lkA-2wo4oWT5h2KjWdROi5hM29eivB09fa7TznT-0YF8_7tlCCIfyh4gBI21n-KARGFCYYJHunhriuqRRpm4xbQylBtsbv64f-qK1T9n0RpqBN4AwVmngyFxYXqW-rjWJserHyGnhUNflMz-ldMvHu5eICfxggX0"" https://10.67.36.80:8776/v2/3def5a869d0b4e5abd04c55ad3962bfb/snapshots/detail |  python -m json.tool | jq '.snapshots[] | {description,id,name,size,status,volume_id}'

echo "#################list Object Store Containers########"
curl --insecure -s -H "X-Auth-Token:"gAAAAABaZYq0_EFOHTO-OK7lkA-2wo4oWT5h2KjWdROi5hM29eivB09fa7TznT-0YF8_7tlCCIfyh4gBI21n-KARGFCYYJHunhriuqRRpm4xbQylBtsbv64f-qK1T9n0RpqBN4AwVmngyFxYXqW-rjWJserHyGnhUNflMz-ldMvHu5eICfxggX0"" https://10.67.36.80:8080/swift/v1/

echo "#################list Containers Linux########"
curl --insecure -s -H "X-Auth-Token:"gAAAAABaZYq0_EFOHTO-OK7lkA-2wo4oWT5h2KjWdROi5hM29eivB09fa7TznT-0YF8_7tlCCIfyh4gBI21n-KARGFCYYJHunhriuqRRpm4xbQylBtsbv64f-qK1T9n0RpqBN4AwVmngyFxYXqW-rjWJserHyGnhUNflMz-ldMvHu5eICfxggX0"" https://10.67.36.80:8080/swift/v1/Linux
echo

echo "#################list Containers picture########"
curl --insecure -s -H "X-Auth-Token:"gAAAAABaZYq0_EFOHTO-OK7lkA-2wo4oWT5h2KjWdROi5hM29eivB09fa7TznT-0YF8_7tlCCIfyh4gBI21n-KARGFCYYJHunhriuqRRpm4xbQylBtsbv64f-qK1T9n0RpqBN4AwVmngyFxYXqW-rjWJserHyGnhUNflMz-ldMvHu5eICfxggX0"" https://10.67.36.80:8080/swift/v1/picture
echo

