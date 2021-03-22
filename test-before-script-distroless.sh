#!/busybox/sh

wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -O /usr/bin/jq && chmod +x /usr/bin/jq
wget https://github.com/moparisthebest/static-curl/releases/download/v7.74.0/curl-amd64 -O /usr/bin/curl && chmod +x /usr/bin/curl
ln -s /busybox/sh /bin/sh
