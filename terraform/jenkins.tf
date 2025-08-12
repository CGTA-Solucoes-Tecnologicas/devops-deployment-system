# Uses the official Jenkins chart (charts.jenkins.io) with admin creds,
# Jenkins with JCasC + GitHub Organization Folder auto-discovery

variable "jenkins_admin_user" { default = "admin" }
variable "jenkins_admin_pass" { default = "pass" }

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = kubernetes_namespace.infra.metadata[0].name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.75"

  wait             = true
  timeout          = 1200
  atomic           = true
  cleanup_on_fail  = true

  values = [yamlencode({
    controller = {
      admin = {
        username = var.jenkins_admin_user
        password = var.jenkins_admin_pass
      }
      serviceType = "NodePort"     # expose on Minikube

      installPlugins = [
        "configuration-as-code",
        "job-dsl",
        "workflow-aggregator",
        "workflow-multibranch",
        "git",
        "github-branch-source",
        "branch-api",
        "credentials",
        "credentials-binding",
        "matrix-auth"
      ]

      # Env vars consumed by the Job DSL (edit these!)
      containerEnv = [
        { name = "GITHUB_ORG",        value = "CGTA-Solucoes-Tecnologicas" },
        { name = "GIT_CREDENTIALS_ID", value = "" },            
        { name = "DEFAULT_BRANCH",     value = "main" }
      ]

      # JCasC + Job DSL: cria um GitHub Organization Folder que auto-descobre repos com Jenkinsfile
      JCasC = {
        configScripts = {
          "jenkins-casc.yaml" = <<-EOT
            jenkins:
              systemMessage: "Managed by JCasC (Helm)"
              numExecutors: 2
              mode: NORMAL
              # If you plan to use GitHub webhooks, set a stable public URL here (Ingress is recommended):
              # location:
              #   url: "http://jenkins.your-domain.example/"

            # (Optional) Example of Git token credential for private repos:
            #credentials:
            #  system:
            #    domainCredentials:
            #      - credentials:
            #          - string:
            #              id: "git-token"
            #              description: "GitHub Personal Access Token"
            #              secret: "REPLACE_ME"

            jobs:
              - script: >
                  import jenkins.branch.OrganizationFolder;
                  import jenkins.scm.impl.trait.WildcardSCMHeadFilterTrait;
                  import org.jenkinsci.plugins.github_branch_source.*;

                  def org  = System.getenv('GITHUB_ORG') ?: 'example';
                  def creds = System.getenv('GIT_CREDENTIALS_ID');
                  def defBranch = System.getenv('DEFAULT_BRANCH') ?: 'main';

                  organizationFolder("apps") {
                    displayName("Apps (auto-discovered)")
                    organizations {
                      github {
                        repoOwner(org)
                        if (creds) { credentialsId(creds) }
                        // Discover branches & PRs
                        traits {
                          gitHubBranchDiscovery { strategyId(1) }               // build branches
                          originPullRequestDiscoveryTrait { strategyId(1) }     # build PRs from origin
                          forkPullRequestDiscoveryTrait {
                            strategyId(1); trust(class: 'TrustPermission')
                          }
                        }
                      }
                    }
                    projectFactories {
                      workflowMultiBranchProjectFactory {
                        scriptPath("Jenkinsfile")   // any repo with a Jenkinsfile is onboarded
                      }
                    }
                    orphanedItemStrategy {
                      discardOldItems { numToKeep(20) }
                    }
                    // Scan every 2 minutes (works without webhooks)
                    triggers { periodicFolderTrigger { interval("2m") } }
                    // If you prefer webhook, comment out the line above and configure githubPush() in jobs, and the webhook in GitHub.
                  }
          EOT
        }
      }

      resources = {
        requests = { cpu = "500m", memory = "1Gi" }
        limits   = { cpu = "1",    memory = "2Gi" }
      }
    }
  })]
}
