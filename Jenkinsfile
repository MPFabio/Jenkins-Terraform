pipeline {
    agent any
          
    stages {
        stage ('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }    
            
            }
        }

        stage ('Terraform Plan -out plan.tf') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform apply') {
            steps {
                script {
                    sh 'terraform apply -y' 
                }    
            }
        }
    }   
}  
