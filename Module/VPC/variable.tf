
  
#VPC
variable "instance-tenancy" {
  default = ""
}
variable "enable-dns-support" {
  default = ""
}

variable "enable-dns-hostnames" {
  default = ""
}

variable "vpc-name" {
  default = ""
}

variable "vpc-cidr" {
default =""

}

############################
#VPC Region
variable "region" {
  default = ""
}

variable "env"{
  default = ""
}

variable "instance_tenancy" {
  default = "default"
}

variable "enable_dns_hostnames" {
  default = "true"
}

variable "enable_dns_support" {
  default = "true"
}



############
variable "vpc-public-subnet-cidr" {
default = ""
}

variable "map_public_ip_on_launch" {
  default = "true"
}


variable "vpc-private-subnet-cidr" {
  default = ""
}

variable "total-nat-gateway-required" {
  default = ""
}


