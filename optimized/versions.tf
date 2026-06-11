terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  # F6: tagging governance enforced centrally — every resource gets the full set.
  default_tags {
    tags = {
      Study       = "cost-case"
      ManagedBy   = "terraform"
      Project     = "expense-pulse"
      Environment = "prod"
      Owner       = "kamal"
      CostCenter  = "devops"
    }
  }
}
