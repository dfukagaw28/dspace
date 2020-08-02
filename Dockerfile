FROM tomcat:9-jdk8-openjdk-slim

RUN set -ex \
  && mkdir -p /usr/share/man/man1 \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends ant maven \
  && apt-get install -y --no-install-recommends curl git

RUN set -ex \
  && curl -sRLO https://github.com/DSpace/DSpace/releases/download/dspace-6.3/dspace-6.3-release.tar.gz \
  && tar zxf dspace-6.3-release.tar.gz

COPY server.xml /usr/local/tomcat/conf/server.xml
COPY local.cfg /usr/local/tomcat/dspace-6.3-release/dspace/config/local.cfg
COPY build.xml /usr/local/tomcat/dspace-6.3-release/dspace/target/dspace-installer/build.xml

RUN set -ex \
  && cd dspace-6.3-release \
  && mvn package \
  && cd dspace/target/dspace-installer \
  && ant fresh_install \
  && mv /dspace/webapps/* /usr/local/tomcat/webapps/

RUN set -ex \
  && apt-get install -y --no-install-recommends msmtp
