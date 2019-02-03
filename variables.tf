variable "jenkins_volume_id" {
  description = "(required) Jenkins persists its data on disk and needs a static EBS volume ID in order to maintain state"
  default     = ""
}

variable "jenkins_volume_size" {
  description = "(required) Jenkins volume size in gigabytes"
  default     = ""
}

variable "jenkins_version" {
  description = "(optional) https://hub.docker.com/r/jenkins/jenkins/tags"
  default     = "latest"
}

variable "identifier" {
  description = "(optional) Used to generate namespace and name resources"
  default     = "jenkins"
}

variable "labels" {
  description = "(optional) Additional labels applied to all resources"
  default     = []
}

variable "http_exposed_port" {
  description = "(optional) Jenkins web port exposed by Kubernetes service"
  default     = "80"
}

variable "http_container_port" {
  description = "(optional) Jenkins web port internal to the Jenkins container"
  default     = "8080"
}

variable "jnlp_port" {
  description = "(optional) JNLP port used by Jenkins agents"
  default     = "50000"
}
