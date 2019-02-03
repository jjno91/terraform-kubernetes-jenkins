resource "kubernetes_namespace" "this" {
  metadata {
    name = "${var.identifier}"
  }
}

resource "kubernetes_service_account" "this" {
  metadata {
    name      = "${var.identifier}"
    namespace = "${kubernetes_namespace.this.metadata.0.name}"
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "${var.identifier}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.this.metadata.0.name}"
    namespace = "${kubernetes_namespace.this.metadata.0.name}"
  }
}

resource "kubernetes_storage_class" "this" {
  metadata {
    name = "${var.identifier}"
  }

  parameters {
    type = "gp2"
  }

  storage_provisioner = "kubernetes.io/aws-ebs"
  reclaim_policy      = "Retain"
}

resource "kubernetes_persistent_volume" "this" {
  metadata {
    name = "${var.identifier}"
  }

  spec {
    capacity {
      storage = "${var.jenkins_volume_size}Gi"
    }

    persistent_volume_source {
      aws_elastic_block_store {
        volume_id = "${var.jenkins_volume_id}"
      }
    }

    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "${kubernetes_storage_class.this.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name      = "${var.identifier}"
    namespace = "${kubernetes_namespace.this.metadata.0.name}"
  }

  spec {
    resources {
      requests {
        storage = "${var.jenkins_volume_size}Gi"
      }
    }

    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "${kubernetes_storage_class.this.metadata.0.name}"
    volume_name        = "${kubernetes_persistent_volume.this.metadata.0.name}"
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = "${var.identifier}"
    namespace = "${kubernetes_namespace.this.metadata.0.name}"
  }

  spec {
    selector {
      match_labels {
        app = "${var.identifier}"
      }
    }

    template {
      metadata {
        labels {
          app = "${var.identifier}"
        }
      }

      spec {
        container {
          name  = "jenkins"
          image = "jenkins/jenkins:${var.jenkins_version}"

          env {
            name  = "JAVA_OPTS"
            value = "-Dorg.jenkinsci.plugins.durabletask.BourneShellScript.HEARTBEAT_CHECK_INTERVAL=300"
          }

          port {
            container_port = "${var.http_container_port}"
          }

          port {
            container_port = "${var.jnlp_port}"
          }

          volume_mount {
            name       = "jenkins_home"
            mount_path = "/var/jenkins_home"
          }
        }

        security_context {
          fs_group = "2000"
        }

        volume {
          persistent_volume_claim {
            claim_name = "${kubernetes_persistent_volume_claim.this.metadata.0.name}"
          }

          name = "jenkins_home"
        }

        service_account_name = "${kubernetes_service_account.this.metadata.0.name}"
      }
    }

    replicas               = 1
    revision_history_limit = 5
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = "${var.identifier}"
    namespace = "${kubernetes_namespace.this.metadata.0.name}"
  }

  spec {
    selector {
      app = "${var.identifier}"
    }

    port {
      port        = "${var.http_exposed_port}"
      target_port = "${var.http_container_port}"
    }

    port {
      port        = "${var.jnlp_port}"
      target_port = "${var.jnlp_port}"
    }

    type = "LoadBalancer"
  }
}
