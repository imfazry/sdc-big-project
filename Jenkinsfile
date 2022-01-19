pipeline{
    agent any
    stages {
        stage('Checkout scm') {
            steps{
                git branch: 'master', url: 'https://github.com/adamandika/adam-mern-todo-app.git'

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
        stage('melakukan docker build'){
            steps{
                sh("cat $HOME/password.txt | docker login -u adamandika --password-stdin")
                sh("docker build -t adamandika/todo-app:$BUILD_NUMBER .")
                sh("docker push adamandika/todo-app:$BUILD_NUMBER")
            }
        }
        
    }
}