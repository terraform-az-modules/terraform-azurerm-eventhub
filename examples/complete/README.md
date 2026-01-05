<!-- BEGIN_TF_DOCS -->

# Terraform Azure Eventhub

This directory contains an example usage of the **terraform-azure-eventhub**. It demonstrates how to use the module with default settings or with custom configurations.

---
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.116.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.57.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eventhub"></a> [eventhub](#module\_eventhub) | ../../ | n/a |
| <a name="module_log-analytics"></a> [log-analytics](#module\_log-analytics) | terraform-az-modules/log-analytics/azurerm | 1.0.2 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-az-modules/resource-group/azurerm | 1.0.1 |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | terraform-az-modules/subnet/azurerm | 1.0.1 |
| <a name="module_vault"></a> [vault](#module\_vault) | terraform-az-modules/key-vault/azurerm | 1.0.1 |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | terraform-az-modules/vnet/azurerm | 1.0.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_eventhub_namespace_authorization_rule.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/eventhub_namespace_authorization_rule) | data source |

---

## 🔧 Inputs

No input variables are defined in this example.

---

## 📤 Outputs

No outputs are defined in this example.

<!-- END_TF_DOCS -->
