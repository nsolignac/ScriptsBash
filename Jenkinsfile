pipeline {
    agent any
    stages{
        stage('Build'){
            steps {
                sh 'mvn clean package'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
        stage ('Deploy to PRE'){
            steps {
                build job: 'Deploy-to-staging'
            }
        }

        stage ('Deploy to QA'){
            steps{
                timeout(time:5, unit:'DAYS'){
                    input message:'Approve QA Deployment?', submitter: "admin"
                }

                build job: 'Deploy-to-Prod'
            }
            post {
                success {
                    echo 'Code deployed to Production.'
                }

                failure {
                    echo ' Deployment failed.'
                }
            }
        }


    }
}
