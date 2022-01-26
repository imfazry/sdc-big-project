pipeline {
    agent any 
 
    stages {
           
           stage("Clone Repo"){
            steps{
                    git(url: 'https://github.com/imfazry/sdc-big-project.git', branch: 'main')
            }
        }
        
        stage('Build Image'){
            steps{
                script{
                        commit_id = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                        sh "docker build -t imfazry/todo-app_client:$commit_id  ."
                        sh "docker build -t imfazry/todo-app_server:$commit_id  backend"
                       
                    }
            }
        }
         stage("Push Image"){
            steps{
                script{
                commit_id = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                sh "cat $HOME/creds.txt | docker login -u imfazry --password-stdin"
                sh "docker push imfazry/todo-app_client:$commit_id"
                sh "docker push imfazry/todo-app_server:$commit_id"
                }
            }
        }
        
        stage("Clean Local Image"){
            steps{
                sh("docker image prune -a --force")
            }
        }
        
        stage("Change Image Tag"){
            steps{
                script{
                    commit_id = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
                    sh 'ls k8s/production/backend'
                    sh "sed -i 's/IMAGE_TAG/$commit_id/g' k8s/production/frontend/frontend-dpy.yaml"
                    sh "sed -i 's/IMAGE_TAG/$commit_id/g' k8s/production/backend/backend-dpy.yaml"
                    sh "sed -i 's/IMAGE_TAG/$commit_id/g' k8s/staging/frontend/frontend-dpy.yaml"
                    sh "sed -i 's/IMAGE_TAG/$commit_id/g' k8s/staging/backend/backend-dpy.yaml"
                }
               
            }
        }
        
        stage("Apply k8s Yaml Manifest To Cluster"){
            steps{
                sh("kubectl apply -f k8s/staging/frontend")
                sh("kubectl apply -f k8s/staging/backend")
            }
            post{
                success {
                    sh("kubectl apply -f k8s/production/frontend")
                    sh("kubectl apply -f k8s/production/backend")
                }
                always{
                    emailext body: 'Please accept input if the staging environment runs smoothly.', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'deploy to  production?'
                    input(message: 'Proceed or abort?', ok: 'Deploy to production')
                    
                }
                
            }
        }
        

    }
}