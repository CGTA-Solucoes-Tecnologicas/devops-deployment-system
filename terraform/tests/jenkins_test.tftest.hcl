run "default" {
  command          = plan
  expect_exit_code = 0
  assert_resource  = [
    "helm_release.jenkins"
  ]
}
