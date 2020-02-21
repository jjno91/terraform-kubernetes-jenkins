module "this" {
  source = "../"

  # terraform plan should work with fake values here
  jenkins_volume_id        = "abc-123"
  jenkins_volume_size      = "100"
  volume_availability_zone = "this"
  certificate_arn          = "this"
  host                     = "this.com"
}
