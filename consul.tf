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

# Create an aws private instance with ubuntu and consul on it
resource "aws_instance" "consul-server" {
  count                       = 3
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = element(aws_subnet.private.*.id, count.index)
  key_name                    = aws_key_pair.VPC-project-key.key_name
  iam_instance_profile        = aws_iam_instance_profile.consul-join.name
  vpc_security_group_ids      = ["${aws_security_group.project_consul.id}"]
  depends_on                  = [aws_nat_gateway.gw]

  user_data = "element(data.template_cloudinit_config.consul_server.*.rendered, count.index)"

  tags = {
    Name = "project-consul-server-${count.index+1}"
    consul_server = "true"
  }
}

# Create the user-data for the Consul server
data "template_file" "consul_server" {
  count    = var.servers
  template = file("${path.module}/templates/consul-server.sh.tpl")

  vars = {
    consul_version = var.consul_version
    node_exporter_version = var.node_exporter_version
    config = <<EOF
     "node_name": "opsschool-project-server-${count.index+1}",
     "server": true,
     "bootstrap_expect": ${var.servers},
     "ui": true,
     "client_addr": "0.0.0.0"
    EOF
  }
}

data "template_cloudinit_config" "consul_server" {
  count    = var.clients
  part {
    content = element(data.template_file.consul_server.*.rendered, count.index)
  }
    part {
    content = file("${path.module}/templates/inst_node_exporter.sh.tpl")
  }
}

output "servers" {
  value = ["${aws_instance.consul-server.*.private_ip}"]
}