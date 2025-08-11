# Grant Jenkins (service account "jenkins" in ns infra) the rights to manage resources in ns "apps".
# NOTE: For demos we bind "edit" ClusterRole. In production, scope down as needed.

resource "kubernetes_role_binding" "jenkins_can_edit_apps" {
  metadata {
    name      = "jenkins-edit-apps"
    namespace = kubernetes_namespace.apps.metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = kubernetes_namespace.infra.metadata[0].name
  }
}
