pipeline {
  agent any
  environment {
    IMAGE = "jehp/flask:latest"
  }
  stages {
    stage('Git clone') {
      steps {
        git branch: 'main', url: 'https://github.com/SatGitZ/Flaskapp.git'
      }
    }
    stage('Build Docker image') {
      steps {
        sh "docker build -t $IMAGE ."
      }
    }
    stage('Run tests') {
      steps {
        sh "./test_api.sh"
      }
    }
    stage('Push to Docker Hub') {
      when { branch 'main' }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-pat', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
          sh "docker push $IMAGE"
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        sh "kubectl apply -f deployment.yaml"
        sh "kubectl apply -f service.yaml"
      }
    }
    stage('Cleanup') {
      steps {
        sh "docker rmi $IMAGE || true"
      }
    }
  }
}
