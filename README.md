# terraform-kubernetes-jenkins

Terraform module for deploying Jenkins on Kubernetes

## Usage

```terraform
module "this" {
  source              = "github.com/jjno91/terraform-kubernetes-jenkins?ref=master"
  jenkins_volume_id   = "vol-abc123"
  jenkins_volume_size = "50"
}
```

## Configuring Kubernetes Cloud

Jenkins will be accessible inside the Kubernetes cluster from the DNS <identifier>.<identifier>.svc.cluster.local

This DNS will need to be entered in the "Jenkins URL" config field for Kubernetes Cloud definition in order for K8S based JNLP agents to reach Jenkins
