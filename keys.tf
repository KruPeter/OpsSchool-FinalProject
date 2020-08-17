resource "tls_private_key" "VPC-project-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "VPC-project-key" {
  key_name   = "VPC-project-key"
  public_key = tls_private_key.VPC-project-key.public_key_openssh
}

resource "local_file" "VPC-project-key" {
  sensitive_content  = tls_private_key.VPC-project-key.private_key_pem
  filename           = "VPC-project-key.pem"
}