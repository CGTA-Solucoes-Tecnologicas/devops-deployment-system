resource "helm_release" "monitoring" {
  name       = "kube-prometheus"
  namespace  = kubernetes_namespace.infra.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "58.5.3"

  # Permite que o Prometheus enxergue ServiceMonitors / PodMonitors em QUALQUER namespace
  values = [yamlencode({
    prometheus = {
      prometheusSpec = {
        serviceMonitorSelectorNilUsesHelmValues = false
        serviceMonitorNamespaceSelector         = {}   # <—
        podMonitorSelectorNilUsesHelmValues     = false
        podMonitorNamespaceSelector             = {}   # <—
      }
    }

    grafana = {
      service = { type = "NodePort" }
    }
  })]
}
