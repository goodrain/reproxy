FROM alpine:3.5
MAINTAINER zhouyq@goodrain.com

RUN build_pkgs="tzdata build-base linux-headers libressl-dev pcre-dev wget zlib-dev" && \
    runtime_pkgs="ca-certificates libressl pcre zlib wget curl bash openssh openssh-sftp-server" && \
    apk --no-cache add ${build_pkgs} ${runtime_pkgs} && \
    cd /tmp && \
    curl -s http://nginx.org/download/nginx-1.11.8.tar.gz | tar -xzC /tmp && \
    cd /tmp/nginx-1.11.8 && \
    ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-http_v2_module \
    --with-ipv6  && \
  make && \
  make install && \
  sed -i -r 's/nofiles/nginx/' /etc/group && \
  adduser -u 200 -D -S -G nginx nginx && \
  sed -i -r 's/#(PermitRootLogin) .*/\1 yes/' /etc/ssh/sshd_config && \
  sed -i -r 's/#(TCPKeepAlive.*)/\1/' /etc/ssh/sshd_config && \
  sed -i -r 's/#(ClientAliveCountMax.*)/\1/' /etc/ssh/sshd_config && \
  sed -i -r 's/#(ClientAliveInterval).*/\1 10/' /etc/ssh/sshd_config && \
  sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" >  /etc/timezone && \
  rm -rf /tmp/* && \
  apk del ${build_pkgs} && \
  rm -rf /var/cache/apk/*


# expose ports for ssh
EXPOSE 22

ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD ssh.tar.gz /root/
ADD nginx /etc/nginx

ENTRYPOINT ["/docker-entrypoint.sh"]
