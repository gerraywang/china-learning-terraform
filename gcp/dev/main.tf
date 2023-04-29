# provider setting
terraform {
  required_version = "= 1.4.5"
    required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }
}

provider "google" {
  credentials = file("./secret.json")
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = "${var.gcp_region}-a"
}

module "api" {
  source = "./module/api"
}

module "cloudbuild" {
  source     = "./module/cloudbuild"
  depends_on = [module.api]
  project_id = var.gcp_project_id
  project_no = var.gcp_project_no
  region  = var.gcp_region
}

module "cloudrun" {
  source       = "./module/cloudrun"
  depends_on   = [module.api]
  project_id = var.gcp_project_id
  region  = var.gcp_region
}

module "gke" {
  source       = "./module/gke"
  depends_on   = [module.api]
  project_id = var.gcp_project_id
  project_no = var.gcp_project_no
  region  = var.gcp_region
}
