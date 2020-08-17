# Create a new load balancer
resource "aws_elb" "monitoring-elb" {
  name               = "monitoring-elb"
  subnets            = [aws_subnet.public.1.id]
  security_groups    = [aws_security_group.monitoring_sg.id]

  listener {
    instance_port     = 9090
    instance_protocol = "tcp"
    lb_port           = 9090
    lb_protocol       = "tcp"
  }

    listener {
    instance_port     = 3000
    instance_protocol = "tcp"
    lb_port           = 3000
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9090"
    interval            = 30
  }

  instances                   = [aws_instance.monitoring.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "monitoring-elb"
  }
}

# Create a new load balancer
resource "aws_elb" "consul-elb" {
  name               = "consul-elb"
  subnets            = [aws_subnet.public.0.id]
  security_groups    = [aws_security_group.project_consul.id]

  listener {
    instance_port     = 8500
    instance_protocol = "tcp"
    lb_port           = 8500
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8500"
    interval            = 30
  }

  instances                   = [aws_instance.consul-server[0].id]
  cross_zone_load_balancing   = true
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "consul-elb"
  }
}

# # Create a new load balancer
# resource "aws_elb" "ELK-elb" {
#   name               = "ELK-elb"
#   subnets            = [aws_subnet.public.0.id]
#   security_groups    = [aws_security_group.elk_sg.id]

#   listener {
#     instance_port     = 5601
#     instance_protocol = "tcp"
#     lb_port           = 5601
#     lb_protocol       = "tcp"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "TCP:5601"
#     interval            = 30
#   }

#   instances                   = [aws_instance.ELK-server.id]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 100
#   connection_draining         = true
#   connection_draining_timeout = 300

#   tags = {
#     Name = "ELK-elb"
#   }
# }

# Create a new load balancer
# resource "aws_elb" "Jenkins-elb" {
#   name               = "Jenkins-elb"
#   subnets            = [aws_subnet.public.0.id]
#   security_groups    = [aws_security_group.jenkins-sg-1.id]

#   listener {
#     instance_port     = 8080
#     instance_protocol = "tcp"
#     lb_port           = 8080
#     lb_protocol       = "tcp"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "TCP:8080"
#     interval            = 30
#   }

#   instances                   = [aws_instance.jenkins_master.id]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 100
#   connection_draining         = true
#   connection_draining_timeout = 300

#   tags = {
#     Name = "Jenkins-elb"
#   }
# }