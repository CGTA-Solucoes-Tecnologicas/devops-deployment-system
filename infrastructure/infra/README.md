# Infra Namespace Module

Creates a Kubernetes namespace intended for infrastructure components.

## Usage

```hcl
module "infra_namespace" {
  source = "./infra"
  # Optional override
  # name = "infra"
}
```

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | `"infra"` | Name of the Kubernetes namespace. |

## Outputs

| Name | Description |
|------|-------------|
| `namespace_name` | The name of the created namespace. |
