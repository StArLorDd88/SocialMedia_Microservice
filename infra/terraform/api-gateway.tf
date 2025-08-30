resource "kubernetes_deployment" "api_gateway" {
  metadata {
    name = "api-gateway"
  }

  spec {
    replicas = 2
    selector {
      match_labels = { app = "api-gateway" }
    }
    template {
      metadata { labels = { app = "api-gateway" } }
      spec {
        container {
          name  = "api-gateway"
          image = "your-dockerhub-username/api-gateway:latest"
          port { container_port = 3000 }
        }
      }
    }
  }
}

resource "kubernetes_service" "api_gateway" {
  metadata {
    name = "api-gateway"
  }
  spec {
    selector = { app = "api-gateway" }
    port {
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer" 
  }
}