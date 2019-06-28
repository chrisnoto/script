docker run --rm -it -p 8000:8000 \
           -e "CONNECT_URL=http://10.67.51.144:8083" \
           -e "access.control.allow.methods=GET,POST,PUT,DELETE,OPTIONS" \
           -e "access.control.allow.origin=*" \
           landoop/kafka-connect-ui

