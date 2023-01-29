resource "aws_instance" "pubilc-ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.securitygroup]
  key_name                    = var.key-name
  count                       = length(var.subnetsid)
  subnet_id                   = var.subnetsid[count.index]
  associate_public_ip_address = "true"

  connection {
    type        = var.c-type
    user        = var.c-user
    private_key = file(var.private-key-name)
    host        = self.public_ip
  }

  provisioner "file" {
    source      = var.source-file
    destination = var.destination-file
  }

  provisioner "remote-exec" {
    inline = var.inline
  }

  provisioner "local-exec" {
    command = "echo Public-ip ${count.index}: ${self.public_ip} >> ./all-ips.txt"
  }

  tags = {
    Name = "${var.name} ${count.index + 1}"
  }
}


resource "aws_instance" "private-ec2" {
  ami                    = var.private-ami
  instance_type          = var.private-instance-type
  count                  = length(var.private-subnetid)
  subnet_id              = var.private-subnetid[count.index]
  vpc_security_group_ids = [var.private-securitygroup]
  key_name               = var.p-key-name
  user_data              = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo chmod 777 /var/www/html
    sudo chmod 777 /var/www/html/index.nginx-debian.html
    sudo echo '<h1>Private Instance ${count.index + 1} </h1>' > /var/www/html/index.nginx-debian.html
    sudo systemctl restart nginx
  EOF


  provisioner "local-exec" {
    command = "echo Private-ip ${count.index}: ${self.private_ip} >> ./all-ips.txt"
  }
  tags = {
    Name = "${var.private-name} ${count.index + 1}"
  }
}