variable "gcp_service_list" {
  type = list(string)
  default = [
    "cloudbuild.googleapis.com",
    "clouddeploy.googleapis.com",
    "containerregistry.googleapis.com",
    "run.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "artifactregistry.googleapis.com",
    "container.googleapis.com"
  ]
}

resource "google_project_service" "activate_gcp_services" {
  for_each = toset(var.gcp_service_list)
  service  = each.key
  disable_dependent_services=true
}