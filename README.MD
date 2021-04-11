# Take-Home-Assignment


Below are the resources that supported:
Terraform module which creates VPC,Security group,APPlication load balancer Auto scaling, Cloudwatch alert, SNS notification on AWS.

# Usage/example

# Example input are explain in main.tf file 

It must include a VPC which enables future growth / scale--------Completed

It must include both a public and private subnet – where the private subnet is used for compute and the public is used for the load balancers-------------Completed

Assuming that the end-users only contact the load balancers and the underlying instance are accessed for management purposes, design a security group scheme which supports the minimal set of ports required for communication.---Completed

The AWS generated load balancer hostname with be used for request to the public facing web application.
An autoscaling group should be created which utilizes the latest AWS AMI-------------Completed

The instance in the ASG Must contain both a root volume to store the application / services
Must contain a secondary volume meant to store any log data bound from / var/log---------------Completed

Must include a web server of your choice.-----------Completed Apache2

All requirements in this task of configuring the operating system should be defined in the launch configuration and/or the user data script (no external config tools like chef, puppet, etc)-------Completed using userdata script


Additional Areas to Focus On (Extra Credit):

You must ensure that all data is encrypted at rest ---------Completed
Ideally, you should design these web servers so they can be managed without logging in with the root key---Completed  User can use passwword authentication 

We should have some sort of alarm mechanism that indicates when the application is experiencing any issues.---Completed  HealthyHostCount check at cloudwatch

Configure the autoscaling group to automatically add and remove nodes based on load---Completed. Configured scale up policy base on cpuutilization

You should assume that this web server may receive high volumes of web traffic, thus you should appropriately manage the storage / growth of logs
