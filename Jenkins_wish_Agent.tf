locals {
  jenkins_default_name = "jenkins"
  jenkins_home       = "/home/ubuntu/jenkins_home"
  jenkins_home_mount = "${local.jenkins_home}:/var/jenkins_home"
  docker_sock_mount  = "/var/run/docker.sock:/var/run/docker.sock"
  java_opts          = "JAVA_OPTS='-Djenkins.install.runSetupWizard=false'"
}

resource "aws_instance" "jenkins_master" {
  ami                    = "ami-07d0cf3af28718ef8"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public.0.id}"
  key_name               = aws_key_pair.VPC-project-key.key_name
  iam_instance_profile   = aws_iam_instance_profile.consul-join.name
  vpc_security_group_ids = [aws_security_group.jenkins-sg-1.id, aws_security_group.project_consul.id]
  user_data              = data.template_cloudinit_config.consul_jenkins_master.rendered
#   associate_public_ip_address = true

  tags = {
    Name = "Jenkins Master 1"
  }

  connection {
    host        = aws_instance.jenkins_master.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.VPC-project-key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt install docker.io -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu",
      "mkdir -p ${local.jenkins_home}",
      "sudo chown -R 1000:1000 ${local.jenkins_home}",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "sudo docker run --restart always -d -p 8080:8080 -p 50000:50000 -v ${local.jenkins_home_mount} -v ${local.docker_sock_mount} --env ${local.java_opts} jenkins/jenkins"
    ]
  }
}

resource "aws_instance" "jenkins_agent" {
  depends_on             = ["aws_instance.jenkins_master"]
  ami                    = "ami-00068cd7555f543d5"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public.0.id}"
  key_name               = aws_key_pair.VPC-project-key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins-sg-1.id, aws_security_group.project_consul.id]
  user_data              = data.template_cloudinit_config.consul_jenkins_node.rendered
  iam_instance_profile   = aws_iam_instance_profile.eks-kubectl.name
#   associate_public_ip_address = true

  tags = {
    Name = "Jenkins Agent 1"
  }

  connection {
    host        = aws_instance.jenkins_agent.public_ip
    user        = "ec2-user"
    private_key = tls_private_key.VPC-project-key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install java-1.8.0 -y",
      "sudo alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java",
      "sudo yum install docker git -y",
      "sudo service docker start",
      "sudo usermod -aG docker ec2-user",
      # "mkdir -p ${local.jenkins_home}",
      # "sudo chown -R 1000:1000 ${local.jenkins_home}",
      # "cat /home/ec2-user/master_key.pub >> /home/ec2-user/.ssh/authorized_keys",
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "sudo mv ./kubectl /usr/local/bin/kubectl"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run --restart always -d -p 8080:8080 -p 50000:50000 -v ${local.jenkins_home_mount} -v ${local.docker_sock_mount} --env ${local.java_opts} jenkins/jenkins"
    ]
  }
}

data "template_file" "consul_jenkins_master" {
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
      consul_version = var.consul_version
      config = <<EOF
       "node_name": "opsschool-jenkins-master",
       "enable_script_checks": true,
       "client_addr": "0.0.0.0",
       "bind_addr": "0.0.0.0",
       "server": false
      EOF
  }
}

# Create the user-data for the Consul agent
data "template_cloudinit_config" "consul_jenkins_master" {
  part {
    content = data.template_file.consul_jenkins_master.rendered
  }
  part {
    content = file("${path.module}/templates/inst_node_exporter.sh.tpl")
  }
  part {
    content = file("${path.module}/templates/jenkins_master.sh.tpl")
  }
}

data "template_file" "consul_jenkins_node" {
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
      consul_version = var.consul_version
      config = <<EOF
       "node_name": "opsschool-jenkins-node",
       "enable_script_checks": true,
       "client_addr": "0.0.0.0",
       "bind_addr": "0.0.0.0",
       "server": false
      EOF
  }
}

# Create the user-data for the Consul agent
data "template_cloudinit_config" "consul_jenkins_node" {
  part {
    content = file("${path.module}/templates/install_python.sh.tpl")
  }
  
  part {
    content = file("${path.module}/templates/inst_node_exporter.sh.tpl")
  }
  
  part {
    content = data.template_file.consul_jenkins_node.rendered

  }
  part {
    content = file("${path.module}/templates/jenkins_node.sh.tpl")
  }
}
