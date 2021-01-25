  
Opsschool 2020 Final Project overview,

The goal of the project is to create a HA infrastructure on AWS Cloud (NOT for Prod USE!!!) to support deployment of a simple Flask application in an automated fashion using CI/CD.

Prerequisites:

    AWS account
    GitHub account
    DockerHub account
    Terraform 0.12+
    Ansible 2.9+
    Git
    kubectl

Result:
    
    High Available VPC.
    EC2 Bastion host in public subnet for ssh access to instances in private subnets.
    EKS Cluster with two EC2 workers in different private subnets.
    ELK Stack instance in one of the two private subnets.
    Two EC2 instances for Jenkins. One instance is for master and one for node.
    One EC2 instance for MySQL in one of the two private subnets.
    One EC2 instance for Monitoring. Grafana and Prometheus
    Three EC2 instances for Consul Servers
    
Infrastructure:

    Git clone this Repo
     - Terraform init
     - Terraform plan
     - Terraform apply -auto-approve
     
Jenkins Deployment and Configuration:

    Git clone this Repo
    Access Jenkins Master's {publis_ip}:8080 in browser
    Add below plugins:
    jenkins plugins:
      1. pipeline-build-step:latest
      2. ssh-slaves:1.31.2
      3. build-monitor-plugin:latest
      4. slack:2.40
      5. pipeline-aws:latest
      6. github:latest
    Create credentials for adding new nodes as "ubuntu" (use the same EC2 pem), github, dockerhub.
    Configure jenkins nodes and set credential name as "ubuntu".

To get logon to different EC2's instances in privet subnets:

    ssh to the EC2 instance using key.pem (ssh -i "key.pem" -F ssh_config ubuntu@<IP>)

To bring everything down:

    cd into the terraform/..../VPC dir and run:
    terraform destroy
    
    
