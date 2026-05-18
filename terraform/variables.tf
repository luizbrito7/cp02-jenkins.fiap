variable "resource_group_name" {
  description = "Nome do resource group no Azure"
  type        = string
  default     = "rg-cp02-jenkins-lab"
}

variable "location" {
  description = "Região Azure"
  type        = string
  default     = "eastus"
}

variable "vm_size" {
  description = "Tamanho das VMs"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Usuário admin das VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Caminho para a chave pública SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
