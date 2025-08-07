# Creating ServiceMonitor for  BACKEND
resource "kubernetes_manifest" "backend_sm" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "backend-sm"
      namespace = kubernetes_namespace.apps.metadata[0].name
      labels    = { release = "kube-prometheus" }    # <- deve bater com a label do Helm chart
    }
    spec = {
      selector = { matchLabels = { app = "backend" } }
      endpoints = [{
        port = "http"            # nome do port no Service (padrão "http" no TF)
        path = "/"
        interval = "15s"
      }]
    }
  }
}

# Create ServiceMonitor for FRONTEND
resource "kubernetes_manifest" "frontend_sm" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "frontend-sm"
      namespace = kubernetes_namespace.apps.metadata[0].name
      labels    = { release = "kube-prometheus" }
    }
    spec = {
      selector = { matchLabels = { app = "frontend" } }
      endpoints = [{
        port = "http"
        path = "/"
        interval = "15s"
      }]
    }
  }
}
