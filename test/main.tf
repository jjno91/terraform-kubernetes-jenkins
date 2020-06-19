module "this" {
  source             = "../"
  volume_name        = kubernetes_persistent_volume.this.metadata[0].name
  storage_class_name = kubernetes_persistent_volume.this.spec[0].storage_class_name
}

resource "kubernetes_persistent_volume" "this" {
  metadata {
    name = "jenkins"
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
            operator = "Exists"
          }
        }
      }
    }

    storage_class_name = kubernetes_storage_class.this.metadata[0].name
    access_modes       = ["ReadWriteOnce"]
  }
}

resource "kubernetes_storage_class" "this" {
  metadata {
    name = "jenkins"
  }

  storage_provisioner = "kubernetes.io/no-provisioner"
  reclaim_policy      = "Retain"
}
