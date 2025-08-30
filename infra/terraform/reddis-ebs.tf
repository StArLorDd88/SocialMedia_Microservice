# PersistentVolumeClaim for Redis (EBS storage)
resource "kubernetes_persistent_volume_claim" "redis_data" {
  metadata {
    name = "redis-data"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    storage_class_name = "gp2"
  }
}

# Redis Deployment
resource "kubernetes_deployment" "redis" {
  metadata {
    name      = "redis"
    namespace = "default"
  }

  spec {
    replicas = 1
    selector {
      match_labels = { app = "redis" }
    }

    template {
      metadata {
        labels = { app = "redis" }
      }

      spec {
        container {
          name  = "redis"
          image = "redis:6.2"
          port {
            container_port = 6379
          }

          volume_mount {
            name       = "redis-storage"
            mount_path = "/data"
          }
        }

        volume {
          name = "redis-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.redis_data.metadata[0].name
          }
        }
      }
    }
  }
}

# Redis Service
resource "kubernetes_service" "redis" {
  metadata {
    name = "redis"
  }
  spec {
    selector = { app = "redis" }
    port {
      port        = 6379
      target_port = 6379
    }
    type = "ClusterIP"
  }
}
