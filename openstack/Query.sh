#!/bin/bash
echo "#################list flavors################"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYxkM4d-DI4cZtUspYkPkpA2-I2FoCdEbzuOHip08RTCUEC4Htk-Ix2DFfBjpXtMi_OPHgC6P2FRsF6q5yElt1oj2rERT2STR2NGOVSyvQ6aIvXPIwb-tSmiivBWQVURJEnNpVjzJfrOR7An-PMopA__LwWgBChNRDvisWQj55AXr0_JY"" https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/flavors | python -m json.tool | jq '.flavors[] | {id,name}'

echo "#################list images#################"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYxkM4d-DI4cZtUspYkPkpA2-I2FoCdEbzuOHip08RTCUEC4Htk-Ix2DFfBjpXtMi_OPHgC6P2FRsF6q5yElt1oj2rERT2STR2NGOVSyvQ6aIvXPIwb-tSmiivBWQVURJEnNpVjzJfrOR7An-PMopA__LwWgBChNRDvisWQj55AXr0_JY"" https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/images | python -m json.tool | jq '.images[] | {id,name}'

echo "#################list instances##############"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYxkM4d-DI4cZtUspYkPkpA2-I2FoCdEbzuOHip08RTCUEC4Htk-Ix2DFfBjpXtMi_OPHgC6P2FRsF6q5yElt1oj2rERT2STR2NGOVSyvQ6aIvXPIwb-tSmiivBWQVURJEnNpVjzJfrOR7An-PMopA__LwWgBChNRDvisWQj55AXr0_JY"" https://10.67.44.66:8774/v2/31e6d008df414104ac5e1d42beae316c/servers | python -m json.tool | jq '.servers[] | {id,name}'

echo "#################list volumes###############"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYxkM4d-DI4cZtUspYkPkpA2-I2FoCdEbzuOHip08RTCUEC4Htk-Ix2DFfBjpXtMi_OPHgC6P2FRsF6q5yElt1oj2rERT2STR2NGOVSyvQ6aIvXPIwb-tSmiivBWQVURJEnNpVjzJfrOR7An-PMopA__LwWgBChNRDvisWQj55AXr0_JY"" https://10.67.44.66:8776/v2/31e6d008df414104ac5e1d42beae316c/volumes |  python -m json.tool | jq '.volumes[] | {description,id,name}'

echo "#################list volume backups###############"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYxkM4d-DI4cZtUspYkPkpA2-I2FoCdEbzuOHip08RTCUEC4Htk-Ix2DFfBjpXtMi_OPHgC6P2FRsF6q5yElt1oj2rERT2STR2NGOVSyvQ6aIvXPIwb-tSmiivBWQVURJEnNpVjzJfrOR7An-PMopA__LwWgBChNRDvisWQj55AXr0_JY"" https://10.67.44.66:8776/v2/31e6d008df414104ac5e1d42beae316c/backups/detail |  python -m json.tool | jq '.backups[] | {description,id,is_incremental,size,status,volume_id,name}'

echo "#################list volume snapshots###############"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYxkM4d-DI4cZtUspYkPkpA2-I2FoCdEbzuOHip08RTCUEC4Htk-Ix2DFfBjpXtMi_OPHgC6P2FRsF6q5yElt1oj2rERT2STR2NGOVSyvQ6aIvXPIwb-tSmiivBWQVURJEnNpVjzJfrOR7An-PMopA__LwWgBChNRDvisWQj55AXr0_JY"" https://10.67.44.66:8776/v2/31e6d008df414104ac5e1d42beae316c/snapshots/detail |  python -m json.tool | jq '.snapshots[] | {description,id,name,size,status,volume_id}'

echo "#################list Object Store Containers########"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYxkM4d-DI4cZtUspYkPkpA2-I2FoCdEbzuOHip08RTCUEC4Htk-Ix2DFfBjpXtMi_OPHgC6P2FRsF6q5yElt1oj2rERT2STR2NGOVSyvQ6aIvXPIwb-tSmiivBWQVURJEnNpVjzJfrOR7An-PMopA__LwWgBChNRDvisWQj55AXr0_JY"" https://10.67.44.66:8080/swift/v1/

echo "#################list Containers Linux########"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYxkM4d-DI4cZtUspYkPkpA2-I2FoCdEbzuOHip08RTCUEC4Htk-Ix2DFfBjpXtMi_OPHgC6P2FRsF6q5yElt1oj2rERT2STR2NGOVSyvQ6aIvXPIwb-tSmiivBWQVURJEnNpVjzJfrOR7An-PMopA__LwWgBChNRDvisWQj55AXr0_JY"" https://10.67.44.66:8080/swift/v1/Linux
echo

echo "#################list Containers picture########"
curl --insecure -s -H "X-Auth-Token:"gAAAAABYxkM4d-DI4cZtUspYkPkpA2-I2FoCdEbzuOHip08RTCUEC4Htk-Ix2DFfBjpXtMi_OPHgC6P2FRsF6q5yElt1oj2rERT2STR2NGOVSyvQ6aIvXPIwb-tSmiivBWQVURJEnNpVjzJfrOR7An-PMopA__LwWgBChNRDvisWQj55AXr0_JY"" https://10.67.44.66:8080/swift/v1/picture
echo

