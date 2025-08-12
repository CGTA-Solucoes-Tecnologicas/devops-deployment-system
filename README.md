# DevOps Kata

- Build a deployment system with:
  - Jenkins
  - Helm
  - OpenTofu
  - Minikub or other kubernetes cluster manager
  - Prometheus
  - Grafana
  
This project demonstrates a simple deployment system for a sample application. It
combines a React frontend with a Node.js backend and uses common DevOps tooling
to automate infrastructure provisioning, application deployment, and
observability.



You need to be able to deploy an application with all this tools and you need 2 clusters (or 2 namespaces).
One for the infra an other for the apps that will be deployed. The pipelines in Jenkins need to run tests and fail if tests fail.
OpenTofu need to have automated tests as well, all apps deploed need to be integrated with Grafana and Prometheus by default.

## Running Tests

### Backend
```bash
cd backend
npm test
```

### Frontend
```bash
cd frontend
npm test -- --watchAll=false
```

## Install minikube

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube


sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system virt-manager libvirt-clients bridge-utils

sudo systemctl enable --now libvirtd

sudo usermod -aG libvirt,kvm $USER
newgrp libvirt
virsh --connect qemu:///system list --all
minikube start --driver=kvm2
sudo systemctl enable --now libvirtd


```

### OpenTofu
```bash
cd infrastructure
tofu test
```

## Interpreting Results and Troubleshooting

- A summary of passed/failed tests is printed at the end of each run.
- For failing tests, read the stack trace to identify which test and component failed.
- Ensure dependencies are installed (`npm ci` for Node projects, OpenTofu binary for infrastructure tests`).
- Rerun tests after fixes to verify the issue is resolved.

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
minikube start --driver=kvm2 --cpus=2 --memory=4g



# Apply infrastructure with OpenTofu
cd infrastructure
tofu init
tofu apply -var="namespace=infra"

# Deploy application with Helm
helm upgrade --install app-release helm/app-chart --namespace apps --create-namespace
```

Using different namespaces ensures a clear separation between infrastructure
components and application workloads.

## Project Architecture
- **Frontend:** React application served via a container image.
- **Backend:** Node.js (Express) service exposing a REST API.
- **CI/CD:** Jenkins pipelines build and test the application, then produce
docker images.
- **Infrastructure as Code:** OpenTofu provisions Kubernetes clusters or
namespaces for infrastructure and application workloads.
- **Deployment:** Helm charts deploy images to the target Kubernetes cluster.
- **Monitoring:** Prometheus scrapes metrics and Grafana visualizes them through
dashboards.

## Setup Instructions
1. **Prerequisites**
   - Node.js 18+
   - Docker and a local Kubernetes cluster (e.g. Minikube)
   - Jenkins and OpenTofu installed locally or accessible remotely
2. **Install dependencies**
   ```bash
   cd backend && npm install
   cd ../frontend && npm install
   ```
3. **Run tests**
   ```bash
   npm test   # run inside both backend/ and frontend/
   ```
4. **Start services locally**
   ```bash
   cd backend && npm start
   cd frontend && npm start
   ```

## Deployment Flow
1. Code changes are pushed to the repository.
2. Jenkins pipeline builds, tests, and packages the frontend and backend into
   container images.
3. OpenTofu provisions or updates the target Kubernetes infrastructure.
4. Helm charts deploy the new images to the cluster.
5. Prometheus and Grafana automatically begin monitoring the deployed
   application.

## Monitoring & Pipeline Links
- Grafana dashboards: <https://grafana.example.com/d/devops>
- Jenkins pipeline results: <https://jenkins.example.com/job/devops-deployment-system>

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to
this project.
