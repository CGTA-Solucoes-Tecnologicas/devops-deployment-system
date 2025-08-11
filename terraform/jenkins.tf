# Uses the official Jenkins chart (charts.jenkins.io) with the NEW admin keys
variable "jenkins_admin_user" { default = "admin" }
variable "jenkins_admin_pass" { default = "pass" }

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = kubernetes_namespace.infra.metadata[0].name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.75"

  # Let Helm wait, rollback on failure, and allow slow image pulls
  wait             = true
  timeout          = 1200
  atomic           = true
  cleanup_on_fail  = true

  values = [yamlencode({
    controller = {
      admin = {
        username = var.jenkins_admin_user
        password = var.jenkins_admin_pass
      }
      serviceType = "NodePort"     # expose on Minikube
      resources = {
        requests = { cpu = "500m", memory = "1Gi" }
        limits   = { cpu = "1",    memory = "2Gi" }
      }
      # servicePort defaults to 8080 in the chart; override if needed
    }
  })]
}
