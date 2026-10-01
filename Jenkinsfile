pipeline{
    agent none
    stages{
        stage('Checkout'){
            agent any
            steps {
                echo 'Code checked out successfully '
            }
        }
        stage('Trigger'){
            agent any
            steps{
                echo "Trigger test"
            }
        }
        stage('Install'){
            agent{
                { docker {image 'node:22'}}
            }
            steps {
                sh 'npm ci'
            }
        }
        stage('Test'){
            agent {
                { docker {
                    image 'node:22'
                }}
            }
            steps{
                sh 'npm test'
            }
        }
        stage("build image"){
            agent {
                {docker
                    {
                        image 'docker:24'
                        args '-v /var/run/docker.sock:/var/run/docker.sock'
                    }
                }
            }
            steps{
                sh 'docker build -t devops-showcase-app:$BUILD_NUMBER .'
            }
        }
    }
}