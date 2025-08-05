# Infrastructure Modules

This directory contains OpenTofu modules for Kubernetes namespaces used by the project.

## Modules

### `infra`
Creates the `infra` namespace for cluster infrastructure components.

### `apps`
Creates the `apps` namespace for application workloads.

Each module exposes a `name` variable to override the namespace and outputs `namespace_name`.

## Testing

Unit tests are provided for each module using `tofu test`.
Run tests from the module directory:

```bash
tofu test
```
