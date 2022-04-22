terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}
provider "aws" {
  alias   = "account_route53"
  version = ">= 3.4.0"
}
terraform {
  required_version = ">= 1.1.6"
}