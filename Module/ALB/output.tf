output "aws-alb" {
  value = aws_lb.alb.id
}

#OUTPUTS

output "alb-web1-target-group" {
  value = aws_lb_target_group.web-target-group.*.id
}

output "alb_hostname" {
  value = aws_lb.alb.dns_name
  
}

output "target-group-arn" {
  value = "${aws_lb_target_group.web-target-group.arn}"
}