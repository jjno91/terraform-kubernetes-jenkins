variable "jenkins_volume_id" {
  description = "(Required) Jenkins persists its data on disk and needs a static EBS volume ID in order to maintain state"
}

variable "volume_availability_zone" {
  description = "(Required) Jenkins must be deployed to the same zone as its persistent data volume"
}

variable "jenkins_volume_size" {
  description = "(Required) Jenkins volume size in gigabytes"
}

variable "host" {
  description = "(Required) https://www.terraform.io/docs/providers/kubernetes/r/ingress.html#host"
}

variable "cpu_request" {
  description = "(Optional) https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#cpu - matches m5.2xlarge resources"
  default     = "7890m"
}

variable "memory_request" {
  description = "(Optional) https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#memory - matches m5.2xlarge resources"
  default     = "31.5Gi"
}

variable "jenkins_version" {
  description = "(Optional) https://hub.docker.com/r/jenkins/jenkins/tags"
  default     = "latest"
}

variable "identifier" {
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
  description = "(Optional) JNLP port used by Jenkins agents"
  default     = "50000"
}

variable "tags" {
  description = "(Optional) https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/#resource-tags"
  default     = "Environment=terraform-kubernetes-jenkins,CostCenter=Jenkins"
}

variable "healthcheck_path" {
  description = "(Optional) https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/#health-check"
  default     = "/login"
}

variable "certificate_arn" {
  description = "(Optional) https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/#ssl"
  default     = ""
}
