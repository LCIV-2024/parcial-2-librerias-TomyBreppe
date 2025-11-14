# // TO DO: Implementar el Dockerfile
# ---- STAGE 1: Build the JAR ----
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# ---- STAGE 2: Run the application ----
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copiar el jar generado
COPY --from=build /app/target/*.jar app.jar

# Crear directorio para H2 y permitir que Docker lo persista
RUN mkdir -p /data

# Puerto usado por la app
EXPOSE 8080

# Importante para H2 file-based
ENV SPRING_DATASOURCE_URL=jdbc:h2:file:/data/libreria_db

ENTRYPOINT ["java", "-jar", "app.jar"]
