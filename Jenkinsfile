pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        // == Configurações do registry =========================================
        REGISTRY      = 'ghcr.io'
        IMAGE_NAME    = 'ghcr.io/luizbrito7/cp02-jenkins.fiap'
        IMAGE_TAG     = "${BUILD_NUMBER}"
        IMAGE_FULL    = "${IMAGE_NAME}:${IMAGE_TAG}"

        // == Credenciais (configurar no Jenkins) ===============================
        // GHCR_CREDENTIALS : Username/Password (user=gh-user, pass=PAT token)
        // APP_VM_SSH        : SSH Private Key para acessar a vm-app-lab
        // APP_VM_IP         : Secret text com o IP da vm-app-lab
        GHCR_CREDENTIALS = credentials('GHCR_CREDENTIALS')
        APP_VM_IP        = credentials('APP_VM_IP')
    }

    stages {

        // == CI: Build & Push ==================================================
        stage('CI - Build') {
            steps {
                echo "Building image: ${IMAGE_FULL}"
                sh """
                    docker build \
                        --build-arg APP_VERSION=${IMAGE_TAG} \
                        --build-arg IMAGE_TAG=${IMAGE_TAG} \
                        -t ${IMAGE_FULL} \
                        ./app
                """
            }
        }

        stage('CI - Push to GHCR') {
            steps {
                echo "Pushing image to ${REGISTRY}"
                sh """
                    echo ${GHCR_CREDENTIALS_PSW} | docker login ${REGISTRY} \
                        -u ${GHCR_CREDENTIALS_USR} --password-stdin
                    docker push ${IMAGE_FULL}
                    docker logout ${REGISTRY}
                """
            }
        }

        // == CD: Deploy na vm-app-lab ==========================================
        stage('CD - Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo "Deploying ${IMAGE_FULL} na vm-app-lab (${APP_VM_IP})"
                sshagent(credentials: ['APP_VM_SSH']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no azureuser@${APP_VM_IP} '
                            echo ${GHCR_CREDENTIALS_PSW} | docker login ghcr.io \
                                -u ${GHCR_CREDENTIALS_USR} --password-stdin

                            docker pull ${IMAGE_FULL}

                            docker stop cp02-app || true
                            docker rm   cp02-app || true

                            docker run -d \
                                --name cp02-app \
                                --restart unless-stopped \
                                -p 3000:3000 \
                                -e APP_VERSION=${IMAGE_TAG} \
                                -e IMAGE_TAG=${IMAGE_TAG} \
                                ${IMAGE_FULL}

                            docker logout ghcr.io
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline concluído com sucesso! Imagem: ${IMAGE_FULL}"
        }
        failure {
            echo "Pipeline falhou no build #${BUILD_NUMBER}"
        }
        always {
            sh 'docker image prune -f || true'
        }
    }
}
