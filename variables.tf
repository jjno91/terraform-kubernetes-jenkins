variable "host" {
  description = "(Optional) https://www.terraform.io/docs/providers/kubernetes/r/ingress.html#host"
  default     = "jenkins"
}

variable "jenkins_volume_size" {
  description = "(Optional) Jenkins volume size in gigabytes"
  default     = "30"
}

variable "cpu_request" {
  description = "(Optional) https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#cpu - matches m5.2xlarge resources"
  default     = "500m"
}

variable "memory_request" {
  description = "(Optional) https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#memory - matches m5.2xlarge resources"
  default     = "1Gi"
}

variable "jenkins_version" {
  description = "(Optional) https://hub.docker.com/r/jenkins/jenkins/tags"
  default     = "latest"
}

variable "id" {
  description = "(Optional) Used to generate namespace and name resources"
  default     = "jenkins"
}

variable "labels" {
  description = "(Optional) Additional labels applied to all resources"
  default     = []
}

variable "web_port" {
  description = "(Optional) Jenkins web port internal to the Jenkins container"
  default     = "8080"
}

variable "jnlp_port" {
  description = "(Optional) JNLP port exposed for Jenkins agents"
  default     = "50000"
}
