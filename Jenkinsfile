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
        stage('Build image') {
            agent {
                docker {
                    image 'docker:24'
                    args '-v /var/run/docker.sock:/var/run/docker.sock --group-add 0 -u root'
                }
            }
            steps {
                sh 'docker build -t devops-showcase-app:$BUILD_NUMBER .'
            }
        }
        stage('Get ECR login password') {
            agent {
                docker {
                    image 'amazon/aws-cli:2.17.62'
                    args '--entrypoint="" -u root'
                }
            }
            environment {
                AWS_REGION = 'us-east-1'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-user-secret',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh 'aws ecr get-login-password --region $AWS_REGION > ecrpass.txt'
                    stash includes: 'ecrpass.txt', name: 'ecr-password'
                }
            }
        }
        stage('Push to ECR') {
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
                unstash 'ecr-password'
                sh 'mkdir -p $DOCKER_CONFIG'
                sh '''
                    cat ecrpass.txt | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    docker tag devops-showcase-app:$BUILD_NUMBER $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/devops-showcase-app:$BUILD_NUMBER
                    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/devops-showcase-app:$BUILD_NUMBER
                    rm -f ecrpass.txt
                '''
            }
        }
    }
}