resource "kubernetes_namespace" "infra" {
  metadata { name = "infra" }
}
