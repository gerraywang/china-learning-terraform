# from terraform.tfvars
variable gcp_project_id {
  description = "GCP project id"
}
variable "gcp_project_no" {
  description = "GCP project no"
  type = number
}
variable gcp_region {
  description = "GCP region"
}
variable "gcp_project_name" {
  description = "GCP project name"
}

# others
variable "cluster_name" {
  description = "name of gke cluster"
  default     = "dev-cluster"
}
variable "env_name" {
  description = "name of environment"
  default     = "dev"
}
variable "network" {
  description = "name of VPC"
  default     = "dev-gek-network"
}
variable "subnetwork" {
  description = "name of subnetwork"
  default     = "dev-gke-subnet"
}
variable "ip_range_pods_name" {
  description = "name of secondary ip range used in pods"
  default     = "ip-range-pods"
}
variable "ip_range_services_name" {
  description = "name of secondary ip range used in services"
  default     = "ip-range-services"
}