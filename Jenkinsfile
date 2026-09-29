pipeline{
    agent {
        docker {image 'node:22'} //we've used a temp Node 22 container
    }
    stages{
        stage('Checkout'){
            steps {
                echo 'Code checked out successfully'
            }
        }
        stage('Install'){
            steps {
                sh 'npm ci'
            }
        }
    }
}