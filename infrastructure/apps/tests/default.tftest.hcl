test {
  name = "apps namespace default"

  mock_provider "kubernetes" {}

  module "namespace" {
    source    = ".."
    providers = { kubernetes = mock.kubernetes }
  }

  assert {
    condition     = module.namespace.namespace_name == "apps"
    error_message = "Expected namespace name to be apps"
  }
}
