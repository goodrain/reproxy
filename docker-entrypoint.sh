#!/bin/bash

[ $DEBUG ] && set -x

REPROXY_PASS=${REPROXY_PASS:-gr123465!@#$}

echo "root:${REPROXY_PASS}" | chpasswd

# start nginx
mkdir -pv /var/cache/nginx/ && chown nginx.nginx /var/cache/nginx/
nginx

# start sshd
/usr/bin/ssh-keygen -A
/usr/sbin/sshd -D
