run "default" {
  command          = plan
  expect_exit_code = 0
  assert_resource  = [
    "kubernetes_deployment.backend",
    "kubernetes_deployment.frontend"
  ]
}