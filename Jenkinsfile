  pipeline {
    agent any
  
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
                    sh 'terraform plan -out plan.tf'
                }
            }
        }

        stage ('Terraform apply') {
            steps {
                script {
                    sh 'terraform apply plan.tf' 
                }    
            }
        } 
    }    
}
