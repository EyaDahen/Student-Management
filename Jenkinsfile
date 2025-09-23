pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Compilation du projet...'
                sh 'mvn clean install'
            }
        }
        stage('Tests') {
            steps {
                echo 'Exécution des tests unitaires...'
                sh 'mvn test'
            }
        }
    }
}
