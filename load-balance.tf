#LoadBalancer ELB-Web
resource "aws_lb" "ELB-Web" {
  name               = "web-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sg.id]
  subnets            = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id]
  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}


#LoadBalancer ELB-App
resource "aws_lb" "ELB-app" {
  name               = "app-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app-sg.id]
  subnets            = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
  cross_zone_load_balancing   = true
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}


