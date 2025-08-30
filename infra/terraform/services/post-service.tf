resource "kubernetes_deployment" "post_service" {
  metadata {
    name      = "post-service"
    namespace = "default"
  }

  spec {
    replicas = 2
    selector {
      match_labels = { app = "post-service" }
    }
    template {
      metadata { labels = { app = "post-service" } }
      spec {
        container {
          name  = "post-service"
          image = "your-dockerhub-username/post-service:latest"
          port { container_port = 3002 }
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
    name = "post-service"
  }
  spec {
    selector = { app = "post-service" }
    port {
      port        = 3002
      target_port = 3002
    }
    type = "ClusterIP"
  }
}