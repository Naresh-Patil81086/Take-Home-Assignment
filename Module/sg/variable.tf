

variable "http-to-port" {

    default = ""
}

variable "http-from-port" {

    default = ""
}

variable "http-protocol" {

    default = ""
}

variable "https-to-port" {

    default = ""
}

variable "https-from-port" {

    default = ""
}

variable "https-protocol" {

    default = ""
}

#########################
variable "ssh-protocol" {
    default = ""
  
}

variable "ssh-from-port" {
    default = ""
  
}
variable "ssh-to-port" {
    default = ""
  
}
 


#######
variable "outbound-from-port" {

    default = ""
}

variable "outbound-protocol" {

    default = ""
}

variable "outbound-to-port" {

    default = ""
}


variable "region" {
    default = ""
}

variable "inbound_cidr" {
    default = ""
}

variable "outbond_cidr" {
    default = ""
}

variable "vpc-id" {

    default = ""
}

variable "alb-sg-name" {
    default = ""
}

   
variable "albsg" {

    default = ""
}

variable "tg-name" {
    default = ""
  
}

variable "webserver-sg-name" {
    default = ""
  
}