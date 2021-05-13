FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
# Set the JAVA_HOME variable to make it clear where Java and JBOSS_HOME are located
#ENV JAVA_HOME /usr/lib/jvm/java
ENV JBOSS_HOME /opt/wildfly
# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true


RUN apt-get update \
  && apt-get install -y apt-utils curl openjdk-11-jre \
  && apt-get dist-upgrade -y  \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && mkdir ${JBOSS_HOME} ${JBOSS_HOME}/staging  \
  && adduser --home ${JBOSS_HOME} --shell /bin/sh --uid 1000 --disabled-password jboss