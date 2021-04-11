output "sg-alb" {
  value = aws_security_group.alb-sg.*.id
}

output "sg-web" {
  value = aws_security_group.webserver-sg.*.id
}