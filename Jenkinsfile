pipeline {
  agent any

  options {
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '5'))
    timestamps()
    timeout(time: 20, unit: 'MINUTES')
  }

  environment {
    IMAGE = 'krishnosaha/isec6000-assessment2-app'
  }

  stages {
    stage('Install dependencies') {
      agent {
        docker {
          image 'node:16-alpine'
          args '-e HOME=/tmp -e npm_config_cache=/tmp/.npm'
          reuseNode true
        }
      }
      steps {
        sh 'npm install --no-audit --no-fund'
      }
    }

    stage('Unit tests') {
      agent {
        docker {
          image 'node:16-alpine'
          args '-e HOME=/tmp -e npm_config_cache=/tmp/.npm'
          reuseNode true
        }
      }
      steps {
        sh 'node --test test/app.test.js'
      }
    }

    stage('Security scan') {
      agent {
        docker {
          image 'node:16-alpine'
          args '-e HOME=/tmp -e npm_config_cache=/tmp/.npm'
          reuseNode true
        }
      }
      steps {
        // save the full report first, this never fails
        sh 'npm audit --omit=dev --json > npm-audit-report.json || true'
        // the gate: fails the build on any High or Critical vulnerability
        sh 'npm audit --omit=dev --audit-level=high'
      }
    }

    stage('Build image') {
      steps {
        sh 'docker build -t $IMAGE:$BUILD_NUMBER -t $IMAGE:latest .'
      }
    }

    stage('Push image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                         usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh '''
            echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
            docker push $IMAGE:$BUILD_NUMBER
            docker push $IMAGE:latest
            docker logout
          '''
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'npm-audit-report.json', allowEmptyArchive: true
    }
  }
}
