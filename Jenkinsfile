pipeline{
    agent {
        docker {image 'node:22'}
    }
    stages{
        stage('Checkout'){
            steps {
                echo 'Code checked out successfully '
            }
        }
        stage('Trigger'){
            steps{
                echo "Trigger test"
            }
        }
        stage('Install'){
            steps {
                sh 'npm ci'
            }
        }
        stage('Test'){
            steps{
                sh 'npm test'
            }
        }
    }
}