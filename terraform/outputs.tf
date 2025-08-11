# --- Grafana ---
data "kubernetes_service" "grafana" {
  metadata {
    name      = "kube-prometheus-grafana"
    namespace = kubernetes_namespace.infra.metadata[0].name
  }
}

output "grafana_node_port" {
  description = "NodePort for Grafana service"
  value       = data.kubernetes_service.grafana.spec[0].port[0].node_port
}

# --- Jenkins ---
data "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.infra.metadata[0].name
  }
}

output "jenkins_node_port" {
  description = "NodePort for Jenkins service"
  value       = data.kubernetes_service.jenkins.spec[0].port[0].node_port
}
