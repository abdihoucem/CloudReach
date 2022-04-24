#LoadBalancer ELB-Web
resource "aws_lb" "ELB-Web" {
  name               = "web-LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sg.id]
  subnets            = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id]
  #cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "target-elb-web" {
  name     = "WEBTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}
/*resource "aws_lb_target_group_attachment" "attachment-target-elb-web" {
  target_group_arn = aws_lb_target_group.target-elb-web.arn
  target_id        = aws_autoscaling_group.auto-scaling-web.id
  port             = 80
}*/
resource "aws_lb_listener" "ELB-Web" {
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
  #cross_zone_load_balancing = true
}



resource "aws_lb_target_group" "target-elb-app" {
  name     = "APPTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my-vpc.id
}
/*resource "aws_lb_target_group_attachment" "attachment-target-elb-app" {
  target_group_arn = aws_lb_target_group.target-elb-app.arn
  target_id        = aws_autoscaling_group.auto-scaling-app.id
  port             = 80
}*/

resource "aws_lb_listener" "ELB-app" {
  load_balancer_arn = aws_lb.ELB-app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-elb-app.arn
  }
}


