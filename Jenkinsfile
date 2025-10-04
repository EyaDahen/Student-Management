pipeline {
    agent any

    stages {
        stage('Git') {
            steps {
                git branch: 'main', url: 'https://github.com/EyaDahen/Student-Management.git'
            }
        }

          stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
       
    }
}
