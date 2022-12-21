terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "local" {
    path = "terraform.tfstate"
  }

}

provider "aws" {
  region  = "eu-west-2"
  shared_credentials_files = ["/home/gabriel/.aws/credentials"]
}