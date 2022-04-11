pipeline {
    agent any
    
    tools {
        terraform 'terraform'
    }
    
    stages {
        stage('Git checkout'){
            steps{
              git branch: 'main', url: 'https://github.com/htmldav/terraform.git'
            }
        }

        stage('Terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('Terraform apply'){
            steps{
                sh 'terraform apply --auto-approve'
                script {
                    dd_ip1 = sh(
                        returnStdout: true, 
                        script: "terraform output external_ip_address_vm_1"
                    ).trim()
                    dd_ip2 = sh(
                        returnStdout: true, 
                        script: "terraform output external_ip_address_vm_2"
                    ).trim()     
                }
            }
        }
        
        stage('ansiblebook checkout'){
            steps{
              git branch: 'main', url: 'https://github.com/htmldav/ansiblebookTest.git'
            }
        }

        stage('ansible') { 
            steps { 
                withCredentials([sshUserPrivateKey(credentialsId: 'privateUbuntu', keyFileVariable: 'PRIVATE', usernameVariable: 'ubuntu')]) {
                    sh "ansible-playbook -u ubuntu -i ${dd_ip1}, playbook1.yml --private-key $PRIVATE"
                    sh "ansible-playbook -u ubuntu -i ${dd_ip2}, playbook2.yml --private-key $PRIVATE"
                }
            }
        }

        stage('Terraform state list'){
            steps{
                sh 'terraform state list'
            }
        }

        stage('Terraform state rm'){
            steps{
                sh 'terraform state rm yandex_compute_instance.vm[0]'
            }
        }

        stage('Terraform new state list'){
            steps{
                sh 'terraform state list'
            }
        }                        
    }
}