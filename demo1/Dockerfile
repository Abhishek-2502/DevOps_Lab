# ---------- Stage 1: Build the JAR ----------
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and source
COPY pom.xml .
COPY src ./src

# Build (skip tests)
RUN mvn clean package -DskipTests

# ---------- Stage 2: Run the app ----------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy JAR from build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 9091
ENTRYPOINT ["java", "-jar", "app.jar"]


# mvn clean package -DskipTests
# docker build -t springboot-app1 .
# docker run -p 9091:9091 springboot-app1