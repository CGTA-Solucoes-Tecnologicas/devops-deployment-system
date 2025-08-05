test {
  name = "infra namespace default"

  mock_provider "kubernetes" {}

  module "namespace" {
    source    = ".."
    providers = { kubernetes = mock.kubernetes }
  }

  assert {
    condition     = module.namespace.namespace_name == "infra"
    error_message = "Expected namespace name to be infra"
  }
}
