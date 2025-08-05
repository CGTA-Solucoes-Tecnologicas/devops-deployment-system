# DevOps Kata

This project demonstrates a simple deployment system for a sample application. It
combines a React frontend with a Node.js backend and uses common DevOps tooling
to automate infrastructure provisioning, application deployment, and
observability.

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
