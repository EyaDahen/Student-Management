# ---- Étape 1 : Build ----
FROM maven:3.9.8-eclipse-temurin-17 AS build

# Répertoire de travail
WORKDIR /app

# Copier uniquement le pom.xml pour cache des dépendances
COPY pom.xml .
RUN mvn dependency:go-offline

# Copier le code source
COPY src ./src

# Compiler et créer le jar (skip tests pour accélérer)
RUN mvn clean package -DskipTests

# ---- Étape 2 : Runtime ----
FROM eclipse-temurin:17-jdk

WORKDIR /app

# Copier le jar depuis l'étape build
COPY --from=build /app/target/*.jar app.jar

# Exposer le port utilisé par Spring Boot
EXPOSE 8080

# Variables d'environnement par défaut pour MySQL
ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/studentdb
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=root

# Lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
