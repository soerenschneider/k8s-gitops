terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.34.0"
    }

    local = {
      source = "hashicorp/local"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      project     = "k8s-gitops"
      project_url = "https://github.com/k8s-gitops/contrib/terraform"
      managed_by  = "terraform"
      env         = "svc.pt.soeren.cloud"
    }
  }
}
