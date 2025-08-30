resource "kubernetes_deployment" "post_service" {
  metadata {
    name      = "identify-service"
    namespace = "default"
  }

  spec {
    replicas = 2
    selector {
      match_labels = { app = "identify-service" }
    }
    template {
      metadata { labels = { app = "identify-service" } }
      spec {
        container {
          name  = "identify-service"
          image = "your-dockerhub-username/identify-service:latest"
          port { container_port = 3001 }
          env {
            name  = "REDIS_HOST"
            value = kubernetes_service.redis.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "post_service" {
  metadata {
    name = "identify-service"
  }
  spec {
    selector = { app = "identify-service" }
    port {
      port        = 3001
      target_port = 3001
    }
    type = "ClusterIP"
  }
}
