resource "azurerm_subnet" "machine_subnet" {
  name                 = "${local.name_prefix}-openai-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = "${local.name_prefix}-vnet"
  address_prefixes     = [var.azureopenai_subnet_cidr]
  service_endpoints    = ["Microsoft.CognitiveServices"]
}

module "openai" {
  source              = "Azure/openai/azurerm"
  version             = "0.1.1"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  private_endpoint = {
    "pe_endpoint" = {
      private_dns_entry_enabled       = true
      dns_zone_virtual_network_link   = "dns_zone_link_openai"
      is_manual_connection            = false
      name                            = "openai_pe"
      private_service_connection_name = "openai_pe_connection"
      subnet_name                     = "${local.name_prefix}-openai-subnet"
      vnet_name                       = module.vnet.vnet_name
      vnet_rg_name                    = azurerm_resource_group.this.name
    }
  }
  deployment = {
    "chat_model" = {
      name          = "gpt-35-turbo"
      model_format  = "OpenAI"
      model_name    = "gpt-35-turbo"
      model_version = "0301"
      scale_type    = "Standard"
      capacity      = 120
    },
    "embedding_model" = {
      name          = "text-embedding-ada-002"
      model_format  = "OpenAI"
      model_name    = "text-embedding-ada-002"
      model_version = "2"
      scale_type    = "Standard"
      capacity      = 120
    },
  }
  depends_on = [
    azurerm_resource_group.this,
    module.vnet
  ]
}

resource "azurerm_private_dns_zone" "openai" {
  name                = "aro-azureopenai.openai.azure.com"
  resource_group_name = azurerm_resource_group.this.name
}
