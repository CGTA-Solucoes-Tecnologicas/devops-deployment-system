# Contributing Guidelines

Thank you for considering a contribution to this project. The following
standards help us maintain a clean and reliable codebase.

## Coding Standards
- Use clear, self-documenting code with consistent formatting.
- Prefer JavaScript ES6+ features and include tests for new functionality.
- Run `npm test` in both `backend/` and `frontend/` before submitting a pull
  request.

## Branching Strategy
- Work on feature branches created from `main` using the pattern
  `feature/<description>` or `bugfix/<description>`.
- Rebase frequently on top of `main` to minimize merge conflicts.
- Push branches to the remote repository and open a pull request when ready.

## Review Process
- Ensure the Jenkins pipeline succeeds before requesting review: <https://jenkins.example.com/job/devops-deployment-system>
- Provide a clear description of changes and reference any relevant issues.
- At least one approval is required before merging.

## Monitoring Links
- Grafana dashboards for observability: <https://grafana.example.com/d/devops>

Following these guidelines helps streamline collaboration and keeps the project
healthy. Thank you for your contributions!
