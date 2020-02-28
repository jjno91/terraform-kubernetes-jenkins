# terraform-kubernetes-jenkins

Terraform module for deploying Jenkins on Kubernetes

## Usage

```terraform
module "jenkins" {
  source                   = "StayWell/jenkins/kubernetes"
  version                  = "0.4.0"
  identifier               = "jenkins"
  jenkins_volume_id        = module.ebs.volume_id
  volume_availability_zone = data.aws_availability_zones.this.names[1]
  jenkins_volume_size      = "100"
  jenkins_version          = "2.176.2-jdk11"
  host                     = "jenkins.mycompany.com"
  tags                     = "Creator=Terraform,Environment=jenkins-dev,Owner=devops@mycompany.com,CostCenter=Jenkins"
}

data "aws_availability_zones" "this" {}

module "ebs" {
  source            = "StayWell/resilient-ebs/aws"
  version           = "0.1.1"
  env               = "jenkins-dev"
  availability_zone = data.aws_availability_zones.this.names[1]
  size              = "100"
}
```

## Configuring Kubernetes Cloud

1. Click: "Add a new cloud" > "Kubernetes"
2. Kubernetes Namespace = jenkins
3. Jenkins URL = <http://jenkins.jenkins.svc.cluster.local/>
4. Concurrency Limit = 50
5. Note that "Kubernetes URL" and Kubernetes "Credentials" should remain unset. This information is pulled from the Kubernetes service account Jenkins is running as. The service account can be tested by clicking "Test Connection".
