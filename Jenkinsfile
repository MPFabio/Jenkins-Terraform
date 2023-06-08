  pipeline {
    agent any
    
    stages {
        stage ('AZ Login') {
            steps {
                script {
                    sh 'az login --tenant 7349d3b2-951f-41be-877e-d8ccd9f3e73c'
                }    
            
            }
        }
  
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

        stage ('Terraform apply') {
            steps {
                script {
                    sh 'terraform apply -y' 
                }    
            }
        } 
    }    
}
