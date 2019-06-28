docker run -d \
  --name=filebeat \
  --user=root \
  --volume="$(pwd)/filebeat.docker.yml:/usr/share/filebeat/filebeat.yml:ro" \
  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  store/elastic/filebeat:6.4.0 filebeat -e -strict.perms=false \
  -E output.elasticsearch.hosts=["10.67.51.123:9200"]

