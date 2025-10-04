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
                echo 'Building the application...'
                script {
                    if (isUnix()) {
                        sh '''
                            echo "Setting execute permissions for Maven wrapper..."
                            chmod +x mvnw
                            echo "Building with Maven wrapper..."
                            if ./mvnw clean compile; then
                                echo "Build successful with Maven wrapper"
                            else
                                echo "Maven wrapper failed, trying system Maven..."
                                mvn clean compile
                            fi
                        '''
                    } else {
                        bat '.\\mvnw.cmd clean compile'
                    }
                }
            }
        }
       
    }
}
