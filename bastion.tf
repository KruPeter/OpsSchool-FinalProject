# Allocate the bastion instance
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = aws_key_pair.VPC-project-key.key_name

  associate_public_ip_address = true

  tags = {
    Name  = "bastion-server"
  }
}

data "template_file" "ssh_config" {
  template = "${file("ssh_config.cfg")}"
 
  depends_on = [
    aws_instance.bastion
  ]
  vars = {
    bastion_server = aws_instance.bastion.public_ip
  }
}

resource "null_resource" "ssh_config" {
  triggers = {
    template_rendered = data.template_file.ssh_config.rendered
  }
  provisioner "local-exec" {
    command = "echo \"${data.template_file.ssh_config.rendered}\" > ssh_config"
  }
}