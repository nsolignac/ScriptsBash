pipeline {
    agent any
    stages{
        stage('Build'){
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
    }
}
