pipeline {
    agent any

    parameters {
        choice(name: 'Environment', choices: ['Dev', 'Prod'], description: 'Select the deployment environment')
    }

    environment {
        DEV_PORT = '8088'
        PROD_PORT = '8087'
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    // Clone the repository and checkout the correct branch based on the parameter
                    sh "git clone https://github.com/Suryavanshi7/spring-boot-hello-world.git app"
                    dir('app') {
                        sh "git checkout ${params.Environment}"
                    }
                }
            }
        }
        
        stage('Build artifact') {
            steps {
                script {
                    dir('app') {
                        sh "mvn clean package -DskipTests"
                    }
                }
            }
        }
        
        // stage('Push to Artifactory') {
        //     steps {
        //         script {
        //             // Push artifact to Artifactory
        //             dir('app') {
        //                   sh 'curl -u Surya:Password7 -T target/*.jar "http://localhost:8081/artifactory/Jenkins/"'
        //             }
        //         }
        //     }
        // }
        
        stage('Push to Artifactory') {
            steps {
                script {
                    dir('app') {
                        withCredentials([usernamePassword(credentialsId: 'Jfrog', usernameVariable: 'ARTIFACTORY_USER', passwordVariable: 'ARTIFACTORY_PASSWORD')]) {
                            sh 'curl -u $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD -T target/*.jar "http://localhost:8081/artifactory/Jenkins/"'
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir('app') {
                        sh "docker build -t testapp:${params.Environment} ."
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    def port = params.Environment == 'Dev' ? env.DEV_PORT : env.PROD_PORT

                    def containerRunning = sh(script: "docker ps -q -f name=testapp_${params.Environment}", returnStdout: true).trim()
                    if (containerRunning) {
                        sh "docker stop testapp_${params.Environment} && docker rm testapp_${params.Environment}"
                    }

                    sh "docker run -d --name testapp_${params.Environment} -p ${port}:${port} testapp:${params.Environment}"
                }
            }
        }
    }

}