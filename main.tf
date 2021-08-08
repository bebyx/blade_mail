terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  region  = var.region
}

resource "tls_private_key" "blade-mail-ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key-file" {
 content = tls_private_key.blade-mail-ssh.private_key_pem
 filename = "${aws_key_pair.blade-mail-ssh.key_name}.pem"
 file_permission = 0400
}

resource "aws_key_pair" "blade-mail-ssh" {
  key_name = "terraform"
  public_key = tls_private_key.blade-mail-ssh.public_key_openssh
}

# Get latest Debian Linux 10 AMI
data "aws_ami" "debian-linux-10" {
  most_recent = true
  owners      = ["679593333241"]
  filter {
    name   = "name"
    values = ["debian-10*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

}
