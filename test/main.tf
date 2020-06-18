module "this" {
  source     = "../"
  id         = "this"
  claim_name = kubernetes_persistent_volume_claim.this.metadata[0].name
}

resource "kubernetes_persistent_volume" "this" {
  metadata {
    name = "this"
  }

  spec {
    capacity = {
      storage = "5Gi"
    }

    persistent_volume_source {
      local {
        path = "/tmp"
      }
    }

    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["*"]
          }
        }
      }
    }

    storage_class_name = kubernetes_storage_class.this.metadata[0].name
    access_modes       = ["ReadWriteOnce"]
  }
}

resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name      = "this"
    namespace = "this"
  }

  spec {
    resources {
      requests = {
        storage = "5Gi"
      }
    }

    storage_class_name = kubernetes_storage_class.this.metadata[0].name
    access_modes       = ["ReadWriteOnce"]
    volume_name        = kubernetes_persistent_volume.this.metadata[0].name
  }
}

resource "kubernetes_storage_class" "this" {
  metadata {
    name = "local"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  reclaim_policy      = "Retain"
}
