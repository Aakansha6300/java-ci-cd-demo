FROM eclipse-temurin:21-jre
WORKDIR /app
COPY target/java-app-1.0.jar app.jar
EXPOSE 8090
ENTRYPOINT ["java","-jar","/app/app.jar","--server.port=8090"]

