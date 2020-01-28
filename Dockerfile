#FROM openjdk:8-alpine
#COPY target/springAdmin-0.0.1-SNAPSHOT.jar /usr/src/project.jar
#EXPOSE 9001
#WORKDIR /usr/src/
#CMD ["java", "-jar", "project.jar"]

# download the dependencies
FROM maven:3.5.3-jdk-8 AS mvncache
COPY pom.xml /usr/src/pom.xml
RUN mvn -f /usr/src/pom.xml dependency:resolve

# build and package the artifact
FROM mvncache AS builder
COPY . /usr/src/
RUN mvn -f /usr/src/pom.xml package

# build the neat container with just what we want
FROM openjdk:8-alpine
COPY --from=builder /usr/src/target/configServer-0.0.1-SNAPSHOT.jar /usr/src/configServer/configServer.jar
EXPOSE 9002
WORKDIR /usr/src/configServer
CMD ["java", "-jar", "configServer.jar"]