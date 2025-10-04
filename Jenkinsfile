pipeline {
    agent any
       tools {
        maven 'Maven'  
        jdk 'JDK'
    }
    environment {
        M2_HOME = '-Dmaven.repo.local=.m2/repository' // Use a local Maven repository in the workspace
    }

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
