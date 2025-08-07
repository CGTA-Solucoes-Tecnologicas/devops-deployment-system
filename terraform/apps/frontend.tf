resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.apps.metadata[0].name
    labels    = { app = "frontend" }
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "frontend" } }
    template {
      metadata { labels = { app = "frontend" }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "80"
        }
      }
      spec {
        container {
          name  = "frontend"
          image = var.frontend_image
          port  { container_port = 80 }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace.apps.metadata[0].name
  }
  spec {
    selector = { app = "frontend" }
    port     { port = 80 target_port = 80 }
    type     = "NodePort"
  }
}
