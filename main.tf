resource "kubernetes_namespace" "this" {
  metadata {
    name = var.id
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = var.id
  }

  role_ref {
    name      = "cluster-admin"
    kind      = "ClusterRole"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    name      = kubernetes_service_account.this.metadata[0].name
    kind      = "ServiceAccount"
    api_group = ""
    namespace = kubernetes_namespace.this.metadata[0].name
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = "this"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  automount_service_account_token = true
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = "this"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    replicas               = 1
    revision_history_limit = 5

    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = var.id
      }
    }

    template {
      metadata {
        labels = {
          app = var.id
        }
      }

      spec {
        service_account_name            = kubernetes_service_account.this.metadata[0].name
        automount_service_account_token = true

        container {
          name  = "this"
          image = var.image

          resources {
            requests {
              cpu    = var.cpu
              memory = var.memory
            }
          }

          env {
            name  = "JAVA_OPTS"
            value = "-Dorg.jenkinsci.plugins.durabletask.BourneShellScript.HEARTBEAT_CHECK_INTERVAL=300"
          }

          port {
            container_port = var.web_port
          }

          port {
            container_port = var.jnlp_port
          }

          volume_mount {
            name       = "home"
            mount_path = "/var/jenkins_home"
          }
        }

        security_context {
          fs_group = "2000"
        }

        volume {
          name = "home"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = "this"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    type = "NodePort"

    selector = {
      app = var.id
    }

    port {
      name = "http"
      port = var.web_port
    }

    port {
      name = "jnlp"
      port = var.jnlp_port
    }
  }
}

resource "kubernetes_ingress" "this" {
  metadata {
    name      = "this"
    namespace = kubernetes_namespace.this.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = var.host

      http {
        path {
          path = "/*"

          backend {
            service_name = kubernetes_service.this.metadata[0].name
            service_port = kubernetes_service.this.spec[0].port[0].port
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name      = "this"
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    volume_name        = var.volume_name
    storage_class_name = var.storage_class_name

    resources {
      requests = {
        storage = var.storage
      }
    }
  }
}
