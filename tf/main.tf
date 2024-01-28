locals {
  name_prefix = "aro-${var.cluster_name}"
}

resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-rg"
  location = var.location

}

