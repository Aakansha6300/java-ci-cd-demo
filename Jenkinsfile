pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    stages {

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh '''
                    sonar-scanner \
                      -Dsonar.projectKey=java-app \
                      -Dsonar.sources=src \
                      -Dsonar.java.binaries=target
                    '''
                }
            }
        }
    }
}

