
FROM openjdk:17-jdk-slim
 
WORKDIR /app
 
COPY target/spring-boot-2-hello-world-1.0.2-SNAPSHOT.jar /app/helloworld-java.jar
 
EXPOSE 8086
 
ENTRYPOINT ["java", "-jar", "/app/helloworld-java.jar"]