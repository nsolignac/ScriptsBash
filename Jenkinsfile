pipeline {
    agent any
    stages{
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
            post {
                success {
                    echo 'Ahora Archivando'
                      archiveArtifacts artifacts: '**/target/*.jar'
                }
            }
        }
        stage ('Deploy a QA') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS'
              }
            }
            steps {
                build job: 'servicios-cmp-backend (Deploy-to-staging)'
            }
        }
    }
}
