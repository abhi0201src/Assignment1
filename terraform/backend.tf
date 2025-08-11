terraform {
  backend "s3" {
    bucket  = "devopsbackend-new"
    key     = "terraform/django-nextjs-app/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  required_version = ">= 1.0"
}
