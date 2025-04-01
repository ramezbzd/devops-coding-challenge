# Build stage
FROM maven:3.9.9-amazoncorretto-17-alpine AS build
WORKDIR /app

# Copy the Maven configuration files
COPY pom.xml .
COPY .mvn/ .mvn/
COPY mvnw mvnw.cmd ./

# Copy the source code
COPY src/ src/

# Build the application
RUN mvn package -DskipTests

# Runtime stage
#FROM amazoncorretto:17.0.14-alpine3.21
FROM eclipse-temurin:17-jre-alpine-3.21
WORKDIR /app

# Add a non-root user to run the application
RUN addgroup -S crewmeister && adduser -S crewmeister -G crewmeister
USER crewmeister:crewmeister

# Copy the application from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Set security-related Java options
ENV JAVA_TOOL_OPTIONS="-Djava.security.egd=file:/dev/./urandom \
    -Djava.awt.headless=true \
    -XX:+UseContainerSupport \
    -XX:MaxRAMPercentage=75.0 \
    -XX:+ExitOnOutOfMemoryError"

# Run the application
CMD ["java", "-jar", "/app/app.jar"]
