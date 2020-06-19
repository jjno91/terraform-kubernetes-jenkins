variable "volume_name" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/persistent_volume_claim.html#volume_name"
}

variable "storage_class_name" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/persistent_volume_claim.html#storage_class_name"
  default     = ""
}

variable "host" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/ingress.html#host"
  default     = "jenkins"
}

variable "cpu" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#cpu"
  default     = "500m"
}

variable "memory" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#memory"
  default     = "1Gi"
}

variable "storage" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/persistent_volume_claim.html#requests"
  default     = "5Gi"
}

variable "image" {
  description = "https://hub.docker.com/r/jenkins/jenkins/tags"
  default     = "jenkins/jenkins:latest"
}

variable "id" {
  description = "Used to generate namespace and name resources"
  default     = "jenkins"
}

variable "web_port" {
  description = "Jenkins web port internal to the Jenkins container"
  default     = "8080"
}

variable "jnlp_port" {
  description = "JNLP port exposed for Jenkins agents"
  default     = "50000"
}
