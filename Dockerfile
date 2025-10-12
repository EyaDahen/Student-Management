# Étape 1 : Build de l'application avec Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# Crée un dossier de travail dans le conteneur
WORKDIR /app

# Copie le pom.xml et les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copie le code source
COPY src ./src

# Compile le projet et génère le .jar
RUN mvn clean package -DskipTests

# Étape 2 : Création de l'image finale (plus légère)
FROM eclipse-temurin:17-jdk-jammy

# Dossier de travail
WORKDIR /app

# Copie le .jar depuis l’étape précédente
COPY --from=builder /app/target/*.jar app.jar

# Expose le port utilisé par Spring Boot
EXPOSE 8089

# Commande de lancement
ENTRYPOINT ["java", "-jar", "app.jar"]
