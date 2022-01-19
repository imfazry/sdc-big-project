pipeline {
    agent any 
 
    stages {
           
        stage("Clone Repo"){
            steps{
                    git(url: 'https://github.com/adamandika/BigProjectKu.git', branch: 'master')
                    script{
                        commit_id = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                    }
                    
                
            }
        }

        // stage('static code analysis') {
        //     agent {
        //         docker { image 'sonarsource/sonar-scanner-cli' }
        //     }
        //     steps {
        //         script {    
        //          sh "sonar-scanner -Dsonar.host.url=http://13.212.184.179:9000/ -Dsonar.login=df0ed68381ea738cc506195d2cb5f9c677410516   -Dsonar.projectKey=todo-app"
        //             }
        //     }
        // }
        
        stage('Build Image'){
            steps{
                sh('docker build -t adamandika/client:${commit_id} .')
                sh('docker build -t adamandika/server-js:${commit_id} backend')
            }
        }


        stage("Push Image"){
            steps{
                sh('cat $HOME/password.txt | docker login -u adamandika --password-stdin')
                sh('docker push adamandika/client:${commit_id}')
                sh('docker push adamandika/server-js:${commit_id}')
            }
        }
            
        stage("Change Image Tag"){
            steps{
                script{
                    commit_id = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                    sh 'ls k8s/production/backend'
                    sh "sed -i 's/IMAGE_TAG/$commit_id/g' k8s-frontend-production/k8s-frontend-staging/frontend-deployment.yaml"
                    sh "sed -i 's/IMAGE_TAG/$commit_id/g' k8s-backhend-production/k8s-backhend-staging/backend-dpy.yaml"
                    sh "sed -i 's/IMAGE_TAG/$commit_id/g' k8s-frontend-staging/frontend-deployment.yaml"
                    sh "sed -i 's/IMAGE_TAG/$commit_id/g' k8s-backhend-staging/backend-dpy.yaml"
                }
               
            }
        }
        
        stage("Apply k8s Yaml Manifest To Cluster"){
            steps{
                sh("kubectl apply -f k8s-frontend-staging")
                sh("kubectl apply -f k8s-backhend-staging")
            }
            post{
                success {
                    sh("kubectl apply -f k8s-frontend-production")
                    sh("kubectl apply -f k8s-backhend-productions")
                }
                always{
                    emailext body: 'Please accept input if the staging environment runs smoothly.', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'deploy to  production?'
                    input(message: 'Proceed or abort?', ok: 'Deploy to production')
                    
                }
                
            }
        }
        

    }
}
