variable "claim_name" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#claim_name"
}

variable "host" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/ingress.html#host"
  default     = "jenkins"
}

variable "cpu_request" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#cpu - matches m5.2xlarge resources"
  default     = "500m"
}

variable "memory_request" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#memory - matches m5.2xlarge resources"
  default     = "1Gi"
}

variable "jenkins_version" {
  description = "https://hub.docker.com/r/jenkins/jenkins/tags"
  default     = "latest"
}

variable "id" {
  description = "Used to generate namespace and name resources"
  default     = "jenkins"
}

variable "labels" {
  description = "Additional labels applied to all resources"
  default     = []
}

variable "web_port" {
  description = "Jenkins web port internal to the Jenkins container"
  default     = "8080"
}

variable "jnlp_port" {
  description = "JNLP port exposed for Jenkins agents"
  default     = "50000"
}
