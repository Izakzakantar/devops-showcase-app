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
            agent { docker { image 'node:22' } }
            steps {
                sh 'npm ci'
            }
        }
        stage('Test') {
            agent { docker { image 'node:22' } }
            steps {
                sh 'npm test'
            }
        }
        stage('Build and Push to ECR') {
            agent {
                docker {
                    image 'ishakantar/jekins-ecr-agent:v2'
                    args '-v /var/run/docker.sock:/var/run/docker.sock -u root'
                }
            }
            environment {
                AWS_ACCOUNT_ID = '298599751110'
                AWS_REGION = 'us-east-1'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-user-secret',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        docker build -t devops-showcase-app:$BUILD_NUMBER .
                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                        docker tag devops-showcase-app:$BUILD_NUMBER $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/devops-showcase-app:$BUILD_NUMBER
                        docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/devops-showcase-app:$BUILD_NUMBER
                    '''
                }
            }
        }
        stage('Deploy with Helm') {
            agent {
                docker {
                    image 'ishakantar/jekins-ecr-agent:v2'
                    args '-v /var/run/docker.sock:/var/run/docker.sock -u root'
                }
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-user-secret',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    withKubeConfig(credentialsId: 'jenkins-eks-config-file') {
                        sh '''
                            kubectl create secret docker-registry ecr-secret \
                              --docker-server=298599751110.dkr.ecr.us-east-1.amazonaws.com \
                              --docker-username=AWS \
                              --docker-password=$(aws ecr get-login-password --region us-east-1) \
                              --dry-run=client -o yaml | kubectl apply -f -

                            helm upgrade --install devops-showcase-app ./chart --set image.tag=$BUILD_NUMBER
                        '''
                    }
                }
            }
        }
    }
}