pipeline {
    agent none
    // Actualizamos el estado de la build en la herramienta SCM
    post {
        success {
            updateGitlabCommitStatus name: 'build', state: 'success'
        }
        failure {
            updateGitlabCommitStatus name: 'build', state: 'failed'

        }
        aborted {
            updateGitlabCommitStatus name: 'build', state: 'canceled'
        }
    }

    options {
        // Definimos la herramienta SCM a utilizar (Previamente configurada en el Admin del Master de Jenkins)
        gitLabConnection('GitLab Sondeos')
        // Desactivamos el Checkout default ya que puede causar que no tome los commits
        skipDefaultCheckout(true)
    }

    triggers {
        // Definimos que tipo de evento en la SCM desata la build del proyecto
        gitlab(triggerOnPush: true, triggerOnMergeRequest: true, branchFilterType: 'All')
    }

    parameters {
        // Parametros de TAG en Git
        gitParameter name: 'GIT_TAG',
                     type: 'PT_TAG',
                     defaultValue: 'origin/master'
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

        stage ('Analysis') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /jenkins/.m2:/jenkins/.m2'
                }
            }
            steps{
                // Checkout con los ultimos cambios (incluyendo los commits)
                checkout scm
                sh "mvn -batch-mode -V -U -e checkstyle:checkstyle pmd:pmd findbugs:findbugs" //"sonar:sonar"

                // Realizamos el analisis estatico del codigo
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
                // Checkout con los ultimos cambios (incluyendo los commits)
                checkout scm
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
                        // Checkout con los ultimos cambios (incluyendo los commits)
                        checkout scm
                        echo "Se comienza el DEPLOY en "+"${env.NODE_NAME}"

                        // Deploy script
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
                        echo "Actualizamos los permisos"
                        chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
                        chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

                        # Variable API
                        API="servicios-cmp-backend"

                        # Control del servicio
                        echo "Reiniciando el servicio"
                        /usr/sbin/service $API stop || true
                        sleep 1
                        /usr/sbin/service $API start
                        # Verificamos que el servicio esta corriendo
                        ps aux | grep -v grep | grep $FILENAME
                        '''
                        echo "Se finaliza el DEPLOY en "+"${env.NODE_NAME}"
                    }
                }

                stage ('Deploy en QA'){
                    agent {label 'QA - 110'}
                    steps{
                        script {
                            // Checkout utilizando el parametro que contiene el ID del TAG
                            checkout([$class: 'GitSCM',
                                      branches: [[name: "${params.GIT_TAG}"]],
                                      doGenerateSubmoduleConfigurations: false,
                                      extensions: [],
                                      gitTool: 'Default',
                                      submoduleCfg: [],
                                    ])

                            // Verificamos que la Build sea por un TAG
                            def tag = sh(returnStdout: true, script: "git tag --contains | head -1").trim()
                            if (tag) {
                                echo "ES TAG"
                                echo "Checking out: ${params.GIT_TAG}"
                            }
                            else {
                                echo "NO ES TAG"
                                echo "Se omite el Deploy"
                            }
                        }

                        timeout(time:5, unit:'DAYS'){
                            // Email de solicitud para continuar con el Deploy
                            mail to: 'nicolas.solignac@sondeos.com.ar',
                                from: 'YourFriendlyNeighbourJenkins',
                                subject: "Se requiere aprovacion para: ${currentBuild.fullDisplayName}",
                                body: "Se requiere aprovacion para proceder con el Deploy de ${currentBuild.fullDisplayName} en ${env.NODE_NAME}.\nAcceder al siguiente link: ${env.RUN_DISPLAY_URL}"

                            // Pedimos al usuario encargado que valide el Deploy
                            input message:'Aprueba el Deploy en QA?', submitter: "QA"
                            // TODO: if (${env.BUILD_USER_EMAIL} == ?? ) {wathever}

                            // Imprimimos el nombre y mail del usuario que inicio el build
                            wrap([$class: 'BuildUser']) {
                            echo "${env.BUILD_USER}"
                            echo "${env.BUILD_USER_EMAIL}"
                            }
                            script {
                                if (currentBuild.currentResult == 'SUCCESS') {
                                    // Deploy
                                    echo "Se comienza el DEPLOY en "+"${env.NODE_NAME}"
                                    // DEPLOY SCRIPT
                                    /*sh '''

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
                                    echo "Actualizamos los permisos"
                                    chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
                                    chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

                                    # Variable API
                                    API="servicios-cmp-backend"

                                    # Control del servicio
                                    echo "Reiniciando el servicio"
                                    /usr/sbin/service $API stop || true
                                    sleep 1
                                    /usr/sbin/service $API start
                                    ps aux | grep -v grep | grep $FILENAME

                                    '''*/
                                    echo "Se finaliza el DEPLOY en "+"${env.NODE_NAME}"+" de la version "+"${GIT_TAG}"
                                }
                                else {
                                    echo "WARNING: Resultado de la build: ${currentBuild.currentResult}"
                                    // Script rollback
                                    /*sh '''

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
                                    echo "Actualizamos los permisos"
                                    chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
                                    chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

                                    # Variable API
                                    API="servicios-cmp-backend"

                                    # Control del servicio
                                    echo "Reiniciando el servicio"
                                    /usr/sbin/service $API stop || true
                                    sleep 3
                                    /usr/sbin/service $API start
                                    ps aux | grep -v grep | grep $FILENAME

                                    # Verificamos que el servicio esta corriendo
                                    if systemctl is-active --quiet $API.service == 0; then
                                      true
                                    else
                                      # Realizamos el Rollback
                                      cp ${FILENAME}_$(date +%d-%m-%Y) ${FILENAME}

                                      # Reiniciamos el servicio
                                     echo "Reiniciando el servicio"
                                     /usr/sbin/service $API stop || true
                                     sleep 3
                                     /usr/sbin/service $API start
                                     ps aux | grep -v grep | grep $FILENAME

                                    '''*/
                                }
                            }
                        }
                    }

                    // Email informando el resultado del Deploy en el ambiente
                    post {
                        success {
                            echo 'Cambios implementados en '+"${env.NODE_NAME}"

                            mail to: 'nicolas.solignac@sondeos.com.ar',
                                from: 'YourFriendlyNeighbourJenkins',
                                subject: "Pipeline Exitosa: ${currentBuild.fullDisplayName}",
                                body: "Se concreto correctamente el deploy de ${env.BUILD_URL} en ${env.NODE_NAME}."
                        }

                        failure {
                            echo 'Deploy fallido en '+"${env.NODE_NAME}"

                            mail to: 'nicolas.solignac@sondeos.com.ar',
                                from: 'YourFriendlyNeighbourJenkins',
                                subject: "Pipeline Fallida: ${currentBuild.fullDisplayName}",
                                body: "Algo esta mal con ${env.BUILD_URL} en ${env.NODE_NAME}."
                        }
                    }
                }
            }
        }

        stage ('Deploy to Production'){
            agent any
            steps{
                script {
                    // Checkout utilizando el parametro que contiene el ID del TAG
                    checkout([$class: 'GitSCM',
                              branches: [[name: "${params.GIT_TAG}"]],
                              doGenerateSubmoduleConfigurations: false,
                              extensions: [],
                              gitTool: 'Default',
                              submoduleCfg: [],
                            ])

                    // Verificamos que la Build sea por un TAG
                    def tag = sh(returnStdout: true, script: "git tag --contains | head -1").trim()
                    if (tag) {
                        echo "ES TAG"
                        echo "Checking out: ${params.GIT_TAG}"
                    }
                    else {
                        echo "NO ES TAG"
                        echo "Se omite el Deploy"
                    }
                }

                timeout(time:5, unit:'DAYS'){
                    // Email de solicitud para continuar con el Deploy
                    mail to: 'nicolas.solignac@sondeos.com.ar',
                        from: 'YourFriendlyNeighbourJenkins',
                        subject: "Se requiere aprovacion para: ${currentBuild.fullDisplayName}",
                        body: "Se requiere aprovacion para proceder con el Deploy de ${currentBuild.fullDisplayName} en ${env.NODE_NAME}.\nAcceder al siguiente link: ${env.RUN_DISPLAY_URL}"
                    // Pedimos al usuario encargado que valide el Deploy
                    input message:'Aprobar Deploy en Prod?', submitter: "admin"

                    script {
                        if (currentBuild.currentResult == 'SUCCESS') {
                            // Deploy
                            echo "Se comienza el DEPLOY en "+"${env.NODE_NAME}"
                            // DEPLOY SCRIPT
                            /*sh '''

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
                            echo "Actualizamos los permisos"
                            chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
                            chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

                            # Variable API
                            API="servicios-cmp-backend"

                            # Control del servicio
                            echo "Reiniciando el servicio"
                            /usr/sbin/service $API stop || true
                            sleep 1
                            /usr/sbin/service $API start
                            ps aux | grep -v grep | grep $FILENAME

                            '''*/
                            echo "Se finaliza el DEPLOY en "+"${env.NODE_NAME}"+" de la version "+"${GIT_TAG}"
                            echo "Resultado de la build: ${currentBuild.currentResult}"
                        }
                        else {
                            // Script rollback
                            /*sh '''

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
                            echo "Actualizamos los permisos"
                            chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME
                            chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME

                            # Variable API
                            API="servicios-cmp-backend"

                            # Control del servicio
                            echo "Reiniciando el servicio"
                            /usr/sbin/service $API stop || true
                            sleep 3
                            /usr/sbin/service $API start
                            ps aux | grep -v grep | grep $FILENAME

                            # Verificamos que el servicio esta corriendo
                            if systemctl is-active --quiet $API.service == 0; then
                              true
                            else
                              # Realizamos el Rollback
                              cp ${FILENAME}_$(date +%d-%m-%Y) ${FILENAME}

                              # Reiniciamos el servicio
                             echo "Reiniciando el servicio"
                             /usr/sbin/service $API stop || true
                             sleep 3
                             /usr/sbin/service $API start
                             ps aux | grep -v grep | grep $FILENAME

                            '''*/
                            echo "WARNING: Resultado de la build: ${currentBuild.currentResult}"
                        }
                    }
                }
            }

            /*post {
                success {
                    echo 'Cambios implementados en '+"${env.NODE_NAME}"

                    mail to: 'noc@sondeos.com.ar',
                        from: 'YourFriendlyNeighbourJenkins',
                        subject: "Pipeline Exitosa: ${currentBuild.fullDisplayName}",
                        body: "Se concreto correctamente el deploy de ${env.BUILD_URL} en ${env.NODE_NAME}."
                }

                failure {
                    echo 'Deploy fallido en '+"${env.NODE_NAME}"

                    mail to: 'noc@sondeos.com.ar',
                        from: 'YourFriendlyNeighbourJenkins',
                        subject: "Pipeline Fallida: ${currentBuild.fullDisplayName}",
                        body: "Algo esta mal con ${env.BUILD_URL} en ${env.NODE_NAME}."
                }
            }*/
        }
    }
}
