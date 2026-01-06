pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK21'
    }

    environment {
        APP_NAME      = "java-app"
        IMAGE_NAME    = "aakansha/java-app"
        CONTAINER     = "java-app"
        PORT          = "8090"
        SONAR_PROJECT = "java-app"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build & Test') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh "mvn sonar:sonar -Dsonar.projectKey=${SONAR_PROJECT}"
                }
            }
        }

        stage('Quality Gate (Non-blocking)') {
            steps {
                echo "ℹ️ Quality Gate checked in SonarQube dashboard (non-blocking)"
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Docker Deploy') {
            steps {
                sh '''
                docker rm -f ${CONTAINER} || true
                docker run -d \
                  --name ${CONTAINER} \
                  -p ${PORT}:${PORT} \
                  ${IMAGE_NAME}:${BUILD_NUMBER}
                '''
            }
        }
    }

    post {
        success {
            echo "🚀 CI/CD pipeline completed successfully!"
            echo "🌐 App running on http://localhost:${PORT}"
            echo "📊 SonarQube: http://localhost:9000/dashboard?id=${SONAR_PROJECT}"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}

