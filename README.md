DevOps Kata
- Build a deployment system with:
  - Jenkins
  - Helm
  - OpenTofu
  - Minikub or other kubernetes cluster manager
  - Prometheus
  - Prometheus
  - Grafana

You need to be able to deploy an application with all this tools and you need 2 clusters (or 2 namespaces).
One for the infra an other for the apps that will be deployed. The pipelines in Jenkins need to run tests and fail if tests fail.
OpenTofu need to have automated tests as well, all apps deploed need to be integrated with Grafana
and Prometheus by default.

## Cluster and Namespace Setup

Use the helper script to start a local Kubernetes cluster and create the
required namespaces:

```bash
scripts/setup-namespaces.sh
```

The script:

* starts a Minikube cluster if one is not running
* creates separate namespaces for infrastructure (`infra`) and applications (`apps`)
* applies OpenTofu configuration to the `infra` namespace
* deploys Helm charts into the `apps` namespace

### Manual steps

The script above simply automates the following commands:

```bash
# Start a local cluster
minikube start

# Create namespaces
kubectl create namespace infra
kubectl create namespace apps

# Apply infrastructure with OpenTofu
cd infrastructure
tofu init
tofu apply -var="namespace=infra"

# Deploy application with Helm
helm upgrade --install app-release helm/app-chart --namespace apps --create-namespace
```

Using different namespaces ensures a clear separation between infrastructure
components and application workloads.


