resource "kubernetes_namespace" "this" {
  metadata {
    name = var.identifier
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.identifier
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  automount_service_account_token = true
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = var.identifier
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

resource "kubernetes_storage_class" "this" {
  metadata {
    name = var.identifier
  }

  parameters = {
    type = "gp2"
  }

  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Retain"
}

resource "kubernetes_persistent_volume" "this" {
  metadata {
    name = var.identifier
  }

  spec {
    capacity = {
      storage = "${var.jenkins_volume_size}Gi"
    }

    persistent_volume_source {
      aws_elastic_block_store {
        volume_id = var.jenkins_volume_id
      }
    }

    access_modes       = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.this.metadata[0].name
  }
}

resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name      = var.identifier
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    resources {
      requests = {
        storage = "${var.jenkins_volume_size}Gi"
      }
    }

    access_modes       = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.this.metadata[0].name
    volume_name        = kubernetes_persistent_volume.this.metadata[0].name
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.identifier
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    strategy {
      type = "Recreate"
    }

    selector {
      match_labels = {
        app = var.identifier
      }
    }

    template {
      metadata {
        labels = {
          app = var.identifier
        }
      }

      spec {
        container {
          name  = "jenkins"
          image = "jenkins/jenkins:${var.jenkins_version}"

          resources {
            requests {
              cpu    = var.cpu_request
              memory = var.memory_request
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
            name       = "jenkins-home"
            mount_path = "/var/jenkins_home"
          }
        }

        security_context {
          fs_group = "2000"
        }

        node_selector = {
          "failure-domain.beta.kubernetes.io/zone" = var.volume_availability_zone
        }

        volume {
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.this.metadata[0].name
          }

          name = "jenkins-home"
        }

        service_account_name            = kubernetes_service_account.this.metadata[0].name
        automount_service_account_token = true
      }
    }

    replicas               = 1
    revision_history_limit = 5
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = var.identifier
    namespace = kubernetes_namespace.this.metadata[0].name
  }

  spec {
    type = "NodePort"

    selector = {
      app = var.identifier
    }

    port {
      name        = "http"
      port        = var.web_port
    }

    port {
      name        = "jnlp"
      port        = var.jnlp_port
    }
  }
}

resource "kubernetes_ingress" "this" {
  metadata {
    name      = var.identifier
    namespace = kubernetes_namespace.this.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                    = "alb"
      "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
      "alb.ingress.kubernetes.io/tags"                 = var.tags
      "alb.ingress.kubernetes.io/healthcheck-path"     = var.healthcheck_path
      "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/actions.ssl-redirect" = "{\"Type\": \"redirect\", \"RedirectConfig\": { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}"
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
