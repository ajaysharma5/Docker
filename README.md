# Docker


Dockerfile :
            to create custom nginx docker image
            
infra.tf : 
            terraform file to create VPC, public subnet, internet gateway, security group and ec2 instance with docker and git installed.
            
Infra.yml: 
            Ansible playbook to perform following tasks. 
                  1. Checkout the git repo main main branch on host.
                  2. Build docker image with docker file.
                  3. Run docker file to deploy nginx.
                  
Index.html : 
              Sample application.
         
nginx.conf: 
              nginx configaration file.


        
        
