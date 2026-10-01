pipeline {
    agent none
    stages {
        stage('Checkout') {
            agent any
            steps {
                echo 'Code checked out successfully'
            }
        }
        stage('Trigger') {
            agent any
            steps {
                echo "Trigger test"
            }
        }
        stage('Install') {
            agent {
                docker { image 'node:22' }
            }
            steps {
                sh 'npm ci'
            }
        }
        stage('Test') {
            agent {
                docker {
                    image 'node:22'
                }
            }
            steps {
                sh 'npm test'
            }
        }
        stage('build image') {
            agent {
                docker {
                    image 'docker:24'
                    args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 0 -u root'
                }
            }
            environment {
                DOCKER_CONFIG = '/tmp/.docker'
                AWS_ACCOUNT_ID = '298599751110'
                AWS_REGION = 'us-east-1'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-user-secret',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh 'mkdir -p $DOCKER_CONFIG'
                    sh 'docker build -t devops-showcase-app:$BUILD_NUMBER .'
                    sh '''
                        apk add --no-cache curl unzip
                        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
                        unzip -q awscliv2.zip
                        ./aws/install
                        aws ecr get-login-password --region $AWS_REGION > /tmp/ecrpass.txt
                        cat /tmp/ecrpass.txt | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                        docker tag devops-showcase-app:$BUILD_NUMBER $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/devops-showcase-app:$BUILD_NUMBER
                        docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/devops-showcase-app:$BUILD_NUMBER
                        rm -f /tmp/ecrpass.txt
                    '''
                }
            }
        }
    }
}