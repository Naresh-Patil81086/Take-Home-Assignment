provider "aws" {
  region = "us-east-1"
  #profile = "terra"

  access_key = "your_access_key"
  secret_key = "your_secret_key"


}



#ModuleVPC
module "myvpc" {
  source                     = "./Module/VPC"
  vpc-name                   = "mc-vpc"
  env                        = "dev"
  vpc-cidr                   = "10.11.0.0/16"
  instance_tenancy           = "default"
  enable_dns_support         = "true"
  enable_dns_hostnames       = "true"
  region                     = "us-east-1"
  map_public_ip_on_launch    = "true"
  vpc-public-subnet-cidr     = ["10.11.1.0/24", "10.11.2.0/24"] #Public subnet atleast for multi az loadbalancer
  vpc-private-subnet-cidr    = ["10.11.3.0/24"]                 #Private subnet atleast
  total-nat-gateway-required = "1"                              #Number of natgatway


}

########security_groups

module "mysg" {

  source = "./Module/sg"

  http-from-port     = 80 #ALB port to open publicly 
  http-protocol      = "tcp"
  http-to-port       = 80  #ALB port to open publicly 
  https-from-port    = 443 #ALB port to open publicly 
  https-protocol     = "tcp"
  https-to-port      = 443 #ALB port to open publicly 
  ssh-protocol       = "tcp"
  ssh-from-port      = "22"        #Web server port to open from internal network
  ssh-to-port        = "22"        #Web server port to open from internal network
  inbound_cidr       = "0.0.0.0/0" #cidr for inbound rule
  outbound-from-port = 0           # port open for outbond rule
  outbound-to-port   = 0
  outbound-protocol  = -1 # protocal for outbod rule
  region             = "us-east-1"
  outbond_cidr       = "0.0.0.0/0"             #cidr for outbond rule
  vpc-id             = module.myvpc.vpc-id     #vpc ID
  alb-sg-name        = "alb-external-sg"       #name for alb sg
  webserver-sg-name  = "webserver-internal-sg" #name for web server sg


}

## For the time being helthyhostcount cloudwatch alert and sns for alb targate group taken care at below alb module

module "myalb" {

  source             = "./Module/ALB"
  alb-name           = "assignment-alb-public"        #Name for Application Load balancer 
  internal           = "false"                        #Boolean determining if the load balancer is internal or externally facing. 
  load_balancer_type = "application"                  #type of load balancer
  albsg              = module.mysg.sg-alb             #scurity group for alb
  alb-subnets        = module.myvpc.public-subnet-ids #subnet for alb
  region             = "us-east-1"                    #aws region
  tg-name            = "webserver"                    #targate group name
  port               = "80"                           #targate group port
  protocol           = "HTTP"                         #targate group protocol
  vpc-id             = module.myvpc.vpc-id            #vpc id retrive from myvpc module
  endpoint           = "niru81086@gmail.com"          #Email ID to get alert notification, first time you need subscribed 


}


## For the time being latest AMI filter, ec2_key_pair are taken care at below asg module


module "myasg" {
  source = "./Module/asg"
  #################input for launch-configuration and userdata
  key-name                  = "webserver-key"     #Name for the ec2 key pair
  Public_key                = "webserver-key.pub" #Publick key to create ec2_key pair
  region                    = "us-east-1"
  launch-configuration-name = "web"                           #launch-configuration-name
  userdata                  = "installapache.sh"              #userdata script path
  instance-type             = "t2.micro"                      #Instance type 
  username                  = "nareshp"                       #username to login web server 
  userpassword              = "Niru@123"                      #password to login web server
  subnet_ids                = module.myvpc.private-subnet-ids #Subnet IDs
  web-server-sg             = module.mysg.sg-web              #Webserver security group
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 10
      encrypted   = true
      # kms_key_id  = aws_kms_key.ebs_encry.arn
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp2"
      volume_size = 5
      encrypted   = true
      #kms_key_id  = "aws_kms_key.ebs_encry.arn"
    }
  ]

  ###########Input for auto scaling
  autoscaling-group-name = "webserver-asg" #autoscaling-group-name
  desired-capacity       = 1
  min-size               = 1
  max-size               = 1
  force-delete           = "true"
  health-check-type      = "ELB"                              #Enabled load balancer helth check
  target-group-arns      = module.myalb.alb-web1-target-group #Tragate group arn
  tag-key                = "Name"                             #tag
  tag-value              = "Web1"                             #tag


}



output "hostname_alb" {
  value = module.myalb.alb_hostname
}







