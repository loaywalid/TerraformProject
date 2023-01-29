module "vpc" {
  source               = "./vpc"
  vpc-cidr             = "10.0.0.0/16"
  vpc-name             = "terraformvpc"
  publicsubnet-cidr  = { public1 : "10.0.0.0/24", public2 : "10.0.1.0/24" }
  privatesubnet-cidr = { private1 : "10.0.2.0/24", private2 : "10.0.3.0/24" }

}


module "internetgateway1" {
  source              = "./internetgateway"
  ig-name =  "Terraform internetgateway"
  vpc-id               = module.vpc.vpc-id

}

module "natgateway" {
  source         = "./natgateway"
  dependency     = module.internetgateway1.ig-id
  publicSubnetId = module.vpc.puplicsubnet-id[0]

}


module "routing_public" {
  source              = "./routetable"
  vpc-id               = module.vpc.vpc-id
  ig-id = module.internetgateway1.ig-id
  tableName           = "public Route Table"
  subnetsid          = module.vpc.puplicsubnet-id
}

module "routing_private" {
  source         = "./routetable"
  vpc-id          = module.vpc.vpc-id
  natgateway-id = module.natgateway.nat_id
  tableName      = "private Route Table"
  subnetsid     = module.vpc.privatesubnet-id
}



module "securityGroup" {
  source               = "./securitygroup"
  vpc-id                = module.vpc.vpc-id
  puplic-cidr          = "0.0.0.0/0"
  sg_name              = "security_group"
  sg_description       = "security_group"
  sgfp = 22
  sgtp   = 80
  sg_protocol_ingress  = "tcp"
  sgfpe  = 0
  sgtpe    = 0
  sg_protocol_egress   = "-1"
}



module "public-ec2" {
  source = "./ec2"
  ami = "ami-09b2a1e33ce552e68"
  instance_type = "t2.micro"
  securitygroup = module.securityGroup.sg_id
  key-name = "key1"
  subnetsid = module.vpc.puplicsubnet-id
  c-type   = "ssh"
  c-user   = "ubuntu"
  private-key-name = "./key1.pem"
  source-file = "./nginx.sh"
  destination-file = "/tmp/nginx.sh"
  inline = [
    "chmod 777 /tmp/nginx.sh",
    "/tmp/nginx.sh ${module.NetwowrkLB.nlb-dns}"
   ]
  name = "proxy"
}


module "ApplicationLB" {
  source = "./applicationloadbalancer"
  name = "Applb"
  sg_id = module.securityGroup.sg_id
  subnets = module.vpc.puplicsubnet-id
  vpcid = module.vpc.vpc-id
  ec2ids = module.public-ec2.public-ec2-ip
  lb_internal = "false"
  listener_port = 80
  listener_protocol = "HTTP"
  target_name = "application"
  target_port = 80
  target_protocol = "HTTP"
  health_protocol = "HTTP"
  attach_target_port = 80
  depends_on = [
    module.public-ec2
  ]
}






module "private-ec2" {
  source = "./ec2"
  private-ami = "ami-09b2a1e33ce552e68"
  private-instance-type = "t2.micro"
  private-subnetid = module.vpc.privatesubnet-id
  private-securitygroup = module.securityGroup.sg_id
  key-name = "key1"
  p-key-name = "key1"
}


module "NetwowrkLB" {
  source             = "./networkloadbalancer"
  name = "NLB"
  nlb-internal = true
  subnets = module.vpc.privatesubnet-id
  targetgroup-name = "network"
  targetgroup-port = 80
  targetgroup-protocol = "TCP"
  vpcid = module.vpc.vpc-id
  healthcheck-protocol = "TCP"
  ec2ids = module.private-ec2.private-ec2-ip
  tgattachment-port = 80
  listener-port = 80
  listener-protocol = "TCP"
   depends_on = [
    module.private-ec2
  ]

}