# infra/jenkins.tf
variable "jenkins_admin_user" { default = "admin" }
variable "jenkins_admin_pass" { default = "pass" }

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = kubernetes_namespace.infra.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "jenkins"
  version    = "13.6.16"


  # Make Helm wait for resources; increase timeout for slow pulls
  wait    = true
  timeout = 1200
  atomic  = true

  values = [yamlencode({
    jenkinsUser     = var.jenkins_admin_user
    jenkinsPassword = var.jenkins_admin_pass

    service = {
      type = "NodePort"
      port = 8080
    }

    # Reduce resource requests so it schedules on small Minikube
    resources = {
      requests = { cpu = "500m", memory = "1Gi" }
      limits   = { cpu = "1",    memory = "2Gi" }
    }
  })]
}
