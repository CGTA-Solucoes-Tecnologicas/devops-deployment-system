DevOps Kata
- Build a deployment system with:
  - Jenkins
  - Helm
  - OpenTofu
  - Minikub or other kubernetes cluster manager
  - Prometheus
  - Grafana

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


