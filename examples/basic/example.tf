provider "azurerm" {
  features {}
}

module "eventhub" {
  source = "../../"
}
