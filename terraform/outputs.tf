output "jenkins_node_port" {
  value       = helm_release.jenkins.status[0].service[0].node_port
  description = "NodePort for Jenkins service"
}

output "grafana_node_port" {
  value       = kubernetes_service.kube_prometheus_grafana.spec[0].port[0].node_port
  description = "NodePort for Grafana service"
}
