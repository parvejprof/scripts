pipeline {
    agent any
    tools {
        maven 'maven-3'
      jdk 'jdk-8'
    }
    stages {
        stage ('Build') {
            steps {
                checkout scm
                sh 'mvn clean test -Pfull-build,create-statics-package-bundle,sonar-build -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true'
            }
        }
        stage('SonarQube Analysis') {
          steps {
                withSonarQubeEnv('local') {
                    sh 'mvn sonar:sonar -Dsonar.host.url=$SONAR_HOST_URL -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.projectKey=com.bpi.portal -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true'
                }
            }

        }
	stage("Package and Publish to Nexus") {
            steps {
                sh 'mvn deploy -Pfull-build,create-statics-package-bundle,sonar-build -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true'
            }
        }

    }
}
