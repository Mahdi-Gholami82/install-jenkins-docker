FROM jenkins/jenkins:lts-jdk21
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
RUN mkdir /var/.ssh && chown jenkins:jenkins /var/.ssh 
USER jenkins
RUN ssh-keygen -t ed25519 -C "my-jenkins" -f "/var/.ssh/id_ed25519" -P "" 
USER root
RUN mkdir -p /var/shared-data; chown jenkins:jenkins /var/shared-data
USER jenkins