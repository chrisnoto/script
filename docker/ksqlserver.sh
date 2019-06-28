docker run -d -p 18088:8088 \
  -e KSQL_BOOTSTRAP_SERVERS=10.67.38.121:9092 \
  -e KSQL_OPTS="-Dksql.service.id=ksql_service_3_  -Dlisteners=http://0.0.0.0:8088/" \
  confluentinc/cp-ksql-server:5.1.2

