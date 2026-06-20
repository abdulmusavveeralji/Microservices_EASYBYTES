#Start with a base image containing Java runtime
FROM openjdk:28-ea-jdk-slim-trixie

#Information around who maintains the image
MAINTAINER abdulmusavveeralji

# Add the application's jar to the image
COPY accounts/target/accounts-0.0.1-SNAPSHOT.jar accounts-0.0.1-SNAPSHOT.jar

# execute the application
ENTRYPOINT ["java", "-jar", "accounts-0.0.1-SNAPSHOT.jar"]