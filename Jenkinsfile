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
          withCredentials([string(credentialsId: 'test_cred', variable: 'password')]) {
            sh " echo "$password" | docker login -u jithendar --password-stdin"
            sh "docker build -t 2048 ."
            sh "docker tag 2048 jithendar/2048:latest"
            sh "docker push jithendar/2048:latest"
          }
        }
      }
    }
    stage("TRIVY"){
      steps{
        sh "trivy image sushantkapare1717/2048:latest > trivy.txt"
      }
    }

//    stage('Install Dependencies') {
//      steps {
//        sh "npm install"
//      }
//    }


  }
}
