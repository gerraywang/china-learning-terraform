variable "project_id" {
  description = "gcp project_id"
}

variable "project_no" {
  description = "gcp project_no"
}

variable "region" {
  description = "gcp region"
}

# Create a Kubernetes cluster
resource "google_container_cluster" "my_cluster" {
  name               = "my-k8s-cluster"
  initial_node_count = 1

  master_auth {

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context_cluster = "gke_${var.project_id}_${var.region}-a_my-k8s-cluster"
}

# Deploy Argo CD
resource "kubernetes_namespace" "argocd_namespace" {
  metadata {
    name = "argocd"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "argocd_release" {
  depends_on = [kubernetes_namespace.argocd_namespace]
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  values = [
    # add any custom values here
  ]
}