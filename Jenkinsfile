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

    stage('Build') {
      steps {
        dir('backend') {
          sh 'npm ci'
          sh 'docker build -t backend:latest .'
        }
        dir('frontend') {
          sh 'npm ci'
          sh 'npm run build'
          sh 'docker build -t frontend:latest .'
        }
      }
    }

    stage('Unit Tests') {
      steps {
        parallel(
          failFast: true,
          backend: {
            dir('backend') {
              sh 'npm test'
            }
          },
          frontend: {
            dir('frontend') {
              sh 'CI=true npm test'
            }
          }
        )
      }
    }

    stage('Deploy') {
      steps {
        sh 'opentofu init'
        sh 'opentofu apply -auto-approve'
        sh 'helm upgrade --install backend ./helm/backend'
        sh 'helm upgrade --install frontend ./helm/frontend'
      }
    }
  }
}
