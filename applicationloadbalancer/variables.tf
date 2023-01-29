variable "name" {
  default = ""
}
variable "sg_id" {
  default = ""
}
variable "subnets" {
  type = list(string)
}
variable "lb_internal" {
  default = ""
}
variable "listener_port" {
  default = ""
}
variable "listener_protocol" {
  default = ""
}
variable "vpcid" {
  default = ""
}
variable "ec2ids" {
  type = list(string)
}
variable "attach_target_port" {
  default = ""
}
variable "target_name" {
  default = ""
}
variable "target_port" {
  default = ""
}
variable "health_protocol" {
  default = ""
}
variable "target_protocol" {
  default = ""
}