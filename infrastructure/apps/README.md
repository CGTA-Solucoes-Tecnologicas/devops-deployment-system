# Apps Namespace Module

Creates a Kubernetes namespace intended for application workloads.

## Usage

```hcl
module "apps_namespace" {
  source = "./apps"
  # Optional override
  # name = "apps"
}
```

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | `"apps"` | Name of the Kubernetes namespace. |

## Outputs

| Name | Description |
|------|-------------|
| `namespace_name` | The name of the created namespace. |
