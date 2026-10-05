terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.3.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path = "/etc/rancher/k3s/k3s.yaml"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheusv1"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "91.9.0"
  create_namespace = true
  namespace  = "monitoring"
  
}
