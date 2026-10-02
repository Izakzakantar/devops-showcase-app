pipeline {
    agent none
    stages {
        stage('Checkout') {
            agent any
            steps {
                echo 'Code checked out successfully'
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
                docker { image 'node:22' }
            }
            steps {
                sh 'npm test'
            }
        }
        stage('Build and Push to ECR') {
            agent {
                docker {
                    image 'docker:24'
                    args '-v /var/run/docker.sock:/var/run/docker.sock -u root'
                }
            }
            environment {
                AWS_ACCOUNT_ID = '298599751110'
                AWS_REGION = 'us-east-1'
            }
            steps {
                sh '''
                    apk add --no-cache curl unzip
                    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
                    unzip -q awscliv2.zip
                    ./aws/install
                    docker build -t devops-showcase-app:$BUILD_NUMBER .
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    docker tag devops-showcase-app:$BUILD_NUMBER $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/devops-showcase-app:$BUILD_NUMBER
                    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/devops-showcase-app:$BUILD_NUMBER
                '''
            }
        }
    }
}