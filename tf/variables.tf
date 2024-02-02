variable "cluster_name" {
  type        = string
  default     = "my-aro-cluster"
  description = "ARO cluster name"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  default     = null
  description = "ARO resource group name"
}

variable "azureopenai_subnet_cidr" {
  type        = string
  default     = "10.0.14.0/24"
  description = "cidr range for aro virtual network"
}
