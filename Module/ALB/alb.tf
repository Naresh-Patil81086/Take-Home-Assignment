


resource "aws_lb" "alb" {
  name               = var.alb-name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = "${var.albsg}"
  subnets            = var.alb-subnets

  


  tags = {
    Name = "var.alb-name"
  }
}

resource "aws_lb_target_group" "web-target-group" {
  name     = var.tg-name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc-id
}

resource "aws_alb_listener" "web-listner-80" {
  default_action {
    target_group_arn = aws_lb_target_group.web-target-group.arn
    type = "forward"
  }
  load_balancer_arn = aws_lb.alb.arn
  port = 80
}

##################

resource "aws_cloudwatch_metric_alarm" "alb_healthyhosts" {
  alarm_name          = "healthyhosts_check"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Thers is no healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.web_targate-update.arn]
  ok_actions          = [aws_sns_topic.web_targate-update.arn]
  dimensions = {
    #TargetGroup  = aws_lb_target_group.web-target-group.arn_suffix
    TargetGroup  = aws_lb_target_group.web-target-group.arn_suffix
   LoadBalancer = aws_lb.alb.arn_suffix
     }
}


resource "aws_sns_topic" "web_targate-update" {
  name = "web_targate-alarm-update"
  }

  resource "aws_sns_topic_subscription" "user_email" {
  topic_arn = aws_sns_topic.web_targate-update.arn
  protocol  = "email"
  endpoint  = var.endpoint
}