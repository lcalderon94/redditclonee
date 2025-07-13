FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

# Install dos2unix to handle Windows line endings
RUN apk add --no-cache dos2unix

# Copy Maven files
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .

# Convert Windows line endings to Unix and make executable
RUN dos2unix mvnw && chmod +x mvnw

# Download dependencies
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests -B

# Runtime stage
FROM eclipse-temurin:17-jre-alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Create user
RUN addgroup -g 1001 -S eureka && \
    adduser -S eureka -u 1001 -G eureka

WORKDIR /app

# Copy JAR from builder stage
COPY --from=builder /app/target/eureka-server-*.jar app.jar

# Change ownership
RUN chown eureka:eureka app.jar

USER eureka

EXPOSE 8761

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8761/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]