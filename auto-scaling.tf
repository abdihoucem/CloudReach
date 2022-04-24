resource "aws_launch_configuration" "configure" {
  name_prefix     = "auto-scaling-"
  image_id        = var.ami_id
  instance_type   = var.instance_type
  user_data       = file("cloudreachtest.sh")
  security_groups = [aws_security_group.web-sg.id]

  lifecycle {
    create_before_destroy = true
  }
}
#Auto-scaling de public subnet
resource "aws_autoscaling_group" "auto-scaling-web" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.target-elb-web.arn]
  launch_configuration = aws_launch_configuration.configure.name
  vpc_zone_identifier  = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id]
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_down_public" {
  name                   = "cloudreach_scale_down"
  autoscaling_group_name = aws_autoscaling_group.auto-scaling-web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down_public" {
  alarm_description   = "Monitors CPU utilization for cloud reach ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_down_public.arn]
  alarm_name          = "cloudreach_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.auto-scaling-web.name
  }
}

#Auto-scaling de private subnet
resource "aws_autoscaling_group" "auto-scaling-app" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  health_check_type    = "ELB"
  target_group_arns    = [aws_lb_target_group.target-elb-app.arn]
  launch_configuration = aws_launch_configuration.configure.name
  vpc_zone_identifier  = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_down_private" {
  name                   = "cloudreach_scale_down"
  autoscaling_group_name = aws_autoscaling_group.auto-scaling-app.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down_private" {
  alarm_description   = "Monitors CPU utilization for cloud reach ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_down_private.arn]
  alarm_name          = "cloudreach_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "10"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.auto-scaling-web.name
  }
}



