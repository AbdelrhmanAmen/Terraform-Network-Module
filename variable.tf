variable "vpc" {
    description = "availability zone"
    type = string 
}


variable "private_subnets" {
    type = map
    default = {
        subnet-1 = {
            az = "euw3-az1"
            cidr = "192.168.1.0/24"
        }
        subnet-2 = {
            az = "euw3-az2"
            cidr = "192.168.2.0/24"
        }
    }
}

variable "public_subnets" {
    type = map
    default = {
        subnet-3 = {
            az = "euw3-az3"
            cidr = "192.168.3.0/24"
        }
    }
}

variable "author" {
    description = "owner of the code"
    type = string
}

