
pipeline {
  agent any

  environment {
    DOCKERHUB_USER = "faisal1607"
    FRONTEND_IMAGE = "frontend-app"
    BACKEND_IMAGE = "backend-app"
  }

  stages {

    stage('Checkout') {
      steps {
        git 'https://github.com/mohammedfais-16/Project-12'
      }
    }

    stage('Build Images') {
      steps {
        sh '''
        docker build -t $DOCKERHUB_USER/$FRONTEND_IMAGE ./frontend
        docker build -t $DOCKERHUB_USER/$BACKEND_IMAGE ./backend
        '''
      }
    }

    stage('Push Images') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh '''
          docker login -u $USER -p $PASS
          docker push $DOCKERHUB_USER/$FRONTEND_IMAGE
          docker push $DOCKERHUB_USER/$BACKEND_IMAGE
          '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
  steps {
    sh 'kubectl apply -f k8s/'
  }
}

  }
}
