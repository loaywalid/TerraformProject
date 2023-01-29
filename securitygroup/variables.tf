variable "puplic-cidr" {
}

variable "vpc-id" {
}

variable "sgtp" {
    description = "to port ingress"
}

variable "sgfp" {
        description = "from port ingress"

}

variable "sgfpe" {
        description = "from port egress"

}

variable "sgtpe" {
        description = "to port egress"

}

variable "sg_name" {
}

variable "sg_protocol_ingress" {
}

variable "sg_protocol_egress" {
}

variable "sg_description" {
}