#LoadBalancer ELB-Web
resource "aws_lb" "ELB-Web" {
  name               = "web-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sg.id]
  subnets            = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id]
}

resource "aws_lb_target_group" "target-elb-web" {
  name     = "web-ALB-TG"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}

resource "aws_lb_target_group_attachment" "attachment-elb-web" {
  target_id = aws_autoscaling_group.auto-scaling-web.id
  # autoscaling_group_name = aws_autoscaling_group.auto-scaling-web.name
  target_group_arn = aws_lb_target_group.target-elb-web.arn
}

resource "aws_lb_listener" "external-elb-web" {
  load_balancer_arn = aws_lb.ELB-Web.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = aws_acm_certificate.certificat.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-elb-web.arn
  }
}

#LoadBalancer ELB-App
resource "aws_lb" "ELB-app" {
  name               = "app-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app-sg.id]
  subnets            = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
}

resource "aws_lb_target_group" "target-elb-app" {
  name     = "app-ALB-TG"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}

resource "aws_lb_target_group_attachment" "attachment-elb-app" {
  target_id = aws_autoscaling_group.auto-scaling-app.id
  #autoscaling_group_name = aws_autoscaling_group.auto-scaling-app.name
  target_group_arn = aws_lb_target_group.target-elb-app.arn
}

resource "aws_lb_listener" "external-elb-app" {
  load_balancer_arn = aws_lb.ELB-app.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-elb-app.arn
  }
}

