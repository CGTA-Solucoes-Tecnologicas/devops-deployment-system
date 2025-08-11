# --- Grafana ---
data "kubernetes_service" "grafana" {
  metadata {
    name      = "kube-prometheus-grafana"
    namespace = kubernetes_namespace.infra.metadata[0].name
  }
  depends_on = [helm_release.monitoring]  # wait for the chart to be created
}

output "grafana_node_port" {
  description = "NodePort for Grafana service"
  value       = try(data.kubernetes_service.grafana.spec[0].port[0].node_port, null)
  # nullable = true   # (default already true, explicit if you want)
}

# --- Jenkins ---
data "kubernetes_service" "jenkins" {
  metadata {
    name      = "jenkins"  # for jenkinsci/jenkins chart the service is "jenkins"
    namespace = kubernetes_namespace.infra.metadata[0].name
  }
  depends_on = [helm_release.jenkins]
}

output "jenkins_node_port" {
  description = "NodePort for Jenkins service"
  value       = try(data.kubernetes_service.jenkins.spec[0].port[0].node_port, null)
}
