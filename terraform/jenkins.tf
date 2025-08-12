# Jenkins via Helm + JCasC + Job DSL
# Cria dois Multibranch Pipeline Jobs:
# - frontend -> lê frontend/Jenkinsfile
# - backend  -> lê backend/Jenkinsfile

variable "jenkins_admin_user" { default = "admin" }
variable "jenkins_admin_pass" { default = "pass" }

resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace  = kubernetes_namespace.infra.metadata[0].name
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.8.75"

  wait            = true
  timeout         = 1200
  atomic          = true
  cleanup_on_fail = true

  # in jenkins.tf (inside helm_release "jenkins")
  values = [yamlencode({
    controller = {
      admin = {
        username = var.jenkins_admin_user
        password = var.jenkins_admin_pass
      }
      serviceType    = "NodePort"

      # Plugins needed for JCasC + Job DSL + Multibranch Pipelines
      installPlugins = [
        "configuration-as-code",
        "job-dsl",
        "workflow-aggregator",
        "workflow-multibranch",
        "git",
        "credentials",
        "credentials-binding",
        "matrix-auth",
        "kubernetes"
      ]

      containerEnv = [
        { name = "REPO_URL",          value = "https://github.com/CGTA-Solucoes-Tecnologicas/devops-deployment-system.git" },
        { name = "GIT_CREDENTIALS_ID", value = "" },     # set if repo is private
        { name = "DEFAULT_BRANCH",     value = "main" }
      ]

      # Jenkins Configuration as Code + embedded Job DSL
      JCasC = {
        defaultConfig = false
        configScripts = {
          # Do NOT end with .yaml (sidecar appends .yaml automatically)
          "jenkins-casc" = <<-EOT
            jenkins:
              systemMessage: "Managed by JCasC (Helm)"
              numExecutors: 2
              mode: NORMAL

            jobs:
              - script: >
                  def repo = System.getenv('REPO_URL');
                  def creds = System.getenv('GIT_CREDENTIALS_ID');
                  def defBr = System.getenv('DEFAULT_BRANCH') ?: 'main';

                  multibranchPipelineJob('frontend') {
                    displayName('frontend (MBP)')
                    branchSources {
                      branchSource {
                        source {
                          git {
                            id('frontend-src')
                            remote(repo)
                            if (creds) { credentialsId(creds) }
                          }
                        }
                        strategy {
                          defaultBranchPropertyStrategy { props { } }
                        }
                      }
                    }
                    factory {
                      workflowBranchProjectFactory {
                        scriptPath('frontend/Jenkinsfile')
                      }
                    }
                    // No webhook? Do scan periodically:
                    triggers { periodicFolderTrigger { interval('2m') } }
                  }

                  multibranchPipelineJob('backend') {
                    displayName('backend (MBP)')
                    branchSources {
                      branchSource {
                        source {
                          git {
                            id('backend-src')
                            remote(repo)
                            if (creds) { credentialsId(creds) }
                          }
                        }
                        strategy {
                          defaultBranchPropertyStrategy { props { } }
                        }
                      }
                    }
                    factory {
                      workflowBranchProjectFactory {
                        scriptPath('backend/Jenkinsfile')
                      }
                    }
                    triggers { periodicFolderTrigger { interval('2m') } }
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
