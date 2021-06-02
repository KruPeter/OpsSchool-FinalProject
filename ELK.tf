# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

resource "aws_instance" "ELK-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "m4.large"
  subnet_id              = aws_subnet.private.1.id
  vpc_security_group_ids = [aws_security_group.elk_sg.id, aws_security_group.project_consul.id]
  key_name               = aws_key_pair.VPC-project-key.key_name
  iam_instance_profile   = aws_iam_instance_profile.consul-join.name

  user_data = data.template_cloudinit_config.consul_ELK.rendered

  tags = {
    Name = "ELK Server"
  }
}

# data "template_file" "docker_ELK" {
#   template = file("${path.module}/templates/docker.sh.tpl")
# }

data "template_file" "consul_ELK" {
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
      consul_version = var.consul_version
      config = <<EOF
       "node_name": "opsschool-elk-server",
       "enable_script_checks": true,
       "server": false
      EOF
  }
}

# Create the user-data for the Consul agent
data "template_cloudinit_config" "consul_ELK" {

  part {
    content = file("${path.module}/templates/inst_node_exporter.sh.tpl")
  }
  part {
    content = file("${path.module}/templates/install_python.sh.tpl")
  }
  part {
    content = data.template_file.consul_ELK.rendered
  }
  #   part {
  #   content = data.template_file.docker_ELK.rendered
  # }
  part {
    content = file("${path.module}/templates/elasticsearch.sh.tpl")
  }
}

output "logging" {
  value = ["${aws_instance.ELK-server.private_ip}"]
}