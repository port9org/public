variable "ami-id" {
# Eu-Central-1 AMI ID:
  #Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-06-09
default = "ami-065deacbcaac64cf2"
}

variable "ssh-key-name" {
default = "sliver-c2-terraform"
}

variable "instance_name" {
  description = "Value of Name tag for the EC2 instance"
  type        = string
  default     = "sliverC2-terraform-test"
}

variable "ssh-keyPath" {
  default = "sliver-c2-terraform.pem"
}

variable "route53-zoneid" {
  default = "Z0727[....]]XI05F1"
}


variable "route53-subdomain" {
  default = "sliverc2-2873.port9.org"
}

data "http" "my_source_ip" {
  url = "https://ipv4.icanhazip.com"
}