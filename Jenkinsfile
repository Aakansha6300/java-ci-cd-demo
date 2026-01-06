pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK21'
    }

    environment {
        CONTAINER = "java-app"
        PORT      = "8090"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=java-app'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                docker build -t aakansha/java-app:${BUILD_NUMBER} .
                docker tag aakansha/java-app:${BUILD_NUMBER} aakansha/java-app:latest
                '''
            }
        }

        stage('Docker Deploy') {
            steps {
                sh '''
                docker rm -f $CONTAINER || true
                docker run -d \
                  --name $CONTAINER \
                  -p $PORT:$PORT \
                  aakansha/java-app:${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        success {
            echo "🚀 Application built, scanned, and deployed successfully"
        }
        failure {
            echo "❌ Pipeline failed — build or quality gate issue"
        }
    }
}

