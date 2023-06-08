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
    
        stage ('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out abcd.tf'
                }
            }
        }

        stage ('Terraform apply') {
            steps {
                script {
                    sh 'terraform apply abcd.tf' 
                }    
            }
        } 
    }    
}
