pipeline {
    agent none

    // tools {
    //     // Install the Maven version configured as "M3" and add it to the path.
    //     maven "mymaven"
    // }
    
    environment{
        BUILD_SERVER_IP='ec2-user@172.31.13.178'
        IMAGE_NAME='srinigg/adbookrepo'
        DEPLOY_SERVER_IP='ec2-user@172.31.32.122'
    }

    stages {
        // stage('Compile') {
        //     // agent {label "linux_slave"}
        //     agent any
        //     steps {              
        //       script{
        //              echo "COMPILING"
        //              sh "mvn compile"
        //       }             
        //     }
            
        // }
        // stage('Test') {
        //     agent any
        //     steps {           
        //       script{
        //            echo "RUNNING THE TC"
        //            sh "mvn test"
        //         }              
             
        //     }            
        
        // post{
        //     always{
        //         junit 'target/surefire-reports/*.xml'
        //     }
        // }
        // }
        stage('Containerise the app') {
            agent any
            steps {              

                script{
                     echo "Creating the docker image and Push to registry"
                sshagent(['sshslave']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-srini', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} 'bash server-script.sh ${IMAGE_NAME} ${BUILD_NUMBER}'"
                sh "ssh ${BUILD_SERVER_IP} sudo docker login -u ${username} -p ${password}"
                sh "ssh ${BUILD_SERVER_IP} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                }
                }             
                }
            }            
        }
         stage('Deploy the docker container on Test server') {
            agent any
            steps {            
                script{
                     echo "Deploy the container"
                sshagent(['sshslave']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo yum install docker -y"
                 sh "ssh  ${DEPLOY_SERVER_IP} sudo systemctl start docker"
                sh "ssh ${DEPLOY_SERVER_IP} sudo docker login -u ${username} -p ${password}"
                sh "ssh ${DEPLOY_SERVER_IP} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"
                }
                }             
                }
            }            
        }

    }
}
