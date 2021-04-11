

#CREATING A NEW KEY PAIR AND EXPORTING OUR PUBLIC-KEY
resource "aws_key_pair" "key-pair" {
  key_name = var.key-name
  public_key = file(var.Public_key)
}

#Find latest AWS AMI

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "template_file" "init" {
    template = file(var.userdata)

    vars = {

        username = var.username
        password = var.userpassword

    }

     
}



resource "aws_launch_configuration" "launch-configuration" {
  name = var.launch-configuration-name
  image_id = data.aws_ami.latest-ubuntu.id
  instance_type = var.instance-type
  security_groups = var.web-server-sg
  user_data = data.template_file.init.rendered
  key_name = var.key-name

dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
     encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

    dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
     encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      #kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  

  }




###########

resource "aws_autoscaling_group" "autoscaling-group" {
  name = var.autoscaling-group-name
  launch_configuration = aws_launch_configuration.launch-configuration.name
  max_size = var.max-size
  min_size = var.min-size
  health_check_grace_period = var.health-check-grace-period
  #Group-Size or desired capacity
  desired_capacity = var.desired-capacity
  force_delete = var.force-delete
  #A list of subnet IDs to launch resources in
  vpc_zone_identifier = var.subnet_ids
  health_check_type = var.health-check-type
  target_group_arns = var.target-group-arns

  tag {
    key = "var.tag-key"
    propagate_at_launch = true
    value = "var.tag-value"
  }
}

##########################
 #Auto-Scaling Policy-Scale-up
resource "aws_autoscaling_policy" "auto-scaling-policy-scale-up" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling-group.name
  name = "cpu-policy-scale-up"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = "300"
  policy_type = "SimpleScaling"
}

###################
 #Auto-Scaling Policy Cloud-Watch Alarm-Scale-Up

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scale-up" {
  alarm_name = "cpu-alarm-scale-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 120
  statistic = "Average"
  threshold = 70
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling-group.name
  }
    actions_enabled = true
    alarm_actions = [aws_autoscaling_policy.auto-scaling-policy-scale-up.arn]

}

################

#Policy Scale down

resource "aws_autoscaling_policy" "auto-scaling-policy-scale-down" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling-group.name
  name = "cpu-policy-scale-down"
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = -1
  cooldown = "300"
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scale-down" {
  alarm_name = "cpu-alarm-scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 120
  statistic = "Average"
  threshold = 55
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling-group.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.auto-scaling-policy-scale-down.arn]

}


  
