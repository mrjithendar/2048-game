pipeline {
  agent any
  tools {
    jdk 'jdk17'
    nodejs 'node16'
  }
  environment {
    SCANNER_HOME=tool 'sonar-scanner'
  }

  stages {

    stage("Docker login") {
      steps {
        script {
          withCredentials([string(credentialsId: 'password', variable: 'dp')]) {
            sh "echo ${dp} | docker login -u jithendar --password-stdin"
          }
        }
      }
    }

    stage("Sonarqube Analysis "){
      steps{
        withSonarQubeEnv('sonar-server') {
          sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Game -Dsonar.projectKey=Game"
        }
      }
    }

    stage("quality gate"){
      steps {
        script {
          waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube'
        }
      }
    }

    stage('OWASP FS SCAN') {
      steps {
        dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-check'
        dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
      }
    }

    stage('TRIVY FS SCAN') {
      steps {
        sh "trivy fs . > trivyfs.txt"
      }
    }

    stage("Docker Build & Push"){
      steps {
        script {
          withCredentials([string(credentialsId: 'password', variable: 'dp')]) {
            sh "echo "${dp}" | docker login -u jithendar --password-stdin"
            sh "docker build -t 2048 ."
            sh "docker tag 2048 jithendar/2048:latest"
            sh "docker push jithendar/2048:latest"
          }
        }
      }
    }
    stage("TRIVY"){
      steps{
        sh "trivy image jithendar/2048:latest > trivy.txt"
      }
    }

    stage('Deploy to container'){
      steps{
        sh 'docker run -d --name 2048 -p 3000:3000 jithendar/2048:latest'
      }
    }

//    stage('Install Dependencies') {
//      steps {
//        sh "npm install"
//      }
//    }


  }
}
