variable "key-name" {
    default = ""
  
}


variable "Public_key" {
    default = ""
  
}

variable "region" {
    default = ""
  
}

variable "web-server-sg" {
  default = ""
  }

  variable "launch-configuration-name" {
      default = ""
    
  }

  variable "image-id" {
      default = ""
    
  }

  variable "instance-type" {
      default = ""
    
  }

  ######################


variable "autoscaling-group-name" {
    default = ""
  
}
  
  variable "max-size" {
    default = "1"

  }

  variable "min-size" {
    default = "1"

  }

  variable "health-check-grace-period" {
      default = "300"
    
  }

  variable "desired-capacity" {
      default = "1"
    
  }

  variable "force-delete" {
    default = ""

  }

  variable "subnet_ids" {
    default = ""


  }

  variable "health-check-type" {
      default = ""
    
  }
  variable "target-group-arns" {
     
      default = ""
    
  }

  variable "tag-key" {
    default = ""

  }

  variable "tag-value" {
      default = ""

    
  }

  variable "userdata" {
      default = ""
    
  }


  variable "root_block_device" {
  type        = list(map(string))
  description = "Additional EBS block devices to attach to the instance"
  default     = []
}


  variable "ebs_block_device" {
  type        = list(map(string))
  description = "Additional EBS block devices to attach to the instance"
  default     = []
}

variable "userpassword" {
  default = ""
  
}

variable "username" {
  default = ""
  
}