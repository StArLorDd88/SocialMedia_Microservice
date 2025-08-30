resource "kubernetes_deployment" "post_service" {
  metadata {
    name      = "media-service"
    namespace = "default"
  }

  spec {
    replicas = 2
    selector {
      match_labels = { app = "media-service" }
    }
    template {
      metadata { labels = { app = "media-service" } }
      spec {
        container {
          name  = "media-service"
          image = "your-dockerhub-username/media-service:latest"
          port { container_port = 3003 }
          env {
            name  = "REDIS_HOST"
            value = "redis.default.svc.cluster.local"
          }

          env {
            name  = "REDIS_PORT"
            value = "6379"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "post_service" {
  metadata {
    name = "media-service"
  }
  spec {
    selector = { app = "media-service" }
    port {
      port        = 3003
      target_port = 3003
    }
    type = "ClusterIP"
  }
}
