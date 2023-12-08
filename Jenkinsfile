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
        dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
        dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
      }
    }

    stage('TRIVY FS SCAN') {
      steps {
        sh "trivy fs . > trivyfs.txt"
      }
    }

    stage('Install Dependencies') {
      steps {
        sh "npm install"
      }
    }
  }
}
