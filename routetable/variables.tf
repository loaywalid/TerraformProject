variable "vpc-id" {

}

variable "ig-id" {
  default = ""

}
variable "puplic-cidr" {
  default     = "0.0.0.0/0"

}


variable "natgateway-id" {
  default = ""

}
variable "subnetsid" {
  type = list(string)
}

variable "tableName" {

}