pipeline{
    agent any
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