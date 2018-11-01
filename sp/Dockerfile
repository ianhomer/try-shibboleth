FROM openjdk:10.0.2-jdk
WORKDIR /
ADD target/sp-1.0.0-SNAPSHOT.jar application.jar
EXPOSE 8009 8080
CMD echo "Starting service"
CMD java -jar application.jar