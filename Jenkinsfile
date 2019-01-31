pipeline {
    agent none
    parameters {
        gitParameter name: 'GIT_TAG',
                     type: 'PT_TAG',
                     defaultValue: 'origin/master'
    }

    options {
      gitLabConnection('GitLab Sondeos')
    }

    triggers {
        gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType: 'All')
    }

    stages{
        stage('Build'){
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /jenkins/.m2:/jenkins/.m2'
                }
            }
            steps {
                sh 'mvn install package -e -X -Dmaven.test.skip=true'
            }
            post {
                success {
                    echo 'Archivando binarios...'
                    archiveArtifacts artifacts: '**/target/*.jar'
                }
            }
        }

        stage ('Analysis') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /jenkins/.m2:/jenkins/.m2'
                }
            }
            steps{
                sh "mvn -batch-mode -V -U -e checkstyle:checkstyle pmd:pmd findbugs:findbugs" //"sonar:sonar"

                step([$class: 'hudson.plugins.checkstyle.CheckStylePublisher', pattern: '**/target/checkstyle-result.xml'])
                step([$class: 'PmdPublisher', pattern: '**/target/pmd.xml'])
                step([$class: 'FindBugsPublisher', pattern: '**/findbugsXml.xml'])

            }
        }

        stage ('Test') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /jenkins/.m2:/jenkins/.m2'
                }
            }
            steps{
                sh "mvn test"

                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/*.xml', healthScaleFactor: 1.0])

            }
        }

        stage ('Deployments'){
            parallel{
                stage ('Deploy en Desa'){
                    agent {label 'PREPRO - 70'}
                    steps {
                        // TODO: https://stackoverflow.com/questions/15174194/jenkins-host-key-verification-failed
                        echo "Se comienza el DEPLOY en "+"${env.NODE_NAME}"+'.'

                        sh '''

                        # Definimos la ruta de trabajo
                        ROOTDIR="/usr/CMP/servicios_cmp_backend"

                        # Limpiamos la carpeta de los binarios obsoletos
                        cd $ROOTDIR
                        rm *.jar_* || true

                        # Guardamos el nombre del archivo de BACKUP
                        FILENAME=servicios_cmp_backend.jar

                        # Realizo el BACKUP
                        cp ${FILENAME} ${FILENAME}_$(date +%d-%m-%Y) || true

                        # DEPLOY
                        echo "Se comienza con el DEPLOY"
                        cp ${WORKSPACE}/target/*.jar $FILENAME && echo "Se realizo el DEPLOY"

                        # Artifact perms
                        echo "Actulizamos los permisos"
                        chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
                        chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

                        # Variable API
                        API="servicios-cmp-backend"

                        # Control del servicio
                        echo "Reiniciando el servicio"
                        /usr/sbin/service $API stop || true
                        sleep 1 && /usr/sbin/service $API start
                        ps aux | grep -v grep | grep $FILENAME

                        '''

                        echo "Se finaliza el DEPLOY en "+"${env.NODE_NAME}"+'.'
                    }
                }

                stage ('Deploy en QA'){
                    agent {label 'QA - 110'}
                    when {
                        not {
                            //tag "master"
                            tag "${params.master}"
                        }
                    }
                    steps{
                        echo "Checking out: ${params.GIT_TAG}"

                        timeout(time:5, unit:'DAYS'){
                            input message:'Aprueba el Deploy en QA?', submitter: "admin"

                        checkout([$class: 'GitSCM',
                                  branches: [[name: "${params.GIT_TAG}"]],
                                  doGenerateSubmoduleConfigurations: false,
                                  extensions: [],
                                  gitTool: 'Default',
                                  submoduleCfg: [],
                                ])

                            script {
                                if (currentBuild.currentResult == 'SUCCESS') {
                                    echo "Se realizo el deploy de la version ${GIT_TAG}"
                                    echo "Resultado de la build: ${currentBuild.currentResult}"
                                }
                                else {
                                    echo "Resultado de la build: ${currentBuild.currentResult}"
                                }
                            }
                        }
                        echo "Se comienza el DEPLOY en "+"${env.NODE_NAME}"+'.'
                        /*
                        sh '''

                        # Definimos la ruta de trabajo
                        ROOTDIR="/usr/CMP/servicios_cmp_backend"

                        # Limpiamos la carpeta de los binarios obsoletos
                        cd $ROOTDIR
                        rm *.jar_* || true

                        # Guardamos el nombre del archivo de BACKUP
                        FILENAME=servicios_cmp_backend.jar

                        # Realizo el BACKUP
                        cp ${FILENAME} ${FILENAME}_$(date +%d-%m-%Y) || true

                        # DEPLOY
                        echo "Se comienza con el DEPLOY"
                        cp ${WORKSPACE}/target/*.jar $FILENAME && echo "Se realizo el DEPLOY"

                        # Artifact perms
                        echo "Actulizamos los permisos"
                        chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
                        chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

                        # Variable API
                        API="servicios-cmp-backend"

                        # Control del servicio
                        echo "Reiniciando el servicio"
                        /usr/sbin/service $API stop || true
                        sleep 1 && /usr/sbin/service $API start
                        ps aux | grep -v grep | grep $FILENAME

                        '''
                        */
                        echo "Se finaliza el DEPLOY en "+"${env.NODE_NAME}"+'.'
                    }
                }
            }
        }

        stage ('Deploy to Production'){
            agent any
            when {
                not {
                    // tag "master"
                    tag "${params.master}"
                }
            }
            steps{
                echo "Checking out: ${params.GIT_TAG}"

                timeout(time:5, unit:'DAYS'){
                    input message:'Aprobar Deploy en Prod?', submitter: "admin"

                checkout([$class: 'GitSCM',
                          branches: [[name: "${params.GIT_TAG}"]],
                          doGenerateSubmoduleConfigurations: false,
                          extensions: [],
                          gitTool: 'Default',
                          submoduleCfg: [],
                        ])

                    script {
                        if (currentBuild.currentResult == 'SUCCESS') {
                            echo "Se realizo el deploy de la version ${GIT_TAG}"
                            echo "Resultado de la build: ${currentBuild.currentResult}"
                        }
                        else {
                            echo "Resultado de la build: ${currentBuild.currentResult}"
                        }
                    }
                }
            }

            post {
                success {
                    echo 'Cambios implementados en '+"${env.NODE_NAME}"+'.'

                    updateGitlabCommitStatus name: 'build', state: 'success'

                    /*mail to: 'noc@sondeos.com.ar',
                        from: 'NoReply@sondeos.com.ar',
                        subject: "Pipeline Exitosa: ${currentBuild.fullDisplayName}",
                        body: "Se concreto correctamente el deploy de ${env.BUILD_URL} en ${env.NODE_NAME}."*/
                }

                failure {
                    echo 'Deploy fallido en '+"${env.NODE_NAME}"+'.'

                    updateGitlabCommitStatus name: 'build', state: 'failed'

                    /*mail to: 'noc@sondeos.com.ar',
                        from: 'NoReply@sondeos.com.ar',
                        subject: "Pipeline Fallida: ${currentBuild.fullDisplayName}",
                        body: "Algo esta mal con ${env.BUILD_URL} en ${env.NODE_NAME}."*/
                }
            }
        }
    }
}
