pipeline{
    agent any
    stages {
        stage('Checkout scm') {
            steps{
                git branch: 'master', url: 'https://github.com/adamandika/BigProjectKu'

            }
        }   
        stage('test'){
            steps{
                echo "test"
            }
        }
        stage('list sourcode'){
            steps{
                sh("ls")
            }
        }
        stage('melakukan docker build dan docker push'){
            steps{
                sh("cat $HOME/password.txt | docker login -u adamandika --password-stdin")
                sh("docker build -t adamandika/client:$BUILD_NUMBER .")
                sh("docker push adamandika/server-js:$BUILD_NUMBER")
            }
        }
        
    }
}