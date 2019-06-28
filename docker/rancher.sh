docker run -d --restart=unless-stopped \
  -p 80:80 -p 443:443 \
  -v /rancher:/var/lib/rancher \
  -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime \
  -e HTTP_PROXY="http://10.67.9.210:3128" \
  -e HTTPS_PROXY="http://10.67.9.210:3128" \
  -e NO_PROXY="localhost,127.0.0.1,0.0.0.0,10.67.36.0/22" \
  rancher/rancher:v2.1.4

