pipeline {
    agent any

    tools {
        maven 'Maven'
    }

    environment {
        SONAR_PROJECT_KEY = 'java-app'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh """
                      mvn sonar:sonar \
                      -Dsonar.projectKey=${SONAR_PROJECT_KEY}
                    """
                }
            }
        }
    }
}

