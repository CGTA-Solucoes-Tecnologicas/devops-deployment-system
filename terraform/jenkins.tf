variable "jenkins_admin_user" { default = "admin" }
variable "jenkins_admin_pass" { default = "changeme" }

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = kubernetes_namespace.infra.metadata[0].name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "jenkins"
  version    = "12.5.3"

  values = [yamlencode({
    controller = {
      adminUser     = var.jenkins_admin_user
      adminPassword = var.jenkins_admin_pass
      service       = { type = "NodePort" }
    }
  })]
}
