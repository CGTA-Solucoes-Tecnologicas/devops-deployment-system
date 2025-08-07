resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.apps.metadata[0].name
    labels    = { app = "backend" }
  }
  spec {
    replicas = 1
    selector { match_labels = { app = "backend" } }
    template {
      metadata { labels = { app = "backend" }
        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "80"
        }
      }
      spec {
        container {
          name  = "backend"
          image = var.backend_image
          port  { container_port = 80 }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend"
    namespace = kubernetes_namespace.apps.metadata[0].name
  }
  spec {
    selector = { app = "backend" }
    port     { port = 80 target_port = 80 }
    type     = "NodePort"
  }
}
