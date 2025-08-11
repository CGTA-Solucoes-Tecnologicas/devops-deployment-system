output "jenkins_node_port" {
  value = helm_release.jenkins.status[0].service[0].node_port
}
