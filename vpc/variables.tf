variable "vpc-cidr" {
    
}

variable "vpc-name" {
  
}


variable "publicsubnet-cidr" {
  type        = map(string)
}

variable "privatesubnet-cidr" {
  type        = map(string)
}