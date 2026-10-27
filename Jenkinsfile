pipeline {
    agent any

    stages {
        stage('Pull Code from GitHub') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DH_USER',
                    passwordVariable: 'DH_PASS'
                )]) {
                    sh '''
                        IMAGE_NAME="$DH_USER/cloud-lab1"
                        docker build -t "$IMAGE_NAME:$BUILD_NUMBER" .
                        docker tag "$IMAGE_NAME:$BUILD_NUMBER" "$IMAGE_NAME:latest"
                    '''
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DH_USER',
                    passwordVariable: 'DH_PASS'
                )]) {
                    sh '''
                        IMAGE_NAME="$DH_USER/cloud-lab1"
                        echo "$DH_PASS" | docker login -u "$DH_USER" --password-stdin
                        docker push "$IMAGE_NAME:$BUILD_NUMBER"
                        docker push "$IMAGE_NAME:latest"
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy Locally') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DH_USER',
                    passwordVariable: 'DH_PASS'
                )]) {
                    sh '''
                        IMAGE_NAME="$DH_USER/cloud-lab1"
                        docker rm -f cloud-lab1-app || true
                        docker run -d --name cloud-lab1-app -p 8085:80 "$IMAGE_NAME:latest"
                    '''
                }
            }
        }
    }
}
