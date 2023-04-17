variable "project_id" {
  description = "gcp project id"
}
variable "project_no" {
  description = "gcp project no"
}
variable "region" {
  description = "gcp region"
}

resource "google_project_iam_member" "cloudbuild_iam" {
  for_each = toset([
    "roles/run.developer",
    "roles/iam.serviceAccountUser",
    "roles/artifactregistry.writer"
  ])
  role    = each.key
  member  = "serviceAccount:${var.project_no}@cloudbuild.gserviceaccount.com"
  project = var.project_id
}

resource "google_cloudbuild_trigger" "cloudbuild_sample_api" {
  location = "global"
  name     = "cloudbuild-sample-api"
  filename = "cloudbuild.yaml"

  github {
    owner = "gerraywang"
    name  = "testapi"
    push {
      branch = "^main$"
    }
  }

  substitutions = {
    _AR_HOSTNAME = "asia-northeast1-docker.pkg.dev"
    _SERVICE_NAME = "testapi"
    _DEPLOY_REGION = var.region
  }
}