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

  ip_allocation_policy {
    # 使用 VPC-native routing。
    # 没有其他的配置是必要的，GKE 会自动为您创建合适的子网和 IP 范围。
  }
}

