pipeline {
    agent any
          
    stages {
        stage ('Terraform Init') {
            steps {
                script {
                    sh 'sudo -i terraform init'
                }    
            
            }
        }

        stage ('Terraform Plan -out plan.tf') {
            steps {
                script {
                    sh 'sudo -i terraform plan'
                }
            }
        }

        stage('Terraform apply') {
            steps {
                script {
                    sh 'sudo -i terraform apply -y' 
                }    
            }
        }
    }   
}  
