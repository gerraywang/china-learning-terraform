# provider setting
terraform {
  required_version = "= 1.4.5"
    required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("./secret.json")

  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = "${var.gcp_region}-a"
}

# network
module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 4.0"
  project_id   = var.gcp_project_id
  network_name = "${var.network}-${var.env_name}"
  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.gcp_region
    },
  ]
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}

# gke
module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id             = var.gcp_project_id
  name                   = "${var.cluster_name}-${var.env_name}"
  regional               = true
  region                 = var.gcp_region
  network                = module.vpc.network_name
  subnetwork             = module.vpc.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  node_pools = [
    {
      name                      = "node-pool"
      machine_type              = "n2-standard-2"
      node_locations            = "${var.gcp_region}-a" # 複数のゾーンを指定できる
      min_count                 = 1
      max_count                 = 2
      disk_size_gb              = 30
    },
  ]
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

