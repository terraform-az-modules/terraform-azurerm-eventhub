provider "azurerm" {
  features {}
}

locals {
  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]
}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source  = "terraform-az-modules/resource-group/azurerm"
  version = "1.0.1"

  name                     = local.name
  environment              = local.environment
  label_order              = local.label_order
  location                 = "North Europe"
  resource_position_prefix = false
}


module "vnet" {
  source              = "terraform-az-modules/vnet/azurerm"
  version             = "1.0.3"
  name                = "app"
  environment         = "test"
  label_order         = ["name", "environment"]
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_spaces      = ["10.0.0.0/16"]
}

module "subnet" {
  source               = "terraform-az-modules/subnet/azurerm"
  version              = "1.0.1"
  environment          = "test"
  label_order          = ["name", "environment", ]
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  subnets = [
    {
      name            = "subnet1"
      subnet_prefixes = ["10.0.1.0/24"]
    }
  ]
  enable_route_table = true
  route_tables = [
    {
      name = "route-table"
      routes = [
        {
          name           = "route-table"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "Internet"
        }
      ]
    }
  ]
}

data "azurerm_eventhub_namespace_authorization_rule" "default" {
  depends_on          = [module.eventhub, module.resource_group]
  name                = "RootManageSharedAccessKey"
  namespace_name      = module.eventhub.eventhub_namespace_name
  resource_group_name = module.resource_group.resource_group_name
}


# ------------------------------------------------------------------------------
# Log Analytics
# ------------------------------------------------------------------------------
module "log-analytics" {
  source                      = "terraform-az-modules/log-analytics/azurerm"
  version                     = "1.0.2"
  name                        = "core"
  environment                 = "dev"
  label_order                 = ["name", "environment", "location"]
  log_analytics_workspace_sku = "PerGB2018"
  resource_group_name         = module.resource_group.resource_group_name
  location                    = module.resource_group.resource_group_location
  log_analytics_workspace_id  = module.log-analytics.workspace_id
}

module "eventhub" {
  source              = "../../"
  name                = local.name
  label_order         = local.label_order
  environment         = local.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  sku                 = "Standard"
  capacity            = 1
  authorization_rules = [
    {
      name   = "app-diagnostics-send"
      send   = true
      listen = true
      manage = true
    }
  ]

  hubs = [
    {
      name              = "app-test-logs"
      partitions        = 8
      message_retention = 1
      consumers = [
        "app-group",
      ]
      keys = [
        {
          name   = "app-key"
          listen = true
          send   = false
        },
      ]
    }
  ]
}


# ------------------------------------------------------------------------------
# Key Vault
# ------------------------------------------------------------------------------
module "vault" {
  source                        = "terraform-az-modules/key-vault/azurerm"
  version                       = "1.0.1"
  name                          = "app23"
  environment                   = "dev"
  label_order                   = ["name", "environment", "location"]
  resource_group_name           = module.resource_group.resource_group_name
  location                      = module.resource_group.resource_group_location
  subnet_id                     = module.subnet.subnet_ids.subnet1
  public_network_access_enabled = true
  sku_name                      = "standard"
  enable_private_endpoint       = false
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = ["0.0.0.0/0"]
  }
  diagnostic_setting_enable      = true
  eventhub_name                  = module.eventhub.eventhub_name["app-test-logs"]
  eventhub_authorization_rule_id = data.azurerm_eventhub_namespace_authorization_rule.default.id
  log_analytics_workspace_id     = module.log-analytics.workspace_id
}
