pipeline {
  agent any
  stages {
    stage('Backend Tests') {
      steps {
        sh 'cd backend && npm ci && npm test'
      }
    }
    stage('Frontend Tests') {
      steps {
        sh 'cd frontend && npm ci && npm test -- --watchAll=false'
      }
    }
    stage('OpenTofu Tests') {
      steps {
        sh 'cd infrastructure && tofu test'
      }
    }
  }
}
