locals {
  monitoring_name = "monitoring"
}

resource "aws_instance" "monitoring" {
  ami                    = "ami-07d0cf3af28718ef8"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.0.id
  key_name               = aws_key_pair.VPC-project-key.key_name
  iam_instance_profile   = aws_iam_instance_profile.consul-join.name
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id, aws_security_group.project_consul.id]

  user_data = data.template_cloudinit_config.monitoring.rendered

  tags = {
    Name = "monitoring"
  }
}

data "template_file" "docker-monitoring" {
  template = file("${path.module}/templates/docker.sh.tpl")
}

data "template_file" "consul-monitoring" {
  template = file("${path.module}/templates/consul.sh.tpl")

  vars = {
    consul_version = var.consul_version
    config = <<EOF
       "node_name": "opsschool-monitoring",
       "enable_script_checks": true,
       "server": false
      EOF
  }
}

data "template_file" "monitoring" {
  template = file("${path.module}/templates/monitoring.sh.tpl")
    vars = {
    HOSTNAME = "grafana"
    consul_server = aws_instance.consul-server[0].private_ip
  }
}

# Create the user-data for monitoring
data "template_cloudinit_config" "monitoring" {
  part {
    content = data.template_file.docker-monitoring.rendered
  }
  part {
    content = data.template_file.consul-monitoring.rendered
  }  
  part {
    content = data.template_file.monitoring.rendered
  }
  part {
    content = file("${path.module}/templates/inst_node_exporter.sh.tpl")
  }
}

output "monitoring" {
  value = ["${aws_instance.monitoring.private_ip}"]
}