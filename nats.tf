#Create elastic IP
resource "aws_eip" "nat" {
  vpc        = true

  lifecycle {
    create_before_destroy = true
  }
}

# Create NAT gateways
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.0.id
  
    depends_on = [aws_internet_gateway.IG_main, aws_subnet.public]

  tags = {
    Name    = "NAT-gateway"
    Service = "nat"
  }

  lifecycle {
    create_before_destroy = true
  }
}