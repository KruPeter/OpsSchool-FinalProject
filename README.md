  
Opsschool 2020 Final Project overview,

The goal of the project is to create a HA infrastructure on AWS Cloud,  build docker image from code in GitHub repo, push the image to DockerHub and deploy it to kubernetes cluster.

Prerequisites

    AWS account
    GitHub account
    DockerHub account
    Terraform 0.12+
    Ansible 2.9+
    Git
    Awscli
    kubectl

Result:

    1 new VPC, 4 subnets (2 private, 2 public), 1 IG, 2 security groups (1 private, 1 public). All in 2 availability zones.
    1 jenkins master + 1 jenkins node
    K8s Cluster
    3 Consul servers
    1 mySQL server
    1 monitoring server for Grafana and Prometeus
    1 ELK server for Elastic and Kibana



