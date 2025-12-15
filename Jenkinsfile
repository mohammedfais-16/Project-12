pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/mohammedfais-16/Movie-booking.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Deploy Application') {
            steps {
                sh '''
                docker-compose down || true
                docker-compose up -d
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                sleep 15
                curl -f http://localhost || exit 1
                '''
            }
        }
    }

    post {
        success { echo '✅ Deployment Successful' }
        failure { echo '❌ Deployment Failed' }
    }
}
