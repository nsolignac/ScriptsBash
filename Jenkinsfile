def getProjectName() {
    return 'cmp-servicios'
}

def getJDKVersion() {
    return 'jdk1.8.0_212'
}

def getMavenConfig() {
    return 'maven-config'
}

def getDockerLocation() {
    return '/usr/bin/docker'
}

def getMavenLocation() {
    return 'MAVEN_HOME'
}

def getEnvironment() {
    return  'QA\n' +
            'PRE\n' +
            'PROD'
}

def getEmailRecipients() {
    return ''
}

def getReportZipFile() {
    return "Reportes_Build_${BUILD_NUMBER}.zip"
}

def publishHTMLReports(reportName) {
    // Publish HTML reports (HTML Publisher plugin)
    publishHTML([allowMissing         : true,
                 alwaysLinkToLastBuild: true,
                 keepAll              : true,
                 reportDir            : 'target\\view',
                 reportFiles          : 'index.html',
                 reportName           : reportName])
}

// To be determined dynamically later
def EXECUTOR_AGENT=null

pipeline {
    // agent section specifies where the entire Pipeline will execute in the Jenkins environment
    agent {
        /**
         * node allows for additional options to be specified
         * you can also specify label '' without the node option
         * if you want to execute the pipeline on any available agent use the option 'agent any'
         */
        node {
            label '' //Execute the Pipeline on an agent available in the Jenkins environment with the provided label
        }
    }

    /**
     * parameters directive provides a list of parameters which a user should provide when triggering the Pipeline
     * some of the valid parameter types are booleanParam, choice, file, text, password, run, or string
     */
    parameters {
        choice(choices: "$environment", description: 'Ambiente donde se desea realizar el job', name: 'ENVIRONMENT')
        string(defaultValue: "$emailRecipients",
                description: 'List of email recipients',
                name: 'EMAIL_RECIPIENTS')
        gitParameter name: 'GIT_TAG',
                     type: 'PT_TAG',
                     defaultValue: '*/master'
    }

    stages {
        // Iniciamos la build del proyecto
        stage('Build'){
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /jenkins/.m2:/jenkins/.m2'
                }
            }
            steps {
                // Checkout con los ultimos cambios (incluyendo los commits)
                checkout scm
                sh 'mvn install package -e -X -Dmaven.test.skip=true'
            }
            post {
                success {
                    // Guardamos los binarios en el agente Master
                    echo 'Archivando binarios...'
                    archiveArtifacts artifacts: '**/target/*.jar'
                }
            }
        }

        // Analisis estatico del codigo
        stage ('Analysis') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /jenkins/.m2:/jenkins/.m2'
                }
            }
            steps{
                // Checkout del master
                checkout scm
                // Corremos el analisis
                sh "mvn -batch-mode -V -U -e checkstyle:checkstyle pmd:pmd findbugs:findbugs" //"sonar:sonar"

                // Guardamos los resultados del analisis
                step([$class: 'hudson.plugins.checkstyle.CheckStylePublisher', pattern: '**/target/checkstyle-result.xml'])
                step([$class: 'PmdPublisher', pattern: '**/target/pmd.xml'])
                step([$class: 'FindBugsPublisher', pattern: '**/findbugsXml.xml'])
            }
        }

        // Corremos los test del proyecto
        stage ('Test') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /jenkins/.m2:/jenkins/.m2'
                }
            }

            steps{
                // Checkout del master
                //checkout scm
                // Corremos los tests
                sh "mvn test"
                // Archivamos los resultados y los publicamos
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/*.xml', healthScaleFactor: 1.0])
            }
        }

        stage ('Deployments'){
            parallel{
                stage ('Deploy en Desa'){
                    agent {label 'PREPRO - 70'}
                    steps {
                        // Preparamos el Ambiente
                        script {
                            if(params.USE_INPUT_DUNS) {
                                configFileProvider([configFile(fileId: 'a85c2ba6-f4f4-4bfe-a901-640b7c218878',
                                        targetLocation: 'dev_script.sh')]) {
                                    echo 'Archivo de Deploy copiado en el ambiente'
                                }
                            }
                        }
                        //checkout scm
                        // Ejecutamos el script de Deploy
                        echo "Se comienza el DEPLOY en "+"${env.NODE_NAME}"
                        sh dev_script.sh
                        echo "Se finaliza el DEPLOY en "+"${env.NODE_NAME}"
                    }
                }

                stage ('Deploy en QA'){
                    agent {label 'QA - 110'}
                    steps {
                        script {
                            checkout([$class: 'GitSCM',
                                branches: [[name: "${params.GIT_TAG}"]],
                                doGenerateSubmoduleConfigurations: false,
                                extensions: [],
                                gitTool: 'Default',
                                submoduleCfg: [],
                                userRemoteConfigs: [[credentialsId: 'Soligna',
                                url: 'http://git.snd.int/Soligna/servicios_cmp_backend.git']]])
                        }

                        // Verificamos que la build sea por un TAG
                        def tag = sh(returnStdout: true, script: "git tag --contains | head -1").trim()
                        // Imprimimos valor de var:tag
                        echo tag
                        if(tag) {
                            echo "TAG"
                            echo "Checking out: ${params.GIT_TAG}"

                            timeout(time:5, unit:'DAYS'){
                                    // Email de solicitud para continuar con el Deploy
                                    mail to: 'nicolas.solignac@sondeos.com.ar',
                                        from: 'YourFriendlyNeighbourJenkins',
                                        subject: "Se requiere aprovacion para: ${currentBuild.fullDisplayName}",
                                        body: "Se requiere aprovacion para proceder con el Deploy de ${currentBuild.fullDisplayName} en ${env.NODE_NAME}.\nAcceder al siguiente link: ${env.RUN_DISPLAY_URL}"
                                    // Pedimos al usuario encargado que valide el Deploy
                                    input message:'Aprobar Deploy en Prod?', submitter: "admin"

                                    // Proporcionamos el archivo de configuracion correspondiente al entorno.
                                    configFileProvider([configFile(fileId: 'a1aa3157-d30f-469c-98f1-414e5c6936dc',
                                            targetLocation: 'qa_script.sh')]) {
                                        echo 'Archivo de Deploy copiado en el ambiente'
                                    }

                                    // Ejecutamos el script de Deploy
                                    echo "Se comienza el DEPLOY en "+"${env.NODE_NAME}"
                                    sh qa_script.sh
                                    echo "Se finaliza el DEPLOY en "+"${env.NODE_NAME}"
                            }
                        }
                        else {
                            echo "NO ES TAG"
                            echo "Se omite el DEPLOY en "+"${env.NODE_NAME}"
                        }
                    }
                }

                post {
                    // Run regardless of the completion status of the Pipeline run
                    always {
                        // send email
                        // email template to be loaded from managed files
                        emailext body: '${SCRIPT,template="managed:EmailTemplate"}',
                                attachLog: true,
                                compressLog: true,
                                attachmentsPattern: "$reportZipFile",
                                mimeType: 'text/html',
                                subject: "Pipeline Build ${BUILD_NUMBER}",
                                to: "${params.EMAIL_RECIPIENTS}"

                        // clean up workspace
                        deleteDir()
                    }
                    // Only run the steps if the current Pipeline’s or stage’s run has a "success" status
                    success {
                        updateGitlabCommitStatus name: 'build', state: 'success'
                    }
                    // Only run the steps if the current Pipeline’s or stage’s run has a "failure" status
                    failure {
                        updateGitlabCommitStatus name: 'build', state: 'failed'
                    }
                    // Only run the steps if the current Pipeline’s or stage’s run has a "aborted" status
                    aborted {
                        updateGitlabCommitStatus name: 'build', state: 'canceled'
                    }
                }
