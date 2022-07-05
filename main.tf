terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "sliver-c2" {
  ami                    = var.ami-id
  instance_type          = "t2.micro"
  key_name               = var.ssh-key-name
  vpc_security_group_ids = [aws_security_group.main.id]

 
  # Provisioning the sliver bootstrap file.
  provisioner "file" {
    source      = "/home/par/sliver-terraform/sliverc2-bootstrap.sh"
    destination = "/tmp/sliverc2-bootstrap.sh"
  }
  # Executing the sliver bootstrap file.
  # Terraform does not reccomend this method becuase Terraform state file cannot track what the scrip is provissioning
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/sliverc2-bootstrap.sh",
      "sudo /tmp/sliverc2-bootstrap.sh",
    ]
  }

  # Setting up the ssh connection to install sliver/msf.
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.ssh-keyPath)
  }


  tags = {
    Name        = var.instance_name
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["${chomp(data.http.my_source_ip.body)}/32"]
      description      = "HTTP Access - Dynamic Source IP Update"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 81
    },
    {
      cidr_blocks      = ["${chomp(data.http.my_source_ip.body)}/32"]
      description      = "HTTPS Access - Dynamic Source IP Update"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
    {
      cidr_blocks      = ["${chomp(data.http.my_source_ip.body)}/32"]
      description      = "SSH Access - Dynamic Source IP Update"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}

resource "aws_route53_record" "sliverc2-record" {
  zone_id = var.route53-zoneid
  name    = var.route53-subdomain
  type    = "A"
  ttl     = "300"
  records = [aws_instance.sliver-c2.public_ip]
}