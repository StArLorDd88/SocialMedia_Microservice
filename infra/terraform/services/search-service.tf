resource "kubernetes_deployment" "post_service" {
  metadata {
    name      = "search-service"
    namespace = "default"
  }

  spec {
    replicas = 2
    selector {
      match_labels = { app = "search-service" }
    }
    template {
      metadata { labels = { app = "search-service" } }
      spec {
        container {
          name  = "search-service"
          image = "your-dockerhub-username/search-service:latest"
          port { container_port = 3004 }
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
    name = "search-service"
  }
  spec {
    selector = { app = "search-service" }
    port {
      port        = 3004
      target_port = 3004
    }
    type = "ClusterIP"
  }
}
