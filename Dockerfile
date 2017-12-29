###################
# PACKAGING STAGE #
###################
FROM openjdk:8-jre-alpine
ARG version
ENV artifact it-demo-${version}.jar

# application placed into /opt/app
WORKDIR /opt/app
ADD target/${artifact} /opt/app/it-demo.jar
ADD config.yml /opt/app/config.yml

EXPOSE 8080

CMD java -jar /opt/app/it-demo.jar server /opt/app/config.yml
