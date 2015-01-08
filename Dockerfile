# This Dockerfile will build mahout
# To build this image using this Dockerfile, use:
# sudo docker build --tag="mahout:0.9" .

FROM google/debian:wheezy

MAINTAINER borromeotlhs@gmail.com

# this assumes running from the directory the installer is extracted to

# Need the volumes-from command in command line to ensure the code we classify is mounted as a volume

#ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q

# Don't know which ports mahout depends on, if any
#EXPOSE 9000

# from http://mahout.apache.org/developers/buildingmahout.html
# technically, mahout needs Java JDK 1.6, but this _should_ work
RUN apt-get install openjdk-6-jdk -yq
RUN echo "JAVA_HOME=/usr/bin" >> /etc/environment
# needs maven3, ironically retrieved through 'maven' package though 'maven2' exists. . .
RUN apt-get install -y maven
RUN apt-get install -y git

RUN git clone https://github.com/apache/mahout.git /src/mahout

# assuming I'm using the hadoop-2.2.0 dependency
WORKDIR /src/mahout
# you'll be in a detached HEAD state, but who cares?
RUN git checkout mahout-0.9
# no tests
RUN mvn -DskipTests clean install

# ENV needs to be used, as the above doesn't seem to be visible from cli
ENV JAVA_HOME /usr

# drop this container into the path necessary to utilize the now trained ML models created by Mahout
WORKDIR /src/mahout/bin
