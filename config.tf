terraform {
  # backend "s3" {
  #   bucket         = "myrouteterraformbucket"
  #   key            = "backend/terraform.tfstate"
  #   region         = "us-east-1"
  #    #  dynamodb_table = "my-lock-table"
  #   encrypt        = true
    
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  
}
