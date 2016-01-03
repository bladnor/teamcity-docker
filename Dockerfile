FROM java:8

MAINTAINER Roland Berger <roland.berger@exasoft.ch>

# Depending on the postgres version you want to run you should change the jdbc driver name. See here for more information https://jdbc.postgresql.org/download.html
ENV POSTGRES_JDBC_DRIVER  postgresql-9.4.1207.jar
ENV TEAMCITY_VERSION 9.1.5
ENV TEAMCITY_DATA_PATH /var/lib/teamcity
ENV TEAMCITY_USER teamcity

# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
	&& curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture).asc" \
	&& gpg --verify /usr/local/bin/gosu.asc \
	&& rm /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu

# add user
RUN  adduser --disabled-password --gecos '' $TEAMCITY_USER
#    && adduser $AGENT_USER sudo \
#    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Get and install teamcity
RUN curl -L https://download.jetbrains.com/teamcity/TeamCity-$TEAMCITY_VERSION.tar.gz | tar xz -C /opt

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /var/lib/teamcity
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE  8111
