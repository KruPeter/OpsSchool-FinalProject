resource "aws_security_group" "vpc-project-default" {
  name        = "project-default"
  description = "default VPC project security group"
  vpc_id      = aws_vpc.VPC_Project.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-project-default"
  }
}

resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg-1"
  description = "Allow Jenkins inbound traffic"
  vpc_id      = aws_vpc.VPC_Project.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}


resource "aws_security_group" "project_consul" {
  name        = "project-consul"
  description = "Allow ssh & consul inbound traffic"
  vpc_id      = aws_vpc.VPC_Project.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all inside security group"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh from the world"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow http from the world"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow http from the world"
  }

    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow https from the world"
  }

  ingress {
    from_port   = 8500  
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }  

    ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }  

   ingress {
    from_port   = 8500  
    to_port     = 8500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }  

    ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }  

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }  

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }  
    ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }  

  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }  
   ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  }  

  ingress {
    from_port   = 8400
    to_port     = 8400
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access from the world"
  } 

  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul DNS access from the world"
  }  

  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul DNS access from the world"
  }  
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow node exporter access from the world"
  } 

  ingress {
    from_port   = 9107
    to_port     = 9107
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul exporter access from the world"
  } 

  ingress {
    from_port   = 9107
    to_port     = 9107
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul exporter access from the world"
  }  

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow elasticsearch from the world"
  }

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow kibana from the world"
  }
  
   ingress {
   from_port   = 8
   to_port     = 0
   protocol    = "icmp"
   cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Allow all outside security group"
  }
}


resource "aws_security_group" "monitoring_sg" {
  name        = "monitoring-sg"
  description = "Security group for monitoring server"
  vpc_id      = aws_vpc.VPC_Project.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP from control host IP
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all SSH External
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic to HTTP port 3000
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic to HTTP port 9090
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all traffic to HTTP port 9100
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9104
    to_port     = 9107
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
    Name = "monitoring_sg"
  }
}


resource "aws_security_group" "elk_sg" {
  name        = "elk_sg"
  description = "Allow logging inbound traffic"
  vpc_id      = aws_vpc.VPC_Project.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # elasticsearch port
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # logstash port
  ingress {
    from_port   = 5044
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # kibana ports
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Allow all outside security group"
  } 
  
 tags = {
    Name = "elk_sg"
  }

}


resource "aws_security_group" "mysql-sg" {
  name        = "mysql-sg"
  description = "Allow ssh & mysql inbound traffic"
  vpc_id      = aws_vpc.VPC_Project.id

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
  }

  tags = {
    Name = "mysql-sg"
  }
}


resource "aws_security_group" "bastion_sg" {
  name   = "bastion_sg"
  vpc_id = aws_vpc.VPC_Project.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
    Name = "bastion_sg"
  }
}

# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "project-consul-join"
  assume_role_policy = file("${path.module}/templates/policies/assume-role.json")
}

# Create an IAM policy
resource "aws_iam_policy" "consul-join" {
  name        = "project-consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = file("${path.module}/templates/policies/describe-instances.json")
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "project-consul-join"
  roles      = ["${aws_iam_role.consul-join.name}"]
  policy_arn = aws_iam_policy.consul-join.arn
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name = "project-consul-join"
  role = aws_iam_role.consul-join.name
}