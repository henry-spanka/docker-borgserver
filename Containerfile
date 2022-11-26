############################################################
# Dockerfile to build borgbackup server images
# Based on Debian
############################################################
FROM debian:bookworm-slim

# Volume for SSH-Host-Keys
VOLUME /keys

# Volume for borg repositories
VOLUME /backup

RUN export DEBIAN_FRONTEND=noninteractive && \
		apt-get update && \
		apt-get -y --no-install-recommends install \
		borgbackup openssh-server && \
		apt-get -y dist-upgrade && apt-get clean && \
		useradd -s /bin/bash -m -U borg && \
		mkdir /home/borg/.ssh && \
		chmod 700 /home/borg/.ssh && \
		touch /home/borg/.ssh/authorized_keys && \
		chown -R borg:borg /home/borg /backup && \
		mkdir /run/sshd && \
		rm -f /etc/ssh/ssh_host*key* && \
		rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

COPY ./data/sshd_config /etc/ssh/sshd_config
COPY ./data/init.sh /init.sh

USER borg
EXPOSE 2222

CMD [ "/usr/sbin/sshd", "-D", "-e" ]
