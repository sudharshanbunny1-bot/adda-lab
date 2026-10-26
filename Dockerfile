# Use Java 25 runtime
FROM eclipse-temurin:25-jre

# Set working directory inside Docker
WORKDIR /app

# Copy Spring Boot JAR into Docker image
COPY target/*.jar app.jar

# Document the application port
EXPOSE 8082

# Start Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]
