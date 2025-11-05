# --- Stage 1: Build ---
# Use an official Maven image to build the application .jar file
FROM maven:3.8.5-openjdk-17-slim AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the source code and build the application
COPY src ./src
RUN mvn package -DskipTests

# --- Stage 2: Run ---
# Use a slim OpenJDK image to run the application
FROM openjdk:17-slim

# Set the working directory
WORKDIR /app

# Copy the built .jar file from the 'build' stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the app runs on (Spring Boot default is 8080)
EXPOSE 8080

# The command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]