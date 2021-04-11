
resource "aws_security_group" "alb-sg" {
  name = var.alb-sg-name
  vpc_id = var.vpc-id

  tags = {
    Name = var.alb-sg-name
  }

  ingress {
    from_port = var.http-from-port
    protocol = var.http-protocol
    to_port = var.http-to-port
    cidr_blocks = [var.inbound_cidr]
  }
  ingress {
    from_port = var.https-from-port
    protocol = var.https-protocol
    to_port = var.https-to-port
    cidr_blocks = [var.inbound_cidr]
  }
  

 egress {
    from_port = var.outbound-from-port
    protocol = var.outbound-protocol
    to_port =var.outbound-to-port
    cidr_blocks = [var.outbond_cidr]
  }

}

###############

resource "aws_security_group" "webserver-sg" {
  name = var.webserver-sg-name
  vpc_id = var.vpc-id

  tags = {
    Name = var.webserver-sg-name
  }

  ingress {
    from_port = var.http-from-port
    protocol = var.http-protocol
    to_port = var.http-to-port
    security_groups = [aws_security_group.alb-sg.id]
  }
  ingress {
    from_port = var.ssh-from-port
    protocol = var.ssh-protocol
    to_port = var.ssh-to-port
    security_groups = [aws_security_group.alb-sg.id]
  }
  

 egress {
    from_port = var.outbound-from-port
    protocol = var.outbound-protocol
    to_port =var.outbound-to-port
    cidr_blocks = [var.outbond_cidr]
  }

}

