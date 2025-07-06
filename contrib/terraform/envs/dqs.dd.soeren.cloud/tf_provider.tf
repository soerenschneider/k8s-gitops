terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
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
      env         = "dqs.dd.soeren.cloud"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "dqs-dd"
}
