# Use the minimal Ubuntu 22.04 image
FROM ubuntu:22.04

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH=$CATALINA_HOME/bin:$PATH
ENV TOMCAT_VERSION=9.0.97

# Update and install required dependencies
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
    openjdk-11-jdk \
    wget \
    curl \
    nano \
    unzip \
    gnupg \
    procps \
    ca-certificates \
    locales && \
    rm -rf /var/lib/apt/lists/* && \
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

# Download and install Tomcat 9
RUN wget https://downloads.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tar.gz && \
    mkdir -p $CATALINA_HOME && \
    tar xzvf /tmp/tomcat.tar.gz -C $CATALINA_HOME --strip-components=1 && \
    rm /tmp/tomcat.tar.gz

# Set permissions
RUN chmod +x $CATALINA_HOME/bin/*.sh

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

