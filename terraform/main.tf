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
    ec2 = "http://ip10-0-2-6-cvh9tgab9qb14bivkplg-4566.direct.lab-boris.fr"
  }
}

# Génère une valeur aléatoire pour simuler un nouvel AMI à chaque commit
resource "random_id" "ami_suffix" {
  byte_length = 2
}

# Déclare le nombre d'instances directement dans main.tf
variable "instance_count" {
  description = "Nombre d'instances EC2 à créer"
  type        = number
  default     = 1
}

# Crée les instances EC2 avec un AMI fictif dynamique
resource "aws_instance" "demo" {
  count         = var.instance_count
  ami           = "ami-${random_id.ami_suffix.hex}"
  instance_type = "t2.micro"

  tags = {
    Name = "Instance-${count.index + 1}"
  }
}

# Affiche les IDs des instances créées   #Comm
output "instance_ids" {
  value = aws_instance.demo[*].id
} 
