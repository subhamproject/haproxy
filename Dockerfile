FROM haproxy:2.0-alpine
RUN apk add python3 py3-pip
RUN pip3 install awscli
COPY docker-entrypoint.sh /
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
