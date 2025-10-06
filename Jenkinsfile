pipeline {
    agent any

    environment {
        MYSQL_ROOT_PASSWORD = "root"
        MYSQL_DATABASE = "studentdb"
        MYSQL_CONTAINER_NAME = "mysql-student"
        SONAR_TOKEN = credentials('SONAR_TOKEN') // Ton token SonarQube
    }

    stages {

        stage('Start MySQL') {
            steps {
                script {
                    // Démarre le conteneur MySQL
                    sh """
                        docker run -d --name ${MYSQL_CONTAINER_NAME} \
                        -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
                        -e MYSQL_DATABASE=${MYSQL_DATABASE} \
                        -p 3306:3306 mysql:8.0
                    """
                }
            }
        }

        stage('Wait for MySQL') {
            steps {
                script {
                    def isUp = false
                    for (int i = 0; i < 20; i++) { // max 40 secondes
                        def result = sh(
                            script: "docker exec ${MYSQL_CONTAINER_NAME} mysqladmin ping -uroot -p${MYSQL_ROOT_PASSWORD} --silent",
                            returnStatus: true
                        )
                        if (result == 0) {
                            isUp = true
                            break
                        }
                        echo "Waiting for MySQL..."
                        sleep 2
                    }
                    if (!isUp) {
                        error "MySQL did not become ready ❌"
                    } else {
                        echo "MySQL is ready ✅"
                    }
                }
            }
        }

        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/EyaDahen/Student-Management.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn -B clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQubeServer') {
                    sh """
                        mvn clean verify sonar:sonar \
                        -Dsonar.projectKey=Student-Management \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }

        stage('Run Tests') {
            steps {
                sh 'mvn test'
            }
        }
    }

    post {
        always {
            // Arrête et supprime le conteneur MySQL pour nettoyage
            sh "docker stop ${MYSQL_CONTAINER_NAME} || true"
            sh "docker rm ${MYSQL_CONTAINER_NAME} || true"
        }
        success {
            echo "Pipeline terminé avec succès ✅"
        }
        failure {
            echo "Le pipeline a échoué ❌"
        }
    }
}
