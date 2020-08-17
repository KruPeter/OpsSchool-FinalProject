# Setup the region in which to work.
provider "aws" {
    region = var.aws_region
}

# Create a VPC to run our system in

resource "aws_vpc" "VPC_Project" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
	Name = "Terraform_VPC"
  }
}

# Take the list of availability zones
data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_internet_gateway" "IG_main" {
  vpc_id = "${aws_vpc.VPC_Project.id}"

  tags = {
    Name = "tf-cluster-1-main-gw"
  }
}

# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "project-consul-join"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}

# Create an IAM policy
resource "aws_iam_policy" "consul-join" {
  name        = "project-consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = "${file("${path.module}/templates/policies/describe-instances.json")}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "project-consul-join"
  roles      = ["${aws_iam_role.consul-join.name}"]
  policy_arn = "${aws_iam_policy.consul-join.arn}"
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name  = "project-consul-join"
  role = "${aws_iam_role.consul-join.name}"
}


# Create an IAM role for eks kubectl
resource "aws_iam_role" "eks-kubectl" {
  name               = "opsschool-eks-kubectl"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}

# Create the policy
resource "aws_iam_policy" "eks-kubectl" {
  name        = "opsschool-eks-kubectl"
  description = "Allows unubtu node to run kubectl."
  policy      = "${file("${path.module}/templates/policies/describe-eks.json")}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "eks-kubectl" {
  name       = "opsschool-eks-kubectl"
  roles      = ["${aws_iam_role.eks-kubectl.name}"]
  policy_arn = "${aws_iam_policy.eks-kubectl.arn}"
}

# Create the instance profile
resource "aws_iam_instance_profile" "eks-kubectl" {
  name = "opsschool-eks-kubectl"
  role = "${aws_iam_role.eks-kubectl.name}"
}