module "this" {
  source = "../"

  # terraform plan should work with fake values here
  jenkins_volume_id   = "abc-123"
  jenkins_volume_size = "100"
}
