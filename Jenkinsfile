pipeline {
    agent none
    /*triggers {
          pollSCM('H/5 * * * *')
    }*/

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
                    agent {label 'PREPRO'}
                    steps {
                        // TODO: https://stackoverflow.com/questions/15174194/jenkins-host-key-verification-failed
                        echo "Se comienza el DEPLOY en "+"${env.NODE_NAME}"+'.'

                        sh '''

                        #Definimos la ruta de trabajo
                        ROOTDIR="/usr/CMP/servicios_cmp_backend"

                        echo "Quien soy?"
                        whoami

                        #Limpiamos la carpeta de los binarios obsoletos
                        cd $ROOTDIR
                        echo "DONDE ESTOY?"
                        echo ${WORKSPACE}
                        pwd
                        rm *.jar_* || true

                        #Guardamos el nombre del archivo de BACKUP
                        FILENAME=servicios_cmp_backend.jar

                        #Realizo el BACKUP
                        cp ${FILENAME} ${FILENAME}_$(date +%d-%m-%Y) || true

                        #DEPLOY
                        echo "DEPLOY"
                        cp ${WORKSPACE}/target/*.jar $FILENAME && echo "Se realizo el DEPLOY"

                        #Artifact perms
                        chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
                        chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

                        # Variable API
                        API="servicios-cmp-backend"

                        /usr/sbin/service $API stop || true
                        sleep 1 && /usr/sbin/service $API start
                        ps aux | grep -v grep | grep $FILENAME

                        '''

                        echo "Se finaliza el DEPLOY en "+"${env.NODE_NAME}"+'.'
                    }
                }

                stage ('Deploy en QA'){
                    agent {label 'QA'}
                    steps{
                        timeout(time:5, unit:'DAYS'){
                            input message:'Aprueba el Deploy en QA?', submitter: "admin"
                        }
                        echo "Se comienza el DEPLOY en "+"${env.NODE_NAME}"+'.'
                        /*
                        sh '''

                        #Definimos la ruta de trabajo
                        ROOTDIR="/appuser/serviciosCmpBackend"

                        #Limpiamos la carpeta de los binarios obsoletos
                        cd $ROOTDIR
                        echo "DONDE ESTOY?"
                        echo ${WORKSPACE}
                        pwd
                        rm *.jar_* || true

                        #Guardamos el nombre del archivo de BACKUP
                        FILENAME=servicios_cmp_backend.jar

                        #Realizo el BACKUP
                        cp ${FILENAME} ${FILENAME}_$(date +%d-%m-%Y) || true

                        #DEPLOY
                        echo "DEPLOY"
                        cp ${WORKSPACE}/target/*.jar $FILENAME && echo "Se realizo el DEPLOY"

                        #Artifact perms
                        chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
                        chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

                        #ps aux | grep -v grep | grep $FILENAME

                        # Variable API
                        API="servicios-cmp-backend"

                        /bin/systemctl stop $API.service || true
                        sleep 1 && /bin/systemctl start $API.service
                        ps aux | grep -v grep | grep $FILENAME

                        '''
                        */
                        echo "Se finaliza el DEPLOY en "+"${env.NODE_NAME}"+'.'

                    }
                    post {
                        success {
                            echo 'Cambios implementados en '+"${env.NODE_NAME}"+'.'
                            mail to: 'noc@sondeos.com.ar',
                                from: 'NoReply@sondeos.com.ar',
                                subject: "Pipeline Exitosa: ${currentBuild.fullDisplayName}",
                                body: "Se concreto correctamente el deploy de ${env.BUILD_URL} en ${env.NODE_NAME}"
                        }

                        failure {
                            echo 'Deploy fallido en '+"${env.NODE_NAME}"+'.'
                            mail to: 'noc@sondeos.com.ar',
                                from: 'NoReply@sondeos.com.ar',
                                subject: "Pipeline Fallida: ${currentBuild.fullDisplayName}",
                                body: "Algo esta mal con ${env.BUILD_URL} en ${env.NODE_NAME}"
                        }
                    }
                }
            }
        }


        stage ('Deploy to Production'){
            agent any
            steps{
                timeout(time:5, unit:'DAYS'){
                    input message:'Aprobar Deploy en Prod?', submitter: "admin"
                }
                echo "Llegamos a "+"${env.NODE_NAME}"+'.'

            }
        }
    }
}
