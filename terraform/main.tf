terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_credentials_validation = true

  endpoints {
    ec2 = "http://ip10-0-18-4-d0dh0a005akh4glkf9f0-4566.direct.lab-boris.fr"
  }
}

variable "instance_count" {
  description = "Nombre d'instances EC2 à créer"
  type        = number
  default     = 1
}

resource "random_pet" "ami_suffix" {
  length = 2
  keepers = {
    # Change à chaque lancement de Jenkins
    trigger = timestamp()
  }
}

resource "aws_instance" "demo" {
  count         = var.instance_count
  ami           = "ami-${random_pet.ami_suffix.id}"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Instance-${count.index + 1}"
  }
}

output "instance_ids" {
  value = aws_instance.demo[*].id
}









