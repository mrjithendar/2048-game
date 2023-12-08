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
    stage('Install Dependencies') {
      steps {
        sh "npm install"
      }
    }
  }
}
