output "jenkins_public_ip" {
  description = "IP público da vm-jenkins-lab"
  value       = azurerm_public_ip.jenkins.ip_address
}

output "app_public_ip" {
  description = "IP público da vm-app-lab"
  value       = azurerm_public_ip.app.ip_address
}

output "jenkins_url" {
  description = "URL do Jenkins"
  value       = "http://${azurerm_public_ip.jenkins.ip_address}:8080"
}

output "ssh_jenkins" {
  description = "Comando SSH para vm-jenkins-lab"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.jenkins.ip_address}"
}

output "ssh_app" {
  description = "Comando SSH para vm-app-lab"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.app.ip_address}"
}
