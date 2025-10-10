FROM docker:dind
RUN apk update && apk add openssh-server openrc && mkdir -p /var/run/sshd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN mkdir -p /run/openrc/ && touch /run/openrc/softlevel
COPY node0-entrypoint.sh /usr/local/bin/
RUN chmod 744 /usr/local/bin/node0-entrypoint.sh
EXPOSE 22