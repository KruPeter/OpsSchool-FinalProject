  
Opsschool 2020 Final Project overview,

The goal of the project is to create a HA infrastructure on AWS Cloud (NOT for Prod USE!!!) to support deployment of a simple Flask application in an automated fashion using CI/CD.

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
    1 Jenkins master + 1 Jenkins slave
    K8s Cluster - EKS
    3 Consul servers
    1 mySQL server
    1 monitoring server - Grafana and Prometeus
    1 ELK server - Elastic and Kibana



