module "this" {
  source              = "github.com/jjno91/terraform-kubernetes-jenkins?ref=master"
  jenkins_volume_id   = "vol-abc123"
  jenkins_volume_size = "50"
}
