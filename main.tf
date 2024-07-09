terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
  backend "s3" {
    bucket = "delanhese-devops-iac"
    key    = "state/terraform.state"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"

  profile = "delanhese"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "delanhese-devops-iac"
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    IAC = "True"
  }
}


resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = "delanhese-devops-iac"

  versioning_configuration {
    status = "Enabled"
  }
}
